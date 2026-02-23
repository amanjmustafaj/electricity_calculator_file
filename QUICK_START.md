# ڕێنمایی خێرا | Quick Start Guide

## 🎯 دەست پێکردنی خێرا

```bash
# ١. فایلەکە extract بکە
unzip electricity_app_v1.0.8_COMPLETE.zip

# ٢. بچۆ ناو فۆڵدەرەکە
cd electricity_app_v1.0.8

# ٣. پاککردنەوە و دامەزراندن
flutter clean
flutter pub get

# ٤. ڕانکردن
flutter run
```

---

## 📦 ناوی پاکێج | Package Name

```
✅ com.electricity.calculator
```

**ئەگەر دەتەوێت بیگۆڕیت، فایلی `PACKAGE_NAME.md` بکەرەوە**

---

## 🔧 چارەسەری کێشەکان

### کێشە ١: Share Plus Error

**چارەسەر:**
فایلی `ERROR_FIX.md` بکەرەوە - ٣ ڕێگەی جیاواز تێدایە

### کێشە ٢: Build Failed

```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

### کێشە ٣: Package Name Issues

فایلی `PACKAGE_NAME.md` بکەرەوە بۆ ڕێنمایی تەواو

---

## 📚 دۆکیومێنتەیشن

- **README.md** - زانیاری گشتی
- **INSTALLATION_GUIDE.md** - ڕێنمایی دامەزراندن
- **ERROR_FIX.md** - چارەسەری هەڵەکان
- **PACKAGE_NAME.md** - ڕێکخستنی package name
- **CHANGELOG_KU.md** - لیستی گۆڕانکارییەکان

---

## ✨ تایبەتمەندییەکان

✅ هەڵگرتن و گەڕاندنەوەی داتا  
✅ هەژمارکردنی نرخ (هەموو جۆرەکان)  
✅ هەژمارە تەکنیکییەکان  
✅ هەژمارکەری سۆلار  
✅ تەمی تاریک/ڕووناک  
✅ ٣ زمان (کوردی، ئینگلیزی، عەرەبی)  
✅ شەریککردنی ئەنجامەکان  
✅ Package Name: com.electricity.calculator

---

## 🚀 بیلدکردن بۆ Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (بۆ Play Store)
flutter build appbundle --release

# فایلەکە لێرە دەبێت:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

---

## 💡 تیپس

1. **پێش بیلدکردن** flutter clean بکە
2. **بۆ Play Store** appbundle بەکاربێنە
3. **Sign کردن** لە Android Studio
4. **Package Name** یەکجار بیگۆڕە پێش پڵاش

---

**وەشان:** 1.0.8  
**گەشەپێدەر:** AMANJ  
**Package:** com.electricity.calculator

چاکەت لێبێت! 🎉
