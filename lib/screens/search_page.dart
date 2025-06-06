// lib/screens/search_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

import '../providers/search_provider.dart'; // Import SearchProvider
//import '../models/search_result.dart'; // Import SearchResult models
import '../widgets/search_result_tile.dart'; // Import SearchResultTile (create this next)
import 'article_detail_page.dart'; // Import Article Detail Page (for opening links)

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late SearchProvider _searchProvider; // Get provider instance

  @override
  void initState() {
    super.initState();
    // Access the provider after the widget is built
    // Use listen: false because we only call methods, not listen for changes here
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
    // Set the initial text field value from the provider's current query
    _searchController.text = _searchProvider.currentQuery;
     // Clear previous results when entering the search page (optional, could also persist)
    // _searchProvider.clearSearch(); // If you want to start fresh every time
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  // Method to trigger the search
  void _onSearchSubmitted(String query) {
    _searchProvider.performSearch(query.trim()); // Call provider's search method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField( // Place TextField directly in AppBar for search bar look
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search the web...',
            border: InputBorder.none, // No border for clean look in AppBar
            hintStyle: TextStyle(color: Colors.white70), // Hint text color
            suffixIcon: IconButton( // Add a clear button
              icon: Icon(Icons.clear, color: Colors.white70),
              onPressed: () {
                 _searchController.clear(); // Clear text field
                 _searchProvider.clearSearch(); // Clear results via provider
              },
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18.0), // Input text style
          textInputAction: TextInputAction.search, // Show search icon on keyboard
          onSubmitted: _onSearchSubmitted, // Call search method when user submits
          autofocus: true, // Automatically focus the text field when page opens
        ),
        // Remove default back button if you want custom handling,
        // but default is usually fine.
        // leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Consumer<SearchProvider>( // Consume SearchProvider for results/state
        builder: (context, searchProvider, child) {
          // --- Display UI based on SearchProvider state ---

          if (searchProvider.isLoading) {
            // Show loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (searchProvider.errorMessage != null) {
            // Show error message
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${searchProvider.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          } else if (searchProvider.searchResults.isEmpty) {
             // Show different message based on whether a search was performed
             if (searchProvider.currentQuery.isEmpty) {
                return const Center(
                  child: Text(
                    'Enter a query to search the web.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
             } else {
                return Center(
                   child: Text(
                     'No results found for "${searchProvider.currentQuery}".',
                     textAlign: TextAlign.center,
                     style: const TextStyle(fontSize: 18, color: Colors.grey),
                   ),
                );
             }
          } else {
            // If results are loaded, display the list
            return ListView.builder(
              itemCount: searchProvider.searchResults.length,
              itemBuilder: (context, index) {
                final result = searchProvider.searchResults[index];
                 // Display the SearchResultTile
                 return SearchResultTile(
                   result: result,
                   onTap: () {
                     // Open the search result link in the WebView
                     if (result.link != null && result.link!.isNotEmpty) {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => ArticleDetailPage(articleUrl: result.link!), // Reuse ArticleDetailPage for WebView
                         ),
                       );
                     } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No link available for this result.')),
                        );
                     }
                   },
                 );
              },
            );
          }
        },
      ),
    );
  }
}