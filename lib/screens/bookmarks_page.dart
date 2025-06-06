
// lib/screens/bookmarks_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/bookmark_provider.dart';
import '../widgets/article_card.dart'; 
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        final bookmarkedArticles = bookmarkProvider.bookmarkedArticles;
        if (bookmarkedArticles.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No bookmarks yet!\nBookmark articles from the news feed to see them here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: bookmarkedArticles.length, // The number of items in the list
            itemBuilder: (context, index) {
              // Get the current article for this list item
              final article = bookmarkedArticles[index];
              return ArticleCard(
                article: article, // Pass the article data to the card
                isBookmarked: true, // On the bookmarks page, all shown articles ARE bookmarked
                onBookmarkTap: () {
                   bookmarkProvider.removeBookmark(article);
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('Removed "${article.title ?? 'Article'}" from bookmarks'),
                       duration: const Duration(seconds: 2), // How long the snackbar is visible
                     ),
                   );
                },
                // The ArticleCard's internal InkWell handles navigation to ArticleDetailPage
              );
            },
          );
        }
      },
    );
  }
}