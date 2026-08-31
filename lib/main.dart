import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database_helper.dart';
import 'main_screen.dart';

/// ============================================================
/// نقطة دخول التطبيق
/// ============================================================
Future<void> main() async {
  // ضروري عند استدعاء أي كود أصلي (مثل فتح قاعدة بيانات) قبل runApp
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات مسبقاً عند إقلاع التطبيق
  // (أول استدعاء لـ `database` يقوم بإنشاء الملف والجداول تلقائياً
  // إن لم تكن موجودة، لذا هذا يضمن جاهزيتها قبل عرض أي شاشة)
  await DatabaseHelper().database;

  runApp(const PosApp());
}

/// ============================================================
/// التطبيق الرئيسي (PosApp)
/// ============================================================
class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام نقاط البيع',
      debugShowCheckedModeBanner: false,

      // ------------------------------------------------------
      // إعداد اللغة العربية واتجاه الكتابة من اليمين لليسار (RTL)
      // ------------------------------------------------------
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // العربية
        Locale('en'), // إنجليزية احتياطية
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ------------------------------------------------------
      // إعداد الثيم العام للتطبيق
      // ------------------------------------------------------
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),

      home: const MainScreen(),
    );
  }
}

