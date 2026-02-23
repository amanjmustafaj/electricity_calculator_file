# ڕێنمایی پڕۆژە / Project Guide

## ستراکچەری تەواوی پڕۆژە / Complete Project Structure

```
electricity_app/
│
├── lib/
│   ├── main.dart                           # نوقتەی دەستپێکردن
│   │
│   ├── models/                             # مۆدێلەکان
│   │   ├── saved_calculation.dart         # مۆدێلی حیسابە هەڵگیراوەکان
│   │   └── appliance_item.dart            # مۆدێلی ئامێرە کارەباییەکان
│   │
│   ├── utils/                              # تووڵزەکان
│   │   ├── translations.dart              # سیستەمی زمان (کوردی، ئینگلیزی، عەرەبی)
│   │   └── helpers.dart                   # فەنکشنە یارمەتیدەرەکان
│   │
│   ├── widgets/                            # ویجێتە دووبارە بەکارهێنراوەکان
│   │   └── shared/
│   │       ├── glass_card.dart            # کارتی شووشەیی
│   │       ├── glass_button.dart          # دوگمەی شووشەیی
│   │       ├── glass_text_field.dart      # خانەی نووسینی شووشەیی
│   │       └── result_card.dart           # کارتی ئەنجام
│   │
│   ├── screens/                            # پەڕەکانی ئەپڵیکەیشن
│   │   ├── main_navigation.dart           # ناڤیگەیشنی سەرەکی
│   │   ├── splash_screen.dart             # پەڕەی دەستپێکردن
│   │   ├── price_calc_page.dart           # پەڕەی هەژمارکردنی نرخ
│   │   ├── technical_calc_page.dart       # پەڕەی هەژمارە تەکنیکییەکان
│   │   ├── info_page.dart                 # پەڕەی زانیاری و ئامێرەکان
│   │   └── settings_page.dart             # پەڕەی ڕێکخستنەکان
│   │
│   └── constants/                          # داتای جێگیر
│       └── appliance_data.dart            # لیستی ئامێرە کارەباییەکان
│
├── pubspec.yaml                            # پێناسەی پاکێجەکان
├── README.md                               # ڕێنمایی گشتی
└── PROJECT_STRUCTURE.md                    # ئەم فایلە

```

## بەشەکانی سەرەکی / Main Components

### 1. Models (lib/models/)
مۆدێلەکان کە داتا پاشەکەوت دەکەن

- **saved_calculation.dart**: حیسابە هەڵگیراوەکان لەگەڵ ناو، جۆر، کیلۆوات و نرخ
- **appliance_item.dart**: زانیاری ئامێرە کارەباییەکان

### 2. Utils (lib/utils/)
فەنکشنە یارمەتیدەرەکان

- **translations.dart**: هەموو وشە و دەقەکان بە 3 زمان
- **helpers.dart**: فەنکشنەکانی فۆرماتکردنی ژمارە و هتد

### 3. Widgets (lib/widgets/)
کۆمپۆنێنتە دووبارە بەکارهێنراوەکان

- **glass_card.dart**: کارتی شووشەیی بە ئیفێکتی blur
- **glass_button.dart**: دوگمەی شووشەیی
- **glass_text_field.dart**: خانەی نووسینی شووشەیی
- **result_card.dart**: کارتی پیشاندانی ئەنجام

### 4. Screens (lib/screens/)
پەڕەکانی سەرەکی

- **main_navigation.dart**: سیستەمی ناڤیگەیشن بە 4 پەڕە
- **splash_screen.dart**: پەڕەی دەستپێکردن بە ئەنیمەیشن
- **price_calc_page.dart**: هەژمارکردنی نرخی کارەبا
- **technical_calc_page.dart**: حیسابە تەکنیکییەکان و سۆلار
- **info_page.dart**: زانیاری و حیسابگەری ئامێرەکان
- **settings_page.dart**: ڕێکخستنی ڕووکار و زمان

## چۆنیەتی دەستکاریکردن / How to Modify

### بۆ زیادکردنی زمانێکی نوێ:
1. بڕۆ بۆ `lib/utils/translations.dart`
2. زمانی نوێ زیاد بکە لە `AppLanguage enum`
3. وشەکان زیاد بکە لە `translations Map`

### بۆ زیادکردنی ئامێرێکی نوێ:
1. بڕۆ بۆ `lib/constants/appliance_data.dart`
2. ئامێرەکە زیاد بکە لە `applianceWattages`
3. وشەکەی زیاد بکە لە translations

### بۆ گۆڕینی ڕەنگەکان:
1. بڕۆ بۆ `lib/main.dart`
2. `colorSchemeSeed` بگۆڕە لە `ThemeData`

### بۆ زیادکردنی پەڕەیەکی نوێ:
1. فایلی نوێ دروست بکە لە `lib/screens/`
2. پەڕەکە import بکە لە `main_navigation.dart`
3. زیادی بکە لە `pages` list
4. NavigationDestination زیاد بکە

## سوودەکانی ئەم ستراکچەرە / Benefits

✅ کۆدی پاک و ڕێکخراو
✅ دەستکاریکردنی ئاسان
✅ دۆزینەوەی کێشەکان خێراترە
✅ دووبارە بەکارهێنانی کۆمپۆنێنتەکان
✅ هاوکاری گروپی ئاسانترە
✅ تێستکردنی ئاسانتر
✅ ماینتێنسی باشتر

