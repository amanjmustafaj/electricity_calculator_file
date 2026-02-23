import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import 'utils/translations.dart'; // دڵنیابە ناوی فۆڵدەرەکەت ڕاستە

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ElectricityApp());
}

// Number formatter helper - adds commas to numbers
String formatNumber(double number) {
  String numStr = number.round().toString();
  String result = '';
  int count = 0;
  
  for (int i = numStr.length - 1; i >= 0; i--) {
    if (count == 3) {
      result = ',$result';
      count = 0;
    }
    result = numStr[i] + result;
    count++;
  }
  
  return result;
}

// Saved Calculation Model
class SavedCalculation {
  final String name;
  final String category;
  final double kwh;
  final double? days;
  final double totalCost;
  final DateTime savedAt;

  SavedCalculation({
    required this.name,
    required this.category,
    required this.kwh,
    this.days,
    required this.totalCost,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'kwh': kwh,
    'days': days,
    'totalCost': totalCost,
    'savedAt': savedAt.toIso8601String(),
  };

  factory SavedCalculation.fromJson(Map<String, dynamic> json) => SavedCalculation(
    name: json['name'],
    category: json['category'],
    kwh: json['kwh'],
    days: json['days'],
    totalCost: json['totalCost'],
    savedAt: DateTime.parse(json['savedAt']),
  );
}


// SPLASH SCREEN WIDGET
class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Pulse animation for glow effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Navigate after 3 seconds with fade transition
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFFF8A5B),
              Color(0xFFFFA07A),
              Color(0xFFFFB088),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller, _pulseController]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated electric bulb with pulsing glow
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                size: 90,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // App name with shadow
                      const Text(
                        'سیستەمی کارەبا',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              offset: Offset(0, 6),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Subtitle with fade
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          'هەژمارکردنی کارەبا',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 70),
                      
                      // Enhanced loading indicator
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class ElectricityApp extends StatefulWidget {
  const ElectricityApp({super.key});

  @override
  State<ElectricityApp> createState() => _ElectricityAppState();
}

