// lib/widgets/search_result_tile.dart

import 'package:flutter/material.dart';
import '../models/search_result.dart'; // Import SearchResult model

class SearchResultTile extends StatelessWidget {
  final OrganicResult result; // The search result data
  final VoidCallback onTap; // Callback for when the tile is tapped

  const SearchResultTile({
    Key? key,
    required this.result,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use ListTile or a custom layout within a Card/InkWell
    return Card( // Optional: Wrap in Card for styling
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 1.0,
      child: InkWell( // Make the tile tappable
        onTap: onTap, // Call the provided onTap callback
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              if (result.title != null && result.title!.isNotEmpty)
                Text(
                  result.title!,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor, // Use primary color for links
                    decoration: TextDecoration.underline, // Indicate it's a link
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 4.0),

              // Link (Optional, often display the URL)
              if (result.link != null && result.link!.isNotEmpty)
                 Text(
                   result.link!,
                   style: TextStyle(
                     fontSize: 13.0,
                     color: Colors.green[700], // Common color for URLs in search results
                   ),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ),
              const SizedBox(height: 8.0),

              // Snippet (Description)
              if (result.snippet != null && result.snippet!.isNotEmpty)
                Text(
                  result.snippet!,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyMedium?.color, // Use theme's default text color
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}