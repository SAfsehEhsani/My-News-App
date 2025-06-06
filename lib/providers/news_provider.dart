// lib/providers/news_provider.dart

import 'package:flutter/material.dart';
import '../models/article.dart'; // Import Article model
import '../services/news_service.dart'; // Import News Service

class NewsProvider with ChangeNotifier {
  // State variables
  List<Article> _articles = []; // The list of news articles
  bool _isLoading = false; // To indicate if data is currently being fetched
  String? _errorMessage; // To store any error message

  // Getters to access the state from widgets
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Instance of the NewsService
  final NewsService _newsService = NewsService();

  // Constructor: Fetch news when the provider is created
  NewsProvider() {
    fetchNews(); // Automatically fetch news on startup
  }

  // Method to fetch news
  Future<void> fetchNews() async {
    _isLoading = true; // Set loading to true
    _errorMessage = null; // Clear any previous error
    notifyListeners(); // Notify widgets that state has changed (loading started)

    try {
      // Fetch news from the service
      final fetchedArticles = await _newsService.fetchTopHeadlines();
      _articles = fetchedArticles; // Update the articles list
      _errorMessage = null; // Ensure no error message remains
    } catch (e) {
      // Handle errors
      _errorMessage = 'Failed to load news: ${e.toString()}'; // Set error message
      _articles = []; // Clear articles on error
      print('Error fetching news: $e'); // Print error to console
    } finally {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify widgets that fetching is complete (either success or failure)
    }
  }

  // Method to refresh news (used for pull-to-refresh later)
  Future<void> refreshNews() async {
      // Only fetch if not already loading
      if (!_isLoading) {
          await fetchNews();
      }
  }

  // You might add a method to search news here later
  // Future<void> searchNews(String query) async { ... }
}