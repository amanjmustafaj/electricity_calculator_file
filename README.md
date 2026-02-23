# سیستەمی کارەبا (Electricity System)
### هەژمارکردنی کارەبا / Electricity Calculator

## ڕێکخستنی پرۆژەکە / Project Structure

```
electricity_app/
│
├── lib/
│   ├── main.dart                          # ناوەندی سەرەکی پرۆگرامەکە
│   │
│   ├── models/                            # مۆدێلە داتاکان
│   │   ├── saved_calculation.dart         # مۆدێلی زانیاری هەڵگیراو
│   │   └── appliance_item.dart            # مۆدێلی ئامێرە کارەباییەکان
│   │
│   ├── utils/                             # فانکشنە یارمەتیدەرەکان
│   │   ├── translations.dart              # وەرگێڕان بە 3 زمان (کوردی، ئینگلیزی، عەرەبی)
│   │   └── helpers.dart                   # فانکشنە فۆرماتکردنی ژمارەکان
│   │
│   ├── constants/                         # داتای جێگیر
│   │   └── appliance_data.dart            # لیستی ئامێرە کارەباییەکان و واتەکانیان
│   │
│   ├── widgets/                           # ویجێتە دووبارەبووەکان
│   │   └── shared/
│   │       ├── glass_card.dart            # کارتی گلاسی شێوە
│   │       ├── glass_text_field.dart      # خانەی نووسین گلاسی شێوە
│   │       ├── glass_button.dart          # دوگمەی گلاسی شێوە
│   │       └── result_card.dart           # کارتەکانی ئەنجام و هێڵی جیاکەر
│   │
│   └── screens/                           # پەڕە سەرەکیەکان
│       ├── splash_screen.dart             # پەڕەی سەرەتا
│       ├── main_navigation.dart           # ناڤیگەیشنی سەرەکی بە BottomNav
│       ├── price_calc_page.dart           # پەڕەی حیسابکردنی نرخ
│       ├── technical_calc_page.dart       # پەڕەی حیسابە تەکنیکیەکان
│       ├── info_page.dart                 # پەڕەی زانیاری و نرخەکان
│       └── settings_page.dart             # پەڕەی ڕێکخستن
│
├── pubspec.yaml                           # فایلی dependencies
└── README.md                              # ئەم فایلە

```

## تایبەتمەندییەکان / Features

### 1. حیسابکردنی نرخی کارەبا (Price Calculator)
- **7 جۆری بەکارهێنەر:** ماڵان، بازرگانی، پیشەسازی، گەورە، میری، کشتوکاڵ، ماڵان ڕۆژانە
- **سیستەمی پلەکان:** بۆ جۆری ماڵان بە 5 پلە جیاواز
- **داشکاندن:** ڕێژەی داشکاندن بۆ هەموو جۆرەکان
- **هەڵگرتن:** توانای هەڵگرتنی حیساباتەکان
- **هاوبەشکردن:** ناردنی ئەنجامەکان بە شێوەی تێکست

### 2. حیسابە تەکنیکیەکان (Technical Calculator)
- **گۆڕانکاری:** وات ↔ کیلۆوات ↔ ئەمپێر
- **مانگانە:** حیسابکردنی بەکارهێنانی مانگانە
- **حیسابکردنی سۆلار:** پێداویستی پانێڵ، ئینڤێرتەر، پاتری

### 3. زانیاری و نرخەکان (Info & Prices)
- **حیسابکردنی ئامێرەکان:** 27 ئامێری جیاواز
- **دەستکاری وات:** توانای گۆڕینی بڕی واتی ئامێرەکان
- **خشتەی نرخەکان:** نرخی هەموو جۆرەکانی بەکارهێنان

### 4. ڕێکخستنەکان (Settings)
- **Theme:** ڕووناک، تاریک، سیستەم
- **زمان:** کوردی، ئینگلیزی، عەرەبی
- **دەربارە:** زانیاری ئەپ و گەشەپێدەر