class _ElectricityAppState extends State<ElectricityApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppLanguage _language = AppLanguage.kurdish;
  bool _showSplash = true; // نیشانەیەک بۆ پیشاندانی splash screen
  bool _isLoading = true; // بۆ چاوەڕوانی load بوونی preferences

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // ئەگەر ئەپەکە پێشتر کراوەتەوە، splash screen پیشان مەدە
    final hasLaunchedBefore = prefs.getBool('has_launched_before') ?? false;
    
    setState(() {
      _showSplash = !hasLaunchedBefore; // تەنها لە یەکەم جار splash پیشان بدە
      
      final isDark = prefs.getBool('isDark');
      if (isDark != null) {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      }
      
      final langIndex = prefs.getInt('language');
      if (langIndex != null && langIndex < AppLanguage.values.length) {
        _language = AppLanguage.values[langIndex];
      }
      
      _isLoading = false;
    });
    
    // نیشانە بکە کە ئەپەکە کراوەتەوە
    if (!hasLaunchedBefore) {
      await prefs.setBool('has_launched_before', true);
    }
  }

  void _changeTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', mode == ThemeMode.dark);
  }

  void _changeLanguage(AppLanguage lang) async {
    setState(() {
      _language = lang;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', lang.index);
  }

  @override
  Widget build(BuildContext context) {
    // چاوەڕوانبە تا preferences load بن
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFFF8A5B),
                  Color(0xFFFFA07A),
                  Color(0xFFFFB088),
                ],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTranslations.get(_language, 'app_title'),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Rabar', 
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFFF8A5B),
        scaffoldBackgroundColor: const Color(0xFF000000),
        fontFamily: 'Rabar',
      ),
      themeMode: _themeMode,
      builder: (context, child) => Directionality(
        textDirection: _language == AppLanguage.english
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: child!,
      ),
      // ئەگەر _showSplash = true بوو، splash screen پیشان بدە، ئەگەر نا ڕاستەوخۆ بچۆ ناو ئەپەکە
      home: _showSplash
          ? SplashScreen(
              nextScreen: MainNavigation(
                onThemeChanged: _changeTheme,
                onLanguageChanged: _changeLanguage,
                currentMode: _themeMode,
                currentLanguage: _language,
              ),
            )
          : MainNavigation(
              onThemeChanged: _changeTheme,
              onLanguageChanged: _changeLanguage,
              currentMode: _themeMode,
              currentLanguage: _language,
            ),
    );
  }
}
class MainNavigation extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(AppLanguage) onLanguageChanged;
  final ThemeMode currentMode;
  final AppLanguage currentLanguage;

  const MainNavigation({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentMode,
    required this.currentLanguage,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = widget.currentLanguage;
    final List<Widget> pages = [
      PriceCalcPage(key: ValueKey('price_$lang'), language: lang),
      TechnicalCalcPage(key: ValueKey('tech_$lang'), language: lang),
      InfoPage(key: ValueKey('info_$lang'), language: lang),
      SettingsPage(
        key: ValueKey('settings_$lang'),
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
        currentMode: widget.currentMode,
        currentLanguage: widget.currentLanguage,
      ),
    ];

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: isDark
            ? const Color(0xFF000000)
            : const Color(0xFFF5F7FA),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                backgroundColor: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
                title: Text(
                  AppTranslations.get(lang, 'app_title'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ]
                          : [
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.3),
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF000000),
                        const Color(0xFF000000),
                        const Color(0xFF000000),
                      ]
                    : [
                        const Color(0xFFF5F7FA),
                        const Color(0xFFE8EAF6),
                        const Color(0xFFF5F7FA),
                      ],
              ),
            ),
            padding: const EdgeInsets.only(top: 10),
            child: pages[_currentIndex],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.orange.withOpacity(0.15)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                          ]
                        : [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: NavigationBar(
                  selectedIndex: _currentIndex,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  height: 65,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  indicatorColor: isDark
                      ? Colors.orange.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.2),
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.calculate_outlined,
                          color: _currentIndex == 0
                              ? Colors.orange
                              : (isDark ? Colors.white70 : Colors.black54)),
                      selectedIcon: const Icon(Icons.calculate_rounded,
                          color: Colors.orange),
                      label: AppTranslations.get(lang, 'price'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bolt_outlined,
                          color: _currentIndex == 1
                              ? Colors.orange
                              : (isDark ? Colors.white70 : Colors.black54)),
                      selectedIcon: const Icon(Icons.bolt_rounded,
                          color: Colors.orange),
                      label: AppTranslations.get(lang, 'technical'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.lightbulb_outline,
                          color: _currentIndex == 2
                              ? Colors.orange
                              : (isDark ? Colors.white70 : Colors.black54)),
                      selectedIcon: const Icon(Icons.lightbulb_rounded,
                          color: Colors.orange),
                      label: AppTranslations.get(lang, 'info'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined,
                          color: _currentIndex == 3
                              ? Colors.orange
                              : (isDark ? Colors.white70 : Colors.black54)),
                      selectedIcon: const Icon(Icons.settings_rounded,
                          color: Colors.orange),
                      label: AppTranslations.get(lang, 'settings'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PriceCalcPage extends StatefulWidget {
  final AppLanguage language;
  const PriceCalcPage({super.key, required this.language});

  @override
  State<PriceCalcPage> createState() => _PriceCalcPageState();
}

class _PriceCalcPageState extends State<PriceCalcPage> {
  String category = "residential_daily";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String resultText = "";
  List<Map<String, dynamic>> tierDetails = [];
  bool showTable = false;
  List<SavedCalculation> savedCalculations = [];
  double lastCalculatedTotal = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedCalculations();
  }

  Future<void> _loadSavedCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('saved_calculations');
    if (savedData != null) {
      final List<dynamic> decoded = json.decode(savedData);
      setState(() {
        savedCalculations = decoded.map((e) => SavedCalculation.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveCalculation() async {
    if (_controller.text.isEmpty || lastCalculatedTotal == 0) return;

    final nameController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppTranslations.get(widget.language, 'save_calculation')),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppTranslations.get(widget.language, 'calculation_name'),
            hintText: AppTranslations.get(widget.language, 'enter_name'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppTranslations.get(widget.language, 'cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppTranslations.get(widget.language, 'save')),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      final newCalc = SavedCalculation(
        name: nameController.text,
        category: category,
        kwh: double.parse(_controller.text),
        days: double.tryParse(_daysController.text),
        totalCost: lastCalculatedTotal,
        savedAt: DateTime.now(),
      );

      setState(() {
        savedCalculations.insert(0, newCalc);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_calculations', 
        json.encode(savedCalculations.map((e) => e.toJson()).toList()));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppTranslations.get(widget.language, 'data_saved')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }

      await _updateHomeWidget();
    }
  }

  Future<void> _updateHomeWidget() async {
    if (savedCalculations.isEmpty) return;
    
    try {
      final latest = savedCalculations.first;
      await HomeWidget.saveWidgetData<String>('calculation_name', latest.name);
      await HomeWidget.saveWidgetData<String>('calculation_cost', formatNumber(latest.totalCost));
      await HomeWidget.saveWidgetData<String>('calculation_kwh', latest.kwh.toStringAsFixed(0));
      await HomeWidget.updateWidget(
        androidName: 'ElectricityWidgetProvider',
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadCalculation(SavedCalculation calc) async {
    setState(() {
      category = calc.category;
      _controller.text = calc.kwh.toString();
      if (calc.days != null) {
        _daysController.text = calc.days.toString();
      }
    });
    
    FocusScope.of(context).unfocus();
    
    calculate();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTranslations.get(widget.language, 'data_loaded')),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _deleteCalculation(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppTranslations.get(widget.language, 'confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppTranslations.get(widget.language, 'no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppTranslations.get(widget.language, 'yes')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        savedCalculations.removeAt(index);
      });
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_calculations', 
        json.encode(savedCalculations.map((e) => e.toJson()).toList()));
    }
  }

  void _showSavedCalculations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppTranslations.get(widget.language, 'saved_calculations'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: savedCalculations.isEmpty
                    ? Center(
                        child: Text(
                          AppTranslations.get(widget.language, 'no_saved_data'),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: savedCalculations.length,
                        itemBuilder: (context, index) {
                          final calc = savedCalculations[index];
                          return _buildSavedCalculationCard(calc, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case "residential":
        return AppTranslations.get(widget.language, 'residential');
      case "residential_daily":
        return AppTranslations.get(widget.language, 'residential_daily');
      case "commercial":
        return AppTranslations.get(widget.language, 'commercial');
      case "industrial":
        return AppTranslations.get(widget.language, 'industrial');
      case "large_industrial":
        return AppTranslations.get(widget.language, 'large_industrial');
      case "government":
        return AppTranslations.get(widget.language, 'government');
      case "agriculture":
        return AppTranslations.get(widget.language, 'agriculture');
      default:
        return category;
    }
  }

  Widget _buildSavedCalculationCard(SavedCalculation calc, int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = widget.language;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _loadCalculation(calc);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bookmark_rounded, color: Colors.orange, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calc.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.25),
                            Colors.blue.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.category_rounded, color: Colors.blue.shade700, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _getCategoryName(calc.category),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppTranslations.get(lang, 'consumption_of')} ${calc.kwh.toStringAsFixed(0)} kWh ${AppTranslations.get(lang, 'costs')} ${formatNumber(calc.totalCost)} ${AppTranslations.get(lang, 'dinar')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppTranslations.get(lang, 'saved_on')}: ${calc.savedAt.day}/${calc.savedAt.month}/${calc.savedAt.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteCalculation(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _localizedCategory {
    return _getCategoryName(category);
  }

  void calculate() {
    double input = double.tryParse(_controller.text) ?? 0;
    if (input <= 0) return;

    double days = double.tryParse(_daysController.text) ?? 30;
    if (days <= 0) days = 30;

    double discountPercent = double.tryParse(_discountController.text) ?? 0;
    if (discountPercent < 0) discountPercent = 0;
    if (discountPercent > 100) discountPercent = 100;

    setState(() {
      tierDetails.clear();

      if (category == "residential" || category == "residential_daily") {
        showTable = true;
        double total = 0, temp = input;

        double limitTier = 400;

        if (category == "residential_daily") {
          limitTier = (400 / 30) * days;
        }

        List<Map<String, dynamic>> tiers = [
          {"n": "1", "l": limitTier, "p": 72},
          {"n": "2", "l": limitTier, "p": 108},
          {"n": "3", "l": limitTier, "p": 175},
          {"n": "4", "l": limitTier, "p": 265},
          {"n": "5", "l": 999999.0, "p": 350},
        ];

        for (var t in tiers) {
          if (temp <= 0) break;
          double tierLimit = t['l'].toDouble();
          double used = (temp > tierLimit) ? tierLimit : temp;
          double cost = used * t['p'];
          tierDetails.add({
            "p": "${AppTranslations.get(widget.language, 'tier')} ${t['n']}",
            "u": used.toStringAsFixed(2),
            "r": t['p'],
            "c": cost.toStringAsFixed(0)
          });
          total += cost;
          temp -= used;
        }
        
        double originalTotal = total;
        lastCalculatedTotal = total;
        
        if (discountPercent > 0) {
          double discountAmount = originalTotal * (discountPercent / 100);
          total = originalTotal - discountAmount;
          lastCalculatedTotal = total;
          
          resultText = "${AppTranslations.get(widget.language, 'before_discount')}: "
              "${formatNumber(originalTotal)} ${AppTranslations.get(widget.language, 'dinar')}\n\n"
              "━━━━━━━━━━━━━━━━━━━━━\n"
              "${AppTranslations.get(widget.language, 'discount')}: $discountPercent%\n"
              "${AppTranslations.get(widget.language, 'discount_amount')}: ${formatNumber(discountAmount)} ${AppTranslations.get(widget.language, 'dinar')}\n"
              "━━━━━━━━━━━━━━━━━━━━━\n\n"
              "${AppTranslations.get(widget.language, 'final_total')}: "
              "${formatNumber(total)} ${AppTranslations.get(widget.language, 'dinar')}";
        } else {
          resultText = "${AppTranslations.get(widget.language, 'grand_total')}: "
              "${formatNumber(total)} ${AppTranslations.get(widget.language, 'dinar')}";
        }
      } else {
        showTable = false;
        double rate = 0;
        switch (category) {
          case "commercial":
            rate = 185;
            break;
          case "industrial":
            rate = 160;
            break;
          case "large_industrial":
            rate = 125;
            break;
          case "government":
            rate = 160;
            break;
          case "agriculture":
            rate = 60;
            break;
        }
        
        double originalTotal = input * rate;
        double total = originalTotal;
        
        if (discountPercent > 0) {
          double discountAmount = originalTotal * (discountPercent / 100);
          total = originalTotal - discountAmount;
          lastCalculatedTotal = total;
          
          resultText = "${AppTranslations.get(widget.language, 'before_discount')}: "
              "${formatNumber(originalTotal)} ${AppTranslations.get(widget.language, 'dinar')}\n\n"
              "━━━━━━━━━━━━━━━━━━━━━\n"
              "${AppTranslations.get(widget.language, 'discount')}: $discountPercent%\n"
              "${AppTranslations.get(widget.language, 'discount_amount')}: ${formatNumber(discountAmount)} ${AppTranslations.get(widget.language, 'dinar')}\n"
              "━━━━━━━━━━━━━━━━━━━━━\n\n"
              "${AppTranslations.get(widget.language, 'final_total')}: "
              "${formatNumber(total)} ${AppTranslations.get(widget.language, 'dinar')}";
        } else {
          lastCalculatedTotal = total;
          resultText = "${AppTranslations.get(widget.language, 'cost')}: "
              "${formatNumber(lastCalculatedTotal)} ${AppTranslations.get(widget.language, 'dinar')}";
        }
      }
    });
  }

  Future<void> _shareResult() async {
    if (resultText.isEmpty) return;

    StringBuffer msg = StringBuffer();
    msg.writeln("🧾 *${AppTranslations.get(widget.language, 'app_title')}*");
    msg.writeln("----------------------------");
    msg.writeln("🏠 ${AppTranslations.get(widget.language, 'type')}: $_localizedCategory");
    msg.writeln("⚡ ${AppTranslations.get(widget.language, 'amount')}: ${_controller.text} kWh");
    msg.writeln("📅 ${AppTranslations.get(widget.language, 'number_of_days')}: ${_daysController.text.isNotEmpty ? _daysController.text : '30'}");

    if (_discountController.text.isNotEmpty) {
      double d = double.tryParse(_discountController.text) ?? 0;
      if (d > 0) msg.writeln("🎁 ${AppTranslations.get(widget.language, 'discount')}: $d%");
    }

    if ((category == "residential" || category == "residential_daily") && tierDetails.isNotEmpty) {
      msg.writeln("\n📊 *${AppTranslations.get(widget.language, 'tier_details')}:*");
      for (var item in tierDetails) {
        msg.writeln("🔸 ${item['p']}: ${item['u']} kw × ${item['r']} = ${formatNumber(double.parse(item['c']))}");
      }
    }

    msg.writeln("----------------------------");
    msg.writeln("💰 $resultText");

    try {
      await Share.share(
        msg.toString(),
        subject: AppTranslations.get(widget.language, 'app_title'),
      );
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = widget.language;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _buildGlassCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: category,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.primary),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: [
                  "residential_daily",
                  "commercial",
                  "industrial",
                  "large_industrial",
                  "government",
                  "agriculture"
                ]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(AppTranslations.get(lang, e))))
                    .toList(),
                onChanged: (v) => setState(() {
                  category = v!;
                  showTable = false;
                }),
              ),
            ),
          ),
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildGlassTextField(
          controller: _controller,
          label: AppTranslations.get(lang, 'enter_kwh'),
          icon: Icons.flash_on_rounded,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildGlassTextField(
          controller: _daysController,
          label: AppTranslations.get(lang, 'number_of_days'),
          hint: AppTranslations.get(lang, 'example'),
          icon: Icons.calendar_today_rounded,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildGlassTextField(
          controller: _discountController,
          label: AppTranslations.get(lang, 'discount_percent'),
          hint: '0-100',
          icon: Icons.percent_rounded,
          isDark: isDark,
        ),
        const SizedBox(height: 25),
        _buildGlassButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            calculate();
          },
          text: AppTranslations.get(lang, 'calculate'),
          icon: Icons.calculate_rounded,
          isDark: isDark,
        ),
        if (showTable) ...[
          const SizedBox(height: 30),
          Text(
            AppTranslations.get(lang, 'tier_details'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          _buildGlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable(
                columnSpacing: 15,
                headingRowHeight: 45,
                dataRowMinHeight: 50,
                dataRowMaxHeight: 50,
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                columns: [
                  DataColumn(label: Text(AppTranslations.get(lang, 'tier'))),
                  DataColumn(label: Text(AppTranslations.get(lang, 'amount'))),
                  DataColumn(label: Text(AppTranslations.get(lang, 'rate'))),
                  DataColumn(label: Text(AppTranslations.get(lang, 'total'))),
                ],
                rows: tierDetails
                    .map((i) => DataRow(cells: [
                          DataCell(Text(i['p'])),
                          DataCell(Text(i['u'])),
                          DataCell(Text(i['r'].toString())),
                          DataCell(Text(formatNumber(double.parse(i['c'])),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                        ]))
                    .toList(),
              ),
            ),
            isDark: isDark,
          ),
        ],
        const SizedBox(height: 25),
        if (resultText.isNotEmpty) ...[
          _buildResultCard(resultText, isDark),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildGlassButton(
                  onPressed: _saveCalculation,
                  text: AppTranslations.get(lang, 'save_calculation'),
                  icon: Icons.bookmark_add_rounded,
                  isDark: isDark,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGlassButton(
                  onPressed: _shareResult,
                  text: AppTranslations.get(lang, 'share_result'),
                  icon: Icons.share_rounded,
                  isDark: isDark,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
        if (savedCalculations.isNotEmpty) ...[
          _buildGlassButton(
            onPressed: _showSavedCalculations,
            text: AppTranslations.get(lang, 'saved_calculations'),
            icon: Icons.bookmark_rounded,
            isDark: isDark,
            color: Colors.blue,
          ),
          const SizedBox(height: 100),
        ],
      ]),
    );
  }
}

class TechnicalCalcPage extends StatefulWidget {
  final AppLanguage language;
  const TechnicalCalcPage({super.key, required this.language});

  @override
  State<TechnicalCalcPage> createState() => _TechnicalCalcPageState();
}

class _TechnicalCalcPageState extends State<TechnicalCalcPage> {
  String techMode = "watt_to_kwh";
  final TextEditingController _t1 = TextEditingController();
  final TextEditingController _tHours = TextEditingController();
  final TextEditingController _tDays = TextEditingController();
  String techResult = "";

  final TextEditingController _solarAmpsController = TextEditingController();
  String solarResult = "";

  Future<void> _shareTechResult() async {
    if (techResult.isEmpty) return;
    String msg = "⚙️ *${AppTranslations.get(widget.language, 'technical')}*\n"
        "----------------------------\n"
        "✅ $techResult\n"
        "----------------------------\n";
    try {
      await Share.share(
        msg,
        subject: AppTranslations.get(widget.language, 'technical'),
      );
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  Future<void> _shareSolarResult() async {
    if (solarResult.isEmpty) return;
    String msg = "☀️ *${AppTranslations.get(widget.language, 'solar_calculator')}*\n"
        "----------------------------\n"
        "$solarResult\n"
        "----------------------------\n";
    try {
      await Share.share(
        msg,
        subject: AppTranslations.get(widget.language, 'solar_calculator'),
      );
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  void _calculateSolar() {
    double amps = double.tryParse(_solarAmpsController.text) ?? 0;
    if (amps <= 0) return;
    setState(() {
      double totalWatts = amps * 220;
      int panels = (totalWatts / 450).ceil();
      double inverterKva = (totalWatts * 1.2) / 1000;
      String invSize = inverterKva < 1.5
          ? "1.5 kVA"
          : (inverterKva < 3.5 ? "3.5 kVA" : "5.5 kVA");
      int batteries = (amps <= 6) ? 2 : (amps <= 12 ? 4 : 8);

      solarResult = "💡 ${AppTranslations.get(widget.language, 'for_amount')} $amps ${AppTranslations.get(widget.language, 'total_amps')}:\n\n"
          "🔳 ${AppTranslations.get(widget.language, 'panels')}: $panels ${AppTranslations.get(widget.language, 'units')} (550W)\n"
          "🔌 ${AppTranslations.get(widget.language, 'inverter')}: $invSize\n"
          "🔋 ${AppTranslations.get(widget.language, 'batteries')}: $batteries ${AppTranslations.get(widget.language, 'units')} (200A)";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = widget.language;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _buildGlassCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: techMode,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).colorScheme.primary),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: ["watt_to_kwh", "watt_to_amp", "amp_to_kwh", "kwh_to_amp", "monthly"]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(AppTranslations.get(lang, e))))
                    .toList(),
                onChanged: (v) => setState(() {
                  techMode = v!;
                  _t1.clear();
                  _tHours.clear();
                  _tDays.clear();
                  techResult = "";
                }),
              ),
            ),
          ),
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        if (techMode == "monthly") ...[
          _buildGlassTextField(
            controller: _t1,
            label: AppTranslations.get(lang, 'enter_watt'),
            icon: Icons.power_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildGlassTextField(
            controller: _tHours,
            label: AppTranslations.get(lang, 'hours_per_day'),
            icon: Icons.access_time_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 15),
          _buildGlassTextField(
            controller: _tDays,
            label: AppTranslations.get(lang, 'days_per_month'),
            icon: Icons.event_note_rounded,
            isDark: isDark,
          ),
        ] else if (techMode == "kwh_to_amp")
          _buildGlassTextField(
            controller: _t1,
            label: AppTranslations.get(lang, 'enter_kwh_value'),
            icon: Icons.electric_bolt_rounded,
            isDark: isDark,
          )
        else
          _buildGlassTextField(
            controller: _t1,
            label: AppTranslations.get(lang, 'enter_value'),
            icon: Icons.input_rounded,
            isDark: isDark,
          ),
        const SizedBox(height: 25),
        _buildGlassButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            
            double v1 = double.tryParse(_t1.text) ?? 0;
            double hours = double.tryParse(_tHours.text) ?? 0;
            double days = double.tryParse(_tDays.text) ?? 0;
            setState(() {
              if (techMode == "watt_to_kwh") {
                techResult = "${(v1 / 1000).toStringAsFixed(2)} kWh";
              }
              if (techMode == "watt_to_amp") {
                techResult = "${(v1 / 220).toStringAsFixed(2)} A";
              }
              if (techMode == "amp_to_kwh") {
                techResult = "${(v1 * 220 / 1000).toStringAsFixed(2)} kWh";
              }
              if (techMode == "kwh_to_amp") {
                techResult = "${(v1 * 1000 / 220).toStringAsFixed(2)} A";
              }
              if (techMode == "monthly") {
                double monthlyKwh = (v1 * hours * days) / 1000;
                techResult = "${monthlyKwh.toStringAsFixed(2)} ${AppTranslations.get(lang, 'kwh_per_month')}";
              }
            });
          },
          text: AppTranslations.get(lang, 'calculate'),
          icon: Icons.calculate_rounded,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        if (techResult.isNotEmpty) ...[
          _buildResultCard(techResult, isDark),
          const SizedBox(height: 15),
          _buildGlassButton(
            onPressed: _shareTechResult,
            text: AppTranslations.get(lang, 'share_result'),
            icon: Icons.share_rounded,
            isDark: isDark,
            color: Colors.blue,
          ),
        ],
        const SizedBox(height: 40),
        _buildDivider(isDark),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 10),
            Text(
              AppTranslations.get(lang, 'solar_calculator'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildGlassTextField(
          controller: _solarAmpsController,
          label: AppTranslations.get(lang, 'how_many_amps'),
          icon: Icons.electric_bolt_rounded,
          isDark: isDark,
        ),
        const SizedBox(height: 25),
        _buildGlassButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            _calculateSolar();
          },
          text: AppTranslations.get(lang, 'show_requirements'),
          icon: Icons.wb_sunny_rounded,
          isDark: isDark,
          color: Colors.orange,
        ),
        const SizedBox(height: 20),
        if (solarResult.isNotEmpty) ...[
          _buildSolarResultCard(solarResult, isDark),
          const SizedBox(height: 15),
          _buildGlassButton(
            onPressed: _shareSolarResult,
            text: AppTranslations.get(lang, 'share_result'),
            icon: Icons.share_rounded,
            isDark: isDark,
            color: Colors.blue,
          ),
          const SizedBox(height: 100),
        ],
      ]),
    );
  }
}

// Appliance data model
class ApplianceItem {
  final String nameKey;
  final int defaultWatt;
  final double defaultHours;
  int watt;
  double hours;
  
  ApplianceItem({
    required this.nameKey,
    required this.defaultWatt,
    this.defaultHours = 4.0,
  }) : watt = defaultWatt,
       hours = defaultHours;
}

// INFO PAGE WITH APPLIANCE CALCULATOR
class InfoPage extends StatefulWidget {
  final AppLanguage language;
  const InfoPage({super.key, required this.language});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<ApplianceItem> selectedAppliances = [];
  final TextEditingController _daysController = TextEditingController();
  String applianceResult = "";

  final Map<String, int> applianceWattages = {
    'boiler': 2000,
    'split_1ton': 1200,
    'split_2ton': 2400,
    'fridge': 150,
    'freezer': 200,
    'washing_normal': 500,
    'washing_auto': 800,
    'iron': 1000,
    'microwave': 1200,
    'heater': 2000,
    'computer': 300,
    'laptop': 65,
    'tv': 100,
    'vacuum': 1400,
    'water_pump': 750,
    'oven': 2000,
    'bulb': 60,
    'fan': 75,
    'water_cooler': 500,
    'air_conditioner': 1500,
    'dishwasher': 1800,
    'electric_kettle': 1500,
    'rice_cooker': 700,
    'toaster': 800,
    'blender': 400,
    'hair_dryer': 1500,
  };

