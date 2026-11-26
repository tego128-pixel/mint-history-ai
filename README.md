# 🚀 Mint History AI (fzf + tgpt)

## 📥 التحميل والتثبيت (الإصدار 1.1)

لتحميل نسخ الكمبيوتر (`.deb`) والموبايل (`Termux`)، اضغط على رابط صفحة التحميلات الرسمي بالأسفل:

https://github.com

### 💻 طريقة التثبيت على الكمبيوتر (Linux Mint / Ubuntu / Debian)
* حمّل ملف `mint-history-ai_1.1_amd64.deb` من الرابط أعلاه، ثم اضغط عليه مرتين واختر **Install** (ستظهر أيقونة البرنامج على سطح المكتب تلقائياً).

### 📱 طريقة التثبيت على الموبايل (Termux Android)
* حمّل ملف `mint-history-termux_1.1_aarch64.deb` من الرابط أعلاه، ثم افتح Termux ونفّذ هذا الأمر:
```bash
termux-setup-storage && pkg update && pkg install -y ~/storage/downloads/mint-history-termux_1.1_aarch64.deb
```

---

### 🇸🇦 الشرح للمبتدئين في لينكس:
في نظام لينكس، يوجد ملف مخفي في مجلدك الشخصي (Home) اسمه **`.bash_history`**، وهو بمثابة **سجل** يُخزّن فيه كل الأوامر التي تكتبها في التيرمينال.

يقوم هذا السكريبت بربط هذا السجل بأداة بحث سريعة جداً اسمها **`fzf`** لتستفيد من سرعة البحث الفوري في أوامرك القديمة، بالإضافة إلى ربطه بأداة الذكاء الاصطناعي المجانية **`tgpt`** (بدون الحاجة لأي حساب أو مفتاح API).

#### 💡 فكرة عمل الأداة:
1. **تنظيف وعرض السجل تلقائياً:** عند تشغيل السكريبت، يقوم بتنظيف سجل `.bash_history` من التكرار والسطور التالفة ويعرض لك أحدث أوامرك أولاً لتبحث فيها بسرعة.
2. **ملف ملاحظاتك الدائمة (`~/p-nots`):** يقوم السكريبت بإنشاء ملف نصي في مجلد الهوم باسم **`p-nots`** ليكون بمثابة "كشكول أوامرك المفضلة"، وتستطيع التنقل بين **السجل** وملف **`p-nots`** بضغطة واحدة على زرار **`Tab`** وبنفس سرعة وخواص البحث!
3. **شرح وحفظ الأوامر بالذكاء الاصطناعي:** بفضل ربط أداة **`tgpt`** بالسكريبت، يمكنك شرح أي أمر غريب بالعربي أو حفظه مع تلخيص وظيفته بضغطة زر.
4. **دعم شامل لكل البيئات (`Bash` / `Zsh` / `Fish`):** يكتشف نوع الـ Shell تلقائياً على الكمبيوتر والموبايل ويقرأ وينظف سجله فوراً بدون أي تعديل منك.

---

### ⌨️ اختصارات الاستخدام داخل الأداة:

| الزر / الاختصار | الوظيفة |
| :--- | :--- |
| **`Tab`** | التبديل الفوري بين **السجل (`.bash_history`)** وملف الملاحظات **`p-nots`**. |
| **`Alt + C`** | نسخ الأمر المحدد (Copy) جاهزاً للّصق والتشغيل في التيرمينال فوراً بدون التعليق العربي. |
| **`Alt + P`** | حفظ الأمر في ملف **`p-nots`** مع إضافة تعليق تلقائي يشرح وظيفة الأمر بالعربي، ليصبح لديك مرجع دائم لأوامرك. |
| **`Alt + G`** | استدعاء أداة **`tgpt`** لتشرح لك هذا الأمر بالتفصيل وبالعامية المصرية داخل التيرمينال. |
| **`ESC`** | الخروج من الأداة. |

---

### 📦 المتطلبات وطريقة التشغيل (للمبتدئين):

**1. تثبيت الأدوات المساعدة (`fzf` و `xclip`):**
```bash
sudo apt update && sudo apt install -y fzf xclip curl
```

**2. تثبيت أداة الذكاء الاصطناعي المجانية (`tgpt`):**
```bash
curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin
```

**3. تحميل وتشغيل السكريبت:**
```bash
git clone https://github.com/tego128-pixel/mint-history-ai.git
cd mint-history-ai
chmod +x mint-command.sh
./mint-command.sh
```

---
---

### 🇺🇸 English Overview (For Linux Beginners):
In Linux, `.bash_history` is a hidden file in your Home directory that logs every command you run in the terminal. This script connects your command history to **`fzf`** (a blazing-fast fuzzy finder) and **`tgpt`** (a free CLI AI tool that requires no API key).

#### 💡 How It Works:
- **Auto-Cleaned History:** Automatically removes duplicates and corrupted paste lines from `.bash_history` and shows your latest commands first.
- **Personal Command Book (`~/p-nots`):** Creates a `p-nots` file in your Home folder to store your favorite commands. Press **`Tab`** anytime to switch instantly between your **History** and **`p-nots`** with full search capabilities.
- **AI-Powered Explanations & Notes:** Uses `tgpt` to explain any command or auto-generate a short summary comment when saving it.

#### ⌨️ Keyboard Shortcuts:
- **`Tab`**: Switch instantly between **History** and **`p-nots`**.
- **`Alt + C`**: Copy the clean command to your clipboard (strips `#` comments so it runs immediately).
- **`Alt + P`**: Save the command to `~/p-nots` along with an auto-generated Arabic summary comment.
- **`Alt + G`**: Explain the selected command in detail using **`tgpt`**.
- **`ESC`**: Exit.

---

## 📸 صور من داخل الأداة | Screenshots
*(اسحب صورك وأفلتها هنا في الأسفل)*

<img width="1079" height="340" alt="صوره الباشهيستورى ذاكره اوامر الترمنال" src="https://github.com/user-attachments/assets/96f4cfec-f94b-4ccc-8764-e08490202e63" />
<img width="1381" height="893" alt="tgpt(ai in teminal)" src="https://github.com/user-attachments/assets/318d41a4-2ec2-46ab-94b2-9218a0642d82" />

