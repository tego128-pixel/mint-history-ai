#!/data/data/com.termux/files/usr/bin/bash
HIST_FILE="$HOME/.bash_history"
P_NOTS_FILE="$HOME/p-nots"
MODE_FILE="$PREFIX/tmp/fzf_mode_$$"
echo "hist" > "$MODE_FILE"

touch "$HIST_FILE" "$P_NOTS_FILE"

# دالة التبديل بـ Tab
toggle_list() {
    if [ "$(cat "$MODE_FILE")" = "hist" ]; then
        echo "notes" > "$MODE_FILE"
        grep -v -E "^(=+|-+|\s*)$" "$P_NOTS_FILE"
    else
        echo "hist" > "$MODE_FILE"
        awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' "$HIST_FILE" | awk '!seen[$0]++'
    fi
}
export -f toggle_list
export HIST_FILE P_NOTS_FILE MODE_FILE

# واجهة fzf متوافقة مع كيبورد الموبايل
awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' "$HIST_FILE" | awk '!seen[$0]++' | \
fzf --prompt="📱 السجل > " \
    --header="[Tab]: تبديل | [Ctrl+Y]: نسخ | [Ctrl+P]: حفظ بشرح | [Ctrl+G]: شرح" \
    --bind 'tab:reload(bash -c toggle_list)+change-prompt(🔄 تم التبديل > )' \
    --bind "ctrl-y:execute-silent(echo -n {} | sed 's/\s*#.*//' | termux-clipboard-set)" \
    --bind 'ctrl-p:execute(if [ "$(cat "$MODE_FILE")" = "hist" ]; then CMD={}; DESC=$(tgpt -q "اشرح هذا الأمر في 5 كلمات عربية فقط: $CMD" | tr -d "\n") && echo "$CMD   # $DESC" >> "$P_NOTS_FILE" && echo "✅ تم الحفظ" && sleep 1; fi)' \
    --bind 'ctrl-g:execute(CMD=$(echo {} | sed "s/\s*#.*//"); tgpt -q "اشرح هذا الأمر باختصار شديد وبالعامية المصرية: $CMD" && echo -e "\n--- اضغط Enter ---" && read)' \
    --height=100% --layout=reverse --border

rm -f "$MODE_FILE" 2>/dev/null
