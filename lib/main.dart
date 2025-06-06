// lib/main.dart

// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/login_page.dart';
import 'screens/main_screen.dart';
import 'models/article.dart';
import 'providers/news_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/search_provider.dart'; // Import SearchProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());

  bool isLoggedIn = await _checkLoginStatus();
  print('App startup: Is user logged in? $isLoggedIn');

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
         ChangeNotifierProvider(create: (_) => NewsProvider()),
         ChangeNotifierProvider(create: (_) => BookmarkProvider()..initializeBox()),
         ChangeNotifierProvider(create: (_) => ThemeProvider()),
         ChangeNotifierProvider(create: (_) => SearchProvider()), // Provide SearchProvider
       ],
       child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
             return MaterialApp(
               title: 'News App',
               themeMode: themeProvider.themeMode,
               theme: ThemeData(
                 primarySwatch: Colors.blue,
                 visualDensity: VisualDensity.adaptivePlatformDensity,
                 brightness: Brightness.light,
                 appBarTheme: AppBarTheme(
                   backgroundColor: Colors.blue,
                   foregroundColor: Colors.white,
                 )
               ),
               darkTheme: ThemeData(
                 primarySwatch: Colors.blueGrey,
                 visualDensity: VisualDensity.adaptivePlatformDensity,
                 brightness: Brightness.dark,
                 scaffoldBackgroundColor: Colors.grey[900],
                 cardColor: Colors.grey[800],
                 textTheme: const TextTheme(
                   bodyMedium: TextStyle(color: Colors.white70),
                   titleMedium: TextStyle(color: Colors.white),
                   bodySmall: TextStyle(color: Colors.white60),
                 ),
                 appBarTheme: AppBarTheme(
                   backgroundColor: Colors.grey[850],
                   foregroundColor: Colors.white,
                 ),
                 bottomNavigationBarTheme: BottomNavigationBarThemeData(
                   backgroundColor: Colors.grey[850],
                   selectedItemColor: Colors.blueAccent,
                   unselectedItemColor: Colors.grey[600],
                 ),
               ),
               debugShowCheckedModeBanner: false,
               home: isLoggedIn ? const MainScreen() : const LoginPage(),
             );
          },
       ),
    );
  }
}
