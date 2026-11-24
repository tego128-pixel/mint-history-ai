#!/bin/bash
rm -f "$HOME"/.bash_history-*.tmp /tmp/fzf_hist_clean_$$ 2>/dev/null

# --- 1. اكتشاف نوع الـ Shell تلقائياً (Bash / Zsh / Fish) ---
USER_SHELL=$(basename "$SHELL")
P_NOTS_FILE="$HOME/p-nots"
MODE_FILE="/tmp/fzf_mode_$$"
CLEAN_HIST="/tmp/fzf_hist_clean_$$"
echo "hist" > "$MODE_FILE"
touch "$P_NOTS_FILE"

if [ "$USER_SHELL" = "zsh" ] && [ -f "$HOME/.zsh_history" ]; then
    HIST_FILE="$HOME/.zsh_history"
    # إزالة طابع الوقت الخاص بـ zsh (مثل : 1700000000:0;)
    sed 's/^: [0-9]*:[0-9]*;//' "$HIST_FILE" > "$CLEAN_HIST"
elif [ "$USER_SHELL" = "fish" ] && [ -f "$HOME/.local/share/fish/fish_history" ]; then
    HIST_FILE="$HOME/.local/share/fish/fish_history"
    # استخراج الأوامر فقط من سجل fish
    grep "^- cmd: " "$HIST_FILE" | sed 's/^- cmd: //' > "$CLEAN_HIST"
else
    history -a 2>/dev/null
    history -r 2>/dev/null
    HIST_FILE="$HOME/.bash_history"
    if [ ! -f "$HIST_FILE" ]; then
        echo "خطأ: تأكد من وجود ملف .bash_history في الهوم!"
        exit 1
    fi
    # تنظيف ملف .bash_history الأصلي من السطور التالفة
    grep -v -E "\[200~" "$HIST_FILE" | \
    grep -v -E "[أ-ي]" | \
    grep -v -E "^(\[.*\]|EOF|Terminal=|Type=|Icon=|Comment=|Name=|Exec=)" | \
    grep -v -E "^(\[|\]|\\\|\^|\~|\`|\?|\!|\@|\#|\$|\%|\&|\*|\(|\)|\{\}|\<\>|\[\]|\s*)$" | \
    grep -v -E "^(ls|cd|exit|clear)$" > "${HIST_FILE}.tmp" && mv "${HIST_FILE}.tmp" "$HIST_FILE"
    cp "$HIST_FILE" "$CLEAN_HIST"
fi

# تنظيف عام لقائمة العرض
grep -v -E "^(ls|cd|exit|clear|\s*)$" "$CLEAN_HIST" > "${CLEAN_HIST}.tmp" && mv "${CLEAN_HIST}.tmp" "$CLEAN_HIST"

# --- 2. دالة التبديل الذكي بزرار Tab واحد ---
toggle_list() {
    if [ "$(cat "$MODE_FILE")" = "hist" ]; then
        echo "notes" > "$MODE_FILE"
        grep -v -E "^(=+|-+|\s*)$" "$P_NOTS_FILE" | tac
    else
        echo "hist" > "$MODE_FILE"
        tac "$CLEAN_HIST" | awk '!seen[$0]++'
    fi
}
export -f toggle_list
export CLEAN_HIST P_NOTS_FILE MODE_FILE

# --- 3. تشغيل الواجهة التفاعلية ---
tac "$CLEAN_HIST" | awk '!seen[$0]++' | \
fzf --prompt="📂 السجل ($USER_SHELL) > " \
    --header="[Tab]: تبديل (السجل ⇄ p-nots) | [Alt+C]: نسخ | [Alt+P]: حفظ بشرح | [Alt+G]: شرح | [ESC]: خروج" \
    --bind 'tab:reload(bash -c toggle_list)+change-prompt(🔄 تم التبديل > )' \
    --bind "alt-c:execute-silent(echo -n {} | sed 's/\s*#.*//' | xclip -selection clipboard)" \
    --bind 'alt-p:execute(if [ "$(cat "$MODE_FILE")" = "hist" ]; then CMD={}; echo -e "⏳ جاري تلخيص وحفظ الأمر..." && DESC=$(tgpt -q "اشرح هذا الأمر في 5 كلمات عربية فقط بدون أي مقدمات أو رموز: $CMD" | tr -d "\n") && echo "$CMD   # $DESC" >> "$P_NOTS_FILE" && echo -e "✅ تم الحفظ:\n$CMD   # $DESC" && sleep 1.5; fi)' \
    --bind 'alt-g:execute(CMD=$(echo {} | sed "s/\s*#.*//"); echo -e "⏳ جاري الشرح...\n" && tgpt -q "اشرح هذا الأمر في لينكس باختصار شديد وبالعامية المصرية: $CMD" && echo -e "\n--- اضغط Enter للعودة ---" && read)' \
    --height=100% --layout=reverse --border

# --- 4. تنظيف تلقائي ---
rm -f "$MODE_FILE" "$CLEAN_HIST" "$HOME"/.bash_history-*.tmp 2>/dev/null
