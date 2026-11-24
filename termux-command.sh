#!/data/data/com.termux/files/usr/bin/bash
rm -f "$PREFIX"/tmp/fzf_hist_clean_$$ 2>/dev/null

# --- 1. اكتشاف نوع الـ Shell تلقائياً على Termux (Bash / Zsh / Fish) ---
USER_SHELL=$(basename "$SHELL")
P_NOTS_FILE="$HOME/p-nots"
MODE_FILE="$PREFIX/tmp/fzf_mode_$$"
CLEAN_HIST="$PREFIX/tmp/fzf_hist_clean_$$"
echo "hist" > "$MODE_FILE"
touch "$P_NOTS_FILE"

if [ "$USER_SHELL" = "zsh" ] && [ -f "$HOME/.zsh_history" ]; then
    HIST_FILE="$HOME/.zsh_history"
    sed 's/^: [0-9]*:[0-9]*;//' "$HIST_FILE" > "$CLEAN_HIST"
elif [ "$USER_SHELL" = "fish" ] && [ -f "$HOME/.local/share/fish/fish_history" ]; then
    HIST_FILE="$HOME/.local/share/fish/fish_history"
    grep "^- cmd: " "$HIST_FILE" | sed 's/^- cmd: //' > "$CLEAN_HIST"
else
    HIST_FILE="$HOME/.bash_history"
    touch "$HIST_FILE"
    cp "$HIST_FILE" "$CLEAN_HIST"
fi

# تنظيف عام لقائمة العرض
grep -v -E "^(ls|cd|exit|clear|\s*)$" "$CLEAN_HIST" > "${CLEAN_HIST}.tmp" && mv "${CLEAN_HIST}.tmp" "$CLEAN_HIST"

# --- 2. دالة التبديل الذكي بزرار Tab ---
toggle_list() {
    if [ "$(cat "$MODE_FILE")" = "hist" ]; then
        echo "notes" > "$MODE_FILE"
        grep -v -E "^(=+|-+|\s*)$" "$P_NOTS_FILE"
    else
        echo "hist" > "$MODE_FILE"
        awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' "$CLEAN_HIST" | awk '!seen[$0]++'
    fi
}
export -f toggle_list
export CLEAN_HIST P_NOTS_FILE MODE_FILE

# --- 3. واجهة fzf متوافقة مع كيبورد الموبايل ---
awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' "$CLEAN_HIST" | awk '!seen[$0]++' | \
fzf --prompt="📱 السجل ($USER_SHELL) > " \
    --header="[Tab]: تبديل | [Ctrl+Y]: نسخ | [Ctrl+P]: حفظ بشرح | [Ctrl+G]: شرح" \
    --bind 'tab:reload(bash -c toggle_list)+change-prompt(🔄 تم التبديل > )' \
    --bind "ctrl-y:execute-silent(echo -n {} | sed 's/\s*#.*//' | termux-clipboard-set)" \
    --bind 'ctrl-p:execute(if [ "$(cat "$MODE_FILE")" = "hist" ]; then CMD={}; DESC=$(tgpt -q "اشرح هذا الأمر في 5 كلمات عربية فقط: $CMD" | tr -d "\n") && echo "$CMD   # $DESC" >> "$P_NOTS_FILE" && echo "✅ تم الحفظ" && sleep 1; fi)' \
    --bind 'ctrl-g:execute(CMD=$(echo {} | sed "s/\s*#.*//"); tgpt -q "اشرح هذا الأمر باختصار شديد وبالعامية المصرية: $CMD" && echo -e "\n--- اضغط Enter ---" && read)' \
    --height=100% --layout=reverse --border

# --- 4. تنظيف تلقائي ---
rm -f "$MODE_FILE" "$CLEAN_HIST" 2>/dev/null