  // کاتژمێری پێشوەختە بۆ هەر ئامێرێک
  final Map<String, double> applianceDefaultHours = {
    'boiler': 4.0,
    'split_1ton': 2.0,
    'split_2ton': 2.0,
    'fridge': 24.0,
    'freezer': 24.0,
    'washing_normal': 1.0,
    'washing_auto': 1.5,
    'iron': 0.5,
    'microwave': 0.5,
    'heater': 5.0,
    'computer': 6.0,
    'laptop': 8.0,
    'tv': 5.0,
    'vacuum': 0.5,
    'water_pump': 2.0,
    'oven': 1.0,
    'bulb': 6.0,
    'fan': 8.0,
    'water_cooler': 10.0,
    'air_conditioner': 8.0,
    'dishwasher': 1.5,
    'electric_kettle': 0.3,
    'rice_cooker': 1.0,
    'toaster': 0.2,
    'blender': 0.2,
    'hair_dryer': 0.3,
  };

  void _addAppliance(String applianceKey) {
    setState(() {
      selectedAppliances.add(ApplianceItem(
        nameKey: applianceKey,
        defaultWatt: applianceWattages[applianceKey] ?? 100,
        defaultHours: applianceDefaultHours[applianceKey] ?? 4.0,
      ));
    });
  }