## چۆنیەتی کارکردن / How to Work

### گۆڕانکاری لە UI

**نموونە: بۆ گۆڕینی ڕەنگی سەرەکی:**

```dart
// لە main.dart
colorSchemeSeed: const Color(0xFFFF6B35),  // ڕەنگی ئۆرەنج
```

**نموونە: بۆ زیادکردنی ئامێرێکی نوێ:**

```dart
// لە constants/appliance_data.dart
const Map<String, int> applianceWattages = {
  ...
  'new_appliance': 1500,  // ئامێری نوێ بە 1500 وات
};

// پاشان لە utils/translations.dart
'new_appliance': 'ناوی ئامێرە نوێیەکە',  // بۆ کوردی
'new_appliance': 'New Appliance Name',    // بۆ ئینگلیزی
```

### زیادکردنی فیچەری نوێ

**نموونە: زیادکردنی پەڕەیەکی نوێ:**

1. فایلێکی نوێ دروست بکە لە `lib/screens/new_page.dart`
2. لە `main_navigation.dart` زیادی بکە:

```dart
final List<Widget> pages = [
  PriceCalcPage(language: lang),
  TechnicalCalcPage(language: lang),
  InfoPage(language: lang),
  NewPage(language: lang),  // پەڕەی نوێ
  SettingsPage(...),
];
```

### گۆڕینی وەرگێڕان

**لە `utils/translations.dart`:**

```dart
AppLanguage.kurdish: {
  'key_name': 'وشەکە بە کوردی',
  ...
},
AppLanguage.english: {
  'key_name': 'Word in English',
  ...
},
```

## سوودەکانی ئەم ڕێکخستنە / Benefits

✅ **کۆد پاکتر:** هەر فایلێک کارێکی تایبەتی هەیە
✅ **ئاسانتر بۆ چاککردن:** بە ئاسانی دەتوانیت فایلی پێویست بدۆزیتەوە
✅ **دووبارە بەکارهێنانەوە:** ویجێتە هاوبەشەکان لە هەموو شوێنێک بەکاردێن
✅ **ڕێکخراوتر:** بە هەموو ڕێکخستنەکانی Standard Flutter
✅ **ئاسانتر بۆ یارمەتیدانی تیم:** هەر کەسێک بەشێکی دیاریکراو لێبکات

## چۆنیەتی ڕانکردن / How to Run

```bash
# دابەزاندنی packages
flutter pub get

# ڕانکردنی ئەپ
flutter run

# Build کردن بۆ Android
flutter build apk --release

# Build کردن بۆ iOS
flutter build ios --release
```

## تێبینیە گرنگەکان / Important Notes

⚠️ **فایلە هاوبەشەکان:** تکایە گۆڕانکاری لە فایلەکانی `widgets/shared/` مەکە، چونکە کاریگەریان لەسەر هەموو ئەپەکە هەیە

⚠️ **وەرگێڕانەکان:** هەمیشە هەر key-یەک لە هەر 3 زمانەکەدا زیاد بکە

⚠️ **مۆدێلەکان:** ئەگەر گۆڕانکاری لە ستراکچەری SavedCalculation بکەیت، پێویستە logic-ی save/load بەرەوپێشی بەربدەیت

## گەشەپێدەر / Developer

**AMANJ**
- Version: 1.0.9
- بەرواری دروستکردن: 2024

---

## پرسیار و وەڵام / FAQ

**پ: چۆن ڕەنگی theme بگۆڕم?**
و: لە `main.dart` → `colorSchemeSeed`

**پ: چۆن ئامێرێکی نوێ زیاد بکەم?**
و: لە `constants/appliance_data.dart` و `utils/translations.dart`

**پ: چۆن پەڕەیەکی نوێ زیاد بکەم?**
و: فایلێکی نوێ لە `screens/` دروست بکە و لە `main_navigation.dart` register بکە

---

بەختەوەر بە! 🎉
