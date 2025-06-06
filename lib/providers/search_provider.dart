// lib/providers/search_provider.dart

import 'package:flutter/material.dart';
import '../models/search_result.dart'; // Import SearchResult models
import '../services/search_service.dart'; // Import Search Service

class SearchProvider with ChangeNotifier {
  // State variables
  List<OrganicResult> _searchResults = []; // The list of search results
  bool _isLoading = false; // To indicate if search is in progress
  String? _errorMessage; // To store any error message
  String _currentQuery = ''; // To store the current search query

  // Getters to access the state from widgets
  List<OrganicResult> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  // Instance of the SearchService
  final SearchService _searchService = SearchService();

  // Method to set the current query (optional, could also just trigger search)
  void setQuery(String query) {
    _currentQuery = query;
    notifyListeners(); // Notify listeners if needed (e.g., to show query in UI)
  }

  // Method to perform the search
  Future<void> performSearch(String query) async {
    if (_isLoading || query.isEmpty) {
      return; // Don't search if already loading or query is empty
    }

    _currentQuery = query; // Update query state
    _isLoading = true; // Set loading to true
    _errorMessage = null; // Clear any previous error
    _searchResults = []; // Clear previous results immediately
    notifyListeners(); // Notify widgets (loading started, results cleared)

    try {
      // Perform the search using the service
      final results = await _searchService.searchWeb(query);
      _searchResults = results; // Update the results list
      _errorMessage = null; // Ensure no error message remains
    } catch (e) {
      // Handle errors
      _errorMessage = 'Search failed: ${e.toString()}'; // Set error message
      _searchResults = []; // Clear results on error
      print('Error performing search: $e'); // Print error to console
    } finally {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify widgets that search is complete
    }
  }

  // Method to clear search results and query
  void clearSearch() {
    _searchResults = [];
    _currentQuery = '';
    _errorMessage = null;
    notifyListeners();
  }
}