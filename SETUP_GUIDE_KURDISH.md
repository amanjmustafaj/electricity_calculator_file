# ڕێنمایی دامەزراندن و بەکارهێنان

## پێش دەستپێکردن

### پێویستییەکان
1. Flutter SDK (version 3.0 یان نوێتر)
2. Android Studio یان VS Code
3. Emulator یان مۆبایلی ڕاستەقینە

## هەنگاوەکانی دامەزراندن

### 1. داگرتنی پڕۆژە
```bash
# پڕۆژەکە extract بکە
unzip electricity_app.zip
cd electricity_app
```

### 2. دامەزراندنی پاکێجەکان
```bash
flutter pub get
```

### 3. چەککردنی دامەزراندن
```bash
flutter doctor
```

### 4. ڕانکردنی پڕۆژە
```bash
# بۆ Android
flutter run

# بۆ iOS
flutter run -d ios

# بۆ دیاریکردنی دیڤایسێکی دیاریکراو
flutter devices  # لیستی دیڤایسەکان
flutter run -d DEVICE_ID
```

## ستراکچەری فایلەکان

### 📁 lib/models/
**کار**: پاشەکەوتکردنی داتا

**saved_calculation.dart**
```dart
// بۆ هەڵگرتنی حیسابەکان
SavedCalculation(
  name: "حیسابی ماڵەوە",
  category: "residential",
  kwh: 500,
  totalCost: 45000
)
```

**appliance_item.dart**
```dart
// بۆ ئامێرە کارەباییەکان
ApplianceItem(
  nameKey: "fridge",
  defaultWatt: 150
)
```

### 📁 lib/utils/
**کار**: فەنکشنە یارمەتیدەرەکان

**translations.dart**
- سیستەمی زمان (کوردی، ئینگلیزی، عەرەبی)
- هەموو وشەکانی UI

**helpers.dart**
- فۆرماتکردنی ژمارەکان
- فەنکشنەکانی گشتی

### 📁 lib/widgets/shared/
**کار**: کۆمپۆنێنتە دووبارە بەکارهێنراوەکان

- `glass_card.dart`: کارتی شووشەیی
- `glass_button.dart`: دوگمە
- `glass_text_field.dart`: خانەی نووسین
- `result_card.dart`: پیشاندانی ئەنجام

### 📁 lib/screens/
**کار**: پەڕەکانی سەرەکی

- `main_navigation.dart`: ناڤیگەیشن
- `splash_screen.dart`: پەڕەی دەستپێک
- `price_calc_page.dart`: هەژمارکردنی نرخ
- `technical_calc_page.dart`: هەژمارە تەکنیکییەکان
- `info_page.dart`: زانیاری
- `settings_page.dart`: ڕێکخستنەکان

## چۆنیەتی دەستکاریکردن

### زیادکردنی زمانێکی نوێ

1. بڕۆ بۆ `lib/utils/translations.dart`
2. زمانەکە زیاد بکە:
```dart
enum AppLanguage { kurdish, english, arabic, turkish } // turkish زیادکرا
```

3. وشەکان زیاد بکە:
```dart
AppLanguage.turkish: {
  'app_title': 'Elektrik Hesaplayıcı',
  'price': 'Fiyat',
  // ...
}
```

### زیادکردنی ئامێرێکی نوێ

1. بڕۆ بۆ `lib/constants/appliance_data.dart`
2. زیادی بکە:
```dart
final Map<String, int> applianceWattages = {
  'fridge': 150,
  'tv': 100,
  'playstation': 150,  // نوێ
};
```

3. وشەکە زیاد بکە لە translations:
```dart
'playstation': 'پلەی ستەیشن',
```

### گۆڕینی ڕەنگەکان

بڕۆ بۆ `lib/main.dart`:
```dart
ThemeData(
  colorSchemeSeed: const Color(0xFF4CAF50), // سەوز
  // یان
  colorSchemeSeed: const Color(0xFF2196F3), // شین
)
```

### زیادکردنی پەڕەیەکی نوێ

1. فایلی نوێ دروست بکە لە `lib/screens/`:
```dart
// lib/screens/my_new_page.dart
class MyNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('پەڕەی نوێ')),
    );
  }
}
```

2. import بکە لە `main_navigation.dart`:
```dart
import 'my_new_page.dart';
```

3. زیادی بکە لە pages:
```dart
final List<Widget> pages = [
  PriceCalcPage(language: lang),
  TechnicalCalcPage(language: lang),
  InfoPage(language: lang),
  MyNewPage(),  // نوێ
  SettingsPage(...),
];
```

4. NavigationDestination زیاد بکە:
```dart
destinations: [
  // ...
  NavigationDestination(
    icon: Icon(Icons.star),
    label: 'نوێ',
  ),
]
```

## کێشە باوەکان و چارەسەرەکانیان

### 1. پاکێجەکان دانەمەزران
```bash
flutter clean
flutter pub get
```

### 2. هەڵەی Build
```bash
# بۆ Android
cd android
./gradlew clean
cd ..
flutter build apk

# بۆ iOS
cd ios
pod install
cd ..
flutter build ios
```

### 3. Hot Reload کار ناکات
- Restart بکە: `r` لە terminal
- Hot Restart: `R` لە terminal
- Stop بکە و دووبارە run بکە

## تیپەکانی گرنگ

### بۆ Performance باشتر
```dart
// بەکارهێنانی const بۆ ویجێتەکانی جێگیر
const Text('سڵاو')  // باشترە لە
Text('سڵاو')
```

### بۆ کۆدی پاکتر
```dart
// فەنکشنە بچووکەکان دروست بکە
Widget _buildMyWidget() {
  return Container(...);
}
```

### بۆ دووبارە بەکارهێنان
```dart
// ویجێتەکانی shared بەکاربهێنە
import '../widgets/shared/glass_button.dart';

buildGlassButton(
  text: 'دوگمە',
  onPressed: () {},
)
```

## بیلدکردنی APK/IPA

### Android (APK)
```bash
flutter build apk --release
# فایلەکە لە: build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle)
```bash
flutter build appbundle --release
# فایلەکە لە: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# ئینجا لە Xcode open بکە و archive بکە
```

## یارمەتی و پشتگیری

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

**نووسەر**: AMANJ
**وەشان**: 1.0.9

**تێبینی**: ئەم پڕۆژەیە بە شێوەیەکی ڕێکخراو و مۆدیولار دروستکراوە بۆ ئەوەی دەستکاریکردن و گەشەپێدانی ئاسانتر بێت.
