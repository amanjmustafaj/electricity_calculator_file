# ناوی پاکێج | Package Name Configuration

## ناوی پاکێجی ئەپەکە | App Package Name

```
com.electricity.calculator
```

---

## فایلەکانی گۆڕدراو | Modified Files

### ✅ AndroidManifest.xml
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.electricity.calculator">
```

### ✅ build.gradle (app)
```gradle
android {
    namespace "com.electricity.calculator"
    
    defaultConfig {
        applicationId "com.electricity.calculator"
        minSdk 21
        targetSdk 34
    }
}
```

### ✅ MainActivity.kt
```kotlin
package com.electricity.calculator

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

### ✅ ElectricityWidgetProvider.kt
```kotlin
package com.electricity.calculator

// Widget Provider
```

---

## ستراکچەری فۆڵدەر | Folder Structure

```
android/app/src/main/kotlin/com/electricity/calculator/
├── MainActivity.kt
└── ElectricityWidgetProvider.kt
```

---

## چۆنیەتی گۆڕین | How to Change

ئەگەر دەتەوێت ناوی پاکێجەکە بگۆڕیت:

### هەنگاو ١: ناوی نوێ دیاری بکە

نموونە:
- `com.yourcompany.appname`
- `com.amanj.electricity`
- `io.github.yourusername.app`

### هەنگاو ٢: فایلەکان بگۆڕە

**AndroidManifest.xml:**
```xml
package="com.yourcompany.appname"
```

**build.gradle:**
```gradle
namespace "com.yourcompany.appname"
applicationId "com.yourcompany.appname"
```

**MainActivity.kt:**
```kotlin
package com.yourcompany.appname
```

**ElectricityWidgetProvider.kt:**
```kotlin
package com.yourcompany.appname
```

### هەنگاو ٣: فۆڵدەرەکە گۆڕبکە

```bash
# پێش
android/app/src/main/kotlin/com/electricity/calculator/

# دوای
android/app/src/main/kotlin/com/yourcompany/appname/
```

### هەنگاو ٤: پاککردنەوە و بیلدکردن

```bash
flutter clean
flutter pub get
flutter build apk
```

---

## تێبینییە گرنگەکان | Important Notes

### 🔴 یاساکان | Rules

1. **تەنیا پیتی بچووک** (lowercase)
   - ✅ `com.electricity.calculator`
   - ❌ `com.Electricity.Calculator`

2. **هیچ کاراکتەرێکی تایبەت نا**
   - ✅ `com.electricity.calculator`
   - ❌ `com.electricity-calculator`
   - ❌ `com.electricity_calculator`

3. **بە نۆقتە دابەش بکرێت**
   - ✅ `com.company.app`
   - ❌ `comcompanyapp`

4. **بە ژمارە دەست پێ نەکات**
   - ✅ `com.app2024.electricity`
   - ❌ `com.2024app.electricity`

### 🟢 پێشنیارەکان | Recommendations

- بەکاربێنە: `com.companyname.appname`
- دۆمەینی وەرگێڕاو: `com.example.com` → `com.example.appname`
- کورت و ڕوون بێت
- دووبارە نەبێتەوە لە Play Store

---

## نموونە | Example

ئەگەر کۆمپانیاکەت **AMANJ** ـە و ئەپەکە **ElectricityCalc** ـە:

```
Package Name: com.amanj.electricitycalc
```

**Folder:**
```
android/app/src/main/kotlin/com/amanj/electricitycalc/
```

**Files:**
```kotlin
package com.amanj.electricitycalc

class MainActivity: FlutterActivity() {
}
```

---

## چاککردنی کێشەکان | Troubleshooting

### کێشە: "Package name already exists"

**چارەسەر:**
```
ناوێکی جیاواز هەڵبژێرە
```

### کێشە: "Invalid package name"

**چارەسەر:**
```
یاساکان بپشکنە:
- تەنیا پیتی بچووک
- هیچ کاراکتەرێکی تایبەت
- بە نۆقتە دابەش بکرێت
```

### کێشە: "Build failed after changing"

**چارەسەر:**
```bash
flutter clean
rm -rf android/build
flutter pub get
flutter build apk
```

---

## ناوی ئێستای پاکێج | Current Package

```
✅ com.electricity.calculator
```

**وەشان:** 1.0.8  
**مۆدێل:** `com.company.appname`

---

چاکەت لێبێت! 🎉
