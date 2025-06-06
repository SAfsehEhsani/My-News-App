

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'news_feed_page.dart';
import 'bookmarks_page.dart';
import '../providers/theme_provider.dart';
import 'search_page.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    NewsFeedPage(),
    BookmarksPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        centerTitle: true,
        actions: <Widget>[
          // --- Search Icon Button ---
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Web',
            onPressed: () {
              // Navigate to the SearchPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          // --- Theme Toggle Button ---
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final icon = themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode;
              final tooltip = themeProvider.themeMode == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode';
               final targetThemeMode = themeProvider.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;

              return IconButton(
                icon: Icon(icon),
                tooltip: tooltip,
                onPressed: () {
                  themeProvider.setThemeMode(targetThemeMode);
                },
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
