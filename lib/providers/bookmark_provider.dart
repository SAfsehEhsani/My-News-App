// lib/providers/bookmark_provider.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter
import '../models/article.dart'; // Import Article model

// Define the name of the Hive box
const String bookmarksBoxName = 'bookmarks';

class BookmarkProvider with ChangeNotifier {
  // State variable
  List<Article> _bookmarkedArticles = []; // List of bookmarked articles

  // Getter to access the state
  List<Article> get bookmarkedArticles => _bookmarkedArticles;

  // Hive Box instance (will be opened in main)
  Box<Article>? _bookmarksBox;

  // Constructor: Load bookmarks when the provider is created
  BookmarkProvider() {
    // We'll load bookmarks after the box is opened in main
    // loadBookmarks(); // Call this after box is initialized
  }

  // Method to initialize the Hive box (called from main after Hive.initFlutter())
  Future<void> initializeBox() async {
     // Check if the box is already open
     if (!Hive.isBoxOpen(bookmarksBoxName)) {
       _bookmarksBox = await Hive.openBox<Article>(bookmarksBoxName);
     } else {
       _bookmarksBox = Hive.box<Article>(bookmarksBoxName);
     }
     // Load bookmarks after the box is open
     loadBookmarks();
  }

  // Method to load bookmarks from Hive
  void loadBookmarks() {
    if (_bookmarksBox != null) {
       // Get all values from the box and convert to a List
       _bookmarkedArticles = _bookmarksBox!.values.toList();
       notifyListeners(); // Notify widgets that state has changed
       print('Loaded ${_bookmarkedArticles.length} bookmarks.'); // Debug print
    }
  }

  // Method to add an article to bookmarks
  Future<void> addBookmark(Article article) async {
    if (_bookmarksBox != null && !_bookmarkedArticles.contains(article)) {
      // Add the article to the Hive box. Hive will use the URL (due to == implementation) as the key by default if no key is specified.
      await _bookmarksBox!.put(article.url, article); // Using URL as key
      _bookmarkedArticles.add(article); // Add to the in-memory list
      notifyListeners(); // Notify widgets
      print('Added bookmark: ${article.title}'); // Debug print
    }
  }

  // Method to remove an article from bookmarks
  Future<void> removeBookmark(Article article) async {
    if (_bookmarksBox != null && _bookmarkedArticles.contains(article)) {
       // Remove the article from the Hive box using its key (the URL)
       await _bookmarksBox!.delete(article.url); // Using URL as key
       _bookmarkedArticles.removeWhere((item) => item.url == article.url); // Remove from the in-memory list
       notifyListeners(); // Notify widgets
       print('Removed bookmark: ${article.title}'); // Debug print
    }
  }

  // Method to check if an article is bookmarked
  bool isBookmarked(Article article) {
    // Check if the article exists in the in-memory list
    return _bookmarkedArticles.contains(article);
    // Or directly check Hive: return _bookmarksBox?.containsKey(article.url) ?? false;
  }
}