#!/bin/bash
rm -f "$HOME"/.bash_history-*.tmp 2>/dev/null

# --- 1. مزامنة الهيستوري فوراً في الجلسة الحالية ---
history -a
history -r

# --- 2. تعريف المسارات الأساسية ---
HIST_FILE="$HOME/.bash_history"
P_NOTS_FILE="$HOME/p-nots"
MODE_FILE="/tmp/fzf_mode_$$"
echo "hist" > "$MODE_FILE"

touch "$P_NOTS_FILE"

if [ ! -f "$HIST_FILE" ]; then
    echo "خطأ: تأكد من وجود ملف .bash_history في الهوم!"
    exit 1
fi

# --- 3. تنظيف ملف .bash_history الأصلي من السطور التالفة والمكررة ---
grep -v -E "\[200~" "$HIST_FILE" | \
grep -v -E "[أ-ي]" | \
grep -v -E "^(\[.*\]|EOF|Terminal=|Type=|Icon=|Comment=|Name=|Exec=)" | \
grep -v -E "^(\[|\]|\\\|\^|\~|\`|\?|\!|\@|\#|\$|\%|\&|\*|\(|\)|\{\}|\<\>|\[\]|\s*)$" | \
grep -v -E "^(ls|cd|exit|clear)$" > "${HIST_FILE}.tmp" && mv "${HIST_FILE}.tmp" "$HIST_FILE"

# --- 4. دالة التبديل الذكي بزرار Tab واحد ---
toggle_list() {
    if [ "$(cat "$MODE_FILE")" = "hist" ]; then
        echo "notes" > "$MODE_FILE"
        grep -v -E "^(=+|-+|\s*)$" "$P_NOTS_FILE"
    else
        echo "hist" > "$MODE_FILE"
        tac "$HIST_FILE" | awk '!seen[$0]++'
    fi
}
export -f toggle_list
export HIST_FILE P_NOTS_FILE MODE_FILE

# --- 5. تشغيل الواجهة التفاعلية ---
tac "$HIST_FILE" | awk '!seen[$0]++' | \
fzf --prompt="📂 السجل > " \
    --header="[Tab]: تبديل (السجل ⇄ p-nots) | [Alt+C]: نسخ | [Alt+P]: حفظ بشرح | [Alt+G]: شرح | [ESC]: خروج" \
    --bind 'tab:reload(bash -c toggle_list)+change-prompt(🔄 تم التبديل > )' \
    --bind "alt-c:execute-silent(echo -n {} | sed 's/\s*#.*//' | xclip -selection clipboard)" \
    --bind 'alt-p:execute(if [ "$(cat "$MODE_FILE")" = "hist" ]; then CMD={}; echo -e "⏳ جاري تلخيص وحفظ الأمر..." && DESC=$(tgpt -q "اشرح هذا الأمر في 5 كلمات عربية فقط بدون أي مقدمات أو رموز: $CMD" | tr -d "\n") && echo "$CMD   # $DESC" >> "$P_NOTS_FILE" && echo -e "✅ تم الحفظ:\n$CMD   # $DESC" && sleep 1.5; fi)' \
    --bind 'alt-g:execute(CMD=$(echo {} | sed "s/\s*#.*//"); echo -e "⏳ جاري الشرح...\n" && tgpt -q "اشرح هذا الأمر في لينكس باختصار شديد وبالعامية المصرية: $CMD" && echo -e "\n--- اضغط Enter للعودة ---" && read)' \
    --height=100% --layout=reverse --border

# --- 6. تنظيف تلقائي ---
rm -f "$MODE_FILE" "$HOME"/.bash_history-*.tmp 2>/dev/null
