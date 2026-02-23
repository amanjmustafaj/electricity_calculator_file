# 🚀 دەستپێکردنی خێرا / Quick Start Guide

## ١. کۆپی کردنی فایلەکان / Copy Files

```bash
# کۆپی کردنی هەموو پرۆژەکە
cp -r electricity_app/ /your/flutter/projects/

# چوونە ناو فۆڵدەرەکە
cd /your/flutter/projects/electricity_app
```

## ٢. دابەزاندنی Dependencies

```bash
flutter pub get
```

## ٣. ڕانکردن / Run

```bash
# بۆ Android/iOS
flutter run

# یان بۆ هەڵبژاردنی ئامێر
flutter run -d device_id
```

---

## 📁 پێکهاتەی سەرەکی / Main Structure

```
lib/
├── 📱 main.dart                 → Entry point
├── 📊 models/                   → Data models
├── 🛠️ utils/                    → Helper functions
├── 📦 constants/                → Fixed data
├── 🎨 widgets/shared/           → Reusable widgets
└── 📄 screens/                  → App pages
    ├── splash_screen.dart
    ├── main_navigation.dart
    ├── price_calc_page.dart
    ├── technical_calc_page.dart
    ├── info_page.dart
    └── settings_page.dart
```

---

## 🎯 گۆڕانکاری خێراکان / Quick Edits

### ڕەنگی سەرەکی بگۆڕە / Change Primary Color
**File:** `lib/main.dart`
```dart
colorSchemeSeed: const Color(0xFFFF6B35),  // ← ئێرە بیگۆڕە
```

### ئامێرێکی نوێ زیاد بکە / Add New Appliance
**File:** `lib/constants/appliance_data.dart`
```dart
'my_device': 2000,  // ← زیادی بکە
```

**File:** `lib/utils/translations.dart`
```dart
'my_device': 'ناوەکەی بە کوردی',     // کوردی
'my_device': 'Name in English',       // English
'my_device': 'الاسم بالعربية',       // عربی
```

### زمانێکی نوێ زیاد بکە / Add New Language
**File:** `lib/utils/translations.dart`
```dart
enum AppLanguage { kurdish, english, arabic, turkish }  // ← turkish زیاد بکە

// پاشان translations-ەکان زیاد بکە...
```

---

## 🔧 چاککردنی باگەکان / Troubleshooting

### خەتای "Package not found"
```bash
flutter clean
flutter pub get
```

### خەتای "Invalid SDK"
```bash
# بەرزکردنەوەی Flutter
flutter upgrade
```

### خەتای Build
```bash
# بۆ Android
flutter build apk --release

# بۆ iOS
flutter build ios --release
```

---

## 📝 تێبینیە گرنگەکان / Important Notes

✅ هەموو فایلەکان بە UTF-8 encode کراون بۆ پشتگیری زمانە جیاوازەکان

✅ هەموو ویجێتەکانی `widgets/shared/` لە چەندین شوێنێک بەکاردێن

✅ هەر گۆڕانکارییەک لە `translations.dart` بکەیت، پێویستە ئەپەکە rebuild بکەیتەوە

✅ بۆ بەکارهێنانی widget-ی Android، config-ی `android/app/` پێویستە

---

## 💡 نموونەی کۆد / Code Examples

### بەکارهێنانی Glass Button
```dart
buildGlassButton(
  onPressed: () => print('clicked'),
  text: 'My Button',
  icon: Icons.check,
  isDark: isDarkMode,
  color: Colors.blue,  // optional
)
```

### بەکارهێنانی Translation
```dart
Text(AppTranslations.get(currentLanguage, 'key_name'))
```

### بەکارهێنانی Number Formatter
```dart
String formatted = formatNumber(1234567.89);  // → "1,234,568"
```

---

بەختەوەر بە! Happy Coding! 🎉