  void _removeAppliance(int index) {
    setState(() {
      selectedAppliances.removeAt(index);
    });
  }

  void _editWattage(int index) async {
    final wattController = TextEditingController(
      text: selectedAppliances[index].watt.toString(),
    );
    final hoursController = TextEditingController(
      text: selectedAppliances[index].hours.toString(),
    );
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppTranslations.get(widget.language, selectedAppliances[index].nameKey)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wattController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppTranslations.get(widget.language, 'power_consumption'),
                suffixText: 'W',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hoursController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppTranslations.get(widget.language, 'hours_per_day'),
                suffixText: AppTranslations.get(widget.language, 'hour'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTranslations.get(widget.language, 'cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, {
              'watt': wattController.text,
              'hours': hoursController.text,
            }),
            child: Text(AppTranslations.get(widget.language, 'save')),
          ),
        ],
      ),
    );

    if (result != null) {
      final newWatt = int.tryParse(result['watt'] ?? '');
      final newHours = double.tryParse(result['hours'] ?? '');
      if (newWatt != null && newWatt > 0 && newHours != null && newHours > 0) {
        setState(() {
          selectedAppliances[index].watt = newWatt;
          selectedAppliances[index].hours = newHours;
        });
      }
    }
  }

  void _calculateAppliances() {
    if (selectedAppliances.isEmpty) return;
    
    double days = double.tryParse(_daysController.text) ?? 0;
    
    if (days <= 0) return;

    // هەژماری هەر ئامێرێک بە کاتژمێری تایبەتی خۆی
    double totalKwhPerMonth = 0;
    int totalWatts = 0;
    String detailedBreakdown = "";

    for (var appliance in selectedAppliances) {
      double applianceKwh = (appliance.watt * appliance.hours * days) / 1000;
      totalKwhPerMonth += applianceKwh;
      totalWatts += appliance.watt;
      
      detailedBreakdown += "${AppTranslations.get(widget.language, appliance.nameKey)}: "
          "${appliance.watt}W × ${appliance.hours}${AppTranslations.get(widget.language, 'hour')} × "
          "${days.toStringAsFixed(0)}${AppTranslations.get(widget.language, 'day')} = "
          "${applianceKwh.toStringAsFixed(2)} kWh\n";
    }

    double totalAmps = totalWatts / 220;

    setState(() {
      applianceResult = "${AppTranslations.get(widget.language, 'detailed_calculation')}:\n\n"
          "$detailedBreakdown\n"
          "━━━━━━━━━━━━━━━━━━━━\n"
          "${AppTranslations.get(widget.language, 'total_watts')}: ${formatNumber(totalWatts.toDouble())} W\n"
          "${AppTranslations.get(widget.language, 'total_amps')}: ${totalAmps.toStringAsFixed(2)} A\n"
          "${AppTranslations.get(widget.language, 'kwh_per_month')}: ${totalKwhPerMonth.toStringAsFixed(2)} kWh";
    });
  }

  void _showAppliancesList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppTranslations.get(widget.language, 'common_appliances'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: applianceWattages.keys.map((key) {
                    bool isDark = Theme.of(context).brightness == Brightness.dark;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
                              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.power_rounded, color: Colors.orange, size: 24),
                        ),
                        title: Text(
                          AppTranslations.get(widget.language, key),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${applianceWattages[key]} W'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle_rounded, color: Colors.orange, size: 32),
                          onPressed: () {
                            Navigator.pop(context);
                            _addAppliance(key);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = widget.language;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.electrical_services_rounded, color: Colors.blue, size: 28),
              const SizedBox(width: 10),
              Text(
                AppTranslations.get(lang, 'appliance_info'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildGlassButton(
            onPressed: _showAppliancesList,
            text: AppTranslations.get(lang, 'common_appliances'),
            icon: Icons.add_circle_outline_rounded,
            isDark: isDark,
            color: Colors.blue,
          ),
          
          const SizedBox(height: 20),
          
          if (selectedAppliances.isNotEmpty) ...[
            Text(
              AppTranslations.get(lang, 'selected_appliances'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...selectedAppliances.asMap().entries.map((entry) {
              int index = entry.key;
              ApplianceItem item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
                        : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.power_rounded, color: Colors.blue, size: 20),
                  ),
                  title: Text(
                    AppTranslations.get(lang, item.nameKey),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${item.watt} W • ${item.hours} ${AppTranslations.get(lang, 'hour')}/${AppTranslations.get(lang, 'day')}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () => _editWattage(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeAppliance(index),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 20),
            
            _buildGlassTextField(
              controller: _daysController,
              label: AppTranslations.get(lang, 'days_per_month'),
              icon: Icons.event_note_rounded,
              isDark: isDark,
              hint: '30',
            ),
            
            const SizedBox(height: 20),
            
            _buildGlassButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _calculateAppliances();
              },
              text: AppTranslations.get(lang, 'calculate'),
              icon: Icons.calculate_rounded,
              isDark: isDark,
            ),
            
            const SizedBox(height: 20),
            
            if (applianceResult.isNotEmpty) ...[
              _buildResultCard(applianceResult, isDark),
              const SizedBox(height: 30),
            ],
          ],
          
          _buildDivider(isDark),
          const SizedBox(height: 30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 10),
              Text(
                AppTranslations.get(lang, 'category_prices'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          _buildCategorySection(
            isDark,
            lang,
            AppTranslations.get(lang, 'residential'),
            Icons.home_rounded,
            Colors.blue,
            [
              {'range': '0-400 kWh', 'price': '72'},
              {'range': '401-800 kWh', 'price': '108'},
              {'range': '801-1200 kWh', 'price': '175'},
              {'range': '1201-1600 kWh', 'price': '265'},
              {'range': '1600+ kWh', 'price': '350'},
            ],
          ),
          
          const SizedBox(height: 25),
          
          _buildSimpleCategoryCard(
            isDark,
            lang,
            AppTranslations.get(lang, 'commercial'),
            Icons.store_rounded,
            Colors.green,
            '185',
          ),
          
          const SizedBox(height: 15),
          
          _buildSimpleCategoryCard(
            isDark,
            lang,
            AppTranslations.get(lang, 'industrial'),
            Icons.factory_rounded,
            Colors.orange,
            '160',
          ),
          
          const SizedBox(height: 15),
          
          _buildSimpleCategoryCard(
            isDark,
            lang,
            AppTranslations.get(lang, 'large_industrial'),
            Icons.precision_manufacturing_rounded,
            Colors.deepOrange,
            '125',
          ),
          
          const SizedBox(height: 15),
          
          _buildSimpleCategoryCard(
            isDark,
            lang,
            AppTranslations.get(lang, 'government'),
            Icons.account_balance_rounded,
            Colors.purple,
            '160',
          ),
          
          const SizedBox(height: 15),
          
          _buildSimpleCategoryCard(
            isDark,
            lang,
            AppTranslations.get(lang, 'agriculture'),
            Icons.agriculture_rounded,
            Colors.lightGreen,
            '60',
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    bool isDark,
    AppLanguage lang,
    String title,
    IconData icon,
    Color color,
    List<Map<String, String>> tiers,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: tiers.map((tier) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tier['range']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tier['price']} ${AppTranslations.get(lang, 'dinar')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCategoryCard(
    bool isDark,
    AppLanguage lang,
    String title,
    IconData icon,
    Color color,
    String price,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
              : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  AppTranslations.get(lang, 'per_kwh'),
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(AppLanguage) onLanguageChanged;
  final ThemeMode currentMode;
  final AppLanguage currentLanguage;

  const SettingsPage({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentMode,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = currentLanguage;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.get(lang, 'theme_settings'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Updated Custom Animated Toggle
          GestureDetector(
            onTap: () {
               onThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)]
                      : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isDark ? AppTranslations.get(lang, 'dark') : AppTranslations.get(lang, 'light'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // The Animated Switch (Dugma Prtaqallyaka)
                  Container(
                    width: 60,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.orange.shade800 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                           color: Colors.black.withOpacity(0.1),
                           blurRadius: 4,
                           offset: const Offset(0, 2),
                        )
                      ]
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutBack,
                          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                              size: 18,
                              color: isDark ? Colors.orange.shade800 : Colors.orange.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          Text(
            AppTranslations.get(lang, 'language'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildGlassCard(
            child: Column(children: [
              _languageOption(
                  AppTranslations.get(lang, 'kurdish'),
                  AppLanguage.kurdish,
                  Icons.language_rounded,
                  isDark),
              Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              _languageOption(
                  AppTranslations.get(lang, 'english'),
                  AppLanguage.english,
                  Icons.language_rounded,
                  isDark),
              Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              _languageOption(AppTranslations.get(lang, 'arabic'),
                  AppLanguage.arabic, Icons.language_rounded, isDark),
            ]),
            isDark: isDark,
          ),

          const SizedBox(height: 40),

          Text(
            AppTranslations.get(lang, 'about'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ]
                      : [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.6),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: Colors.orange,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppTranslations.get(lang, 'app_name'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppTranslations.get(lang, 'version'),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppTranslations.get(lang, 'developer'),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppTranslations.get(lang, 'description'),
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _languageOption(
      String title, AppLanguage lang, IconData icon, bool isDark) {
    final bool isSelected = currentLanguage == lang;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.orange
              : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Radio<AppLanguage>(
        value: lang,
        groupValue: currentLanguage,
        activeColor: Colors.orange,
        onChanged: (v) => onLanguageChanged(v!),
      ),
      onTap: () => onLanguageChanged(lang),
    );
  }
}

// Helper Widgets
Widget _buildGlassCard({required Widget child, required bool isDark}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ]
            : [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.6),
              ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.5),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: child,
      ),
    ),
  );
}

Widget _buildGlassTextField({
  required TextEditingController controller,
  required String label,
  String? hint,
  required IconData icon,
  required bool isDark,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ]
            : [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.6),
              ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.5),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.2)
              : Colors.black.withOpacity(0.04),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, size: 22),
            filled: false,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ),
    ),
  );
}

Widget _buildGlassButton({
  required VoidCallback onPressed,
  required String text,
  required IconData icon,
  required bool isDark,
  Color? color,
}) {
  final buttonColor = color ?? Colors.orange;

  return Container(
    height: 60,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          buttonColor.withOpacity(0.8),
          buttonColor.withOpacity(0.6),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: buttonColor.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildResultCard(String text, bool isDark) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Colors.green.withOpacity(0.25),
                Colors.teal.withOpacity(0.15),
              ]
            : [
                Colors.green.withOpacity(0.15),
                Colors.teal.withOpacity(0.08),
              ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark
            ? Colors.green.withOpacity(0.3)
            : Colors.green.withOpacity(0.2),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.green.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.green.shade300 : Colors.green.shade800,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildSolarResultCard(String text, bool isDark) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Colors.orange.withOpacity(0.25),
                Colors.amber.withOpacity(0.15),
              ]
            : [
                Colors.orange.withOpacity(0.15),
                Colors.amber.withOpacity(0.08),
              ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.orange.withOpacity(0.4),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          height: 1.6,
          color: isDark ? Colors.orange.shade200 : Colors.orange.shade900,
        ),
      )
    ),
  );
}

Widget _buildDivider(bool isDark) {
  return Container(
    height: 1.5,
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          isDark
              ? Colors.white.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
          Colors.transparent,
        ],
      ),
    ),
  );
}