// lib/screens/news_feed_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

import '../providers/news_provider.dart'; // Import NewsProvider
import '../providers/bookmark_provider.dart'; // Import BookmarkProvider
import '../widgets/article_card.dart'; // Import ArticleCard widget

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to rebuild only this part of the tree when NewsProvider changes
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        // --- Display UI based on NewsProvider state ---

        if (newsProvider.isLoading) {
          // Show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (newsProvider.errorMessage != null) {
          // Show error message
          return Center(
            child: Text(
              'Error: ${newsProvider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else if (newsProvider.articles.isEmpty) {
          // Show message if no articles are available (and not loading/error)
           return const Center(
             child: Text(
               'No news articles available.',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 18, color: Colors.grey),
             ),
           );
        } else {
          // If data is loaded, no error, and articles exist, display the list
          return ListView.builder(
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              final article = newsProvider.articles[index];

              // Use Consumer for BookmarkProvider within the list item
              // This way, only the BookmarkProvider state changes cause this item to rebuild
              return Consumer<BookmarkProvider>(
                 builder: (context, bookmarkProvider, child) {
                   final isBookmarked = bookmarkProvider.isBookmarked(article);
                   return ArticleCard(
                     article: article,
                     // Pass the bookmark tap logic
                     onBookmarkTap: () {
                       if (isBookmarked) {
                          bookmarkProvider.removeBookmark(article);
                       } else {
                          bookmarkProvider.addBookmark(article);
                       }
                     },
                     isBookmarked: isBookmarked, // Pass bookmark status
                   );
                 },
              );
            },
          );
        }
      },
    );
  }
}