
// lib/widgets/article_card.dart

import 'package:flutter/material.dart';
// Import cached_network_image for efficient network image handling
import 'package:cached_network_image/cached_network_image.dart';
// Import intl for date formatting
import 'package:intl/intl.dart';

// Import the Article model
import '../models/article.dart';
// Import the Article Detail page for navigation
import '../screens/article_detail_page.dart';

class ArticleCard extends StatelessWidget {
  // The article data to display
  final Article article;
  // Callback function to be executed when the bookmark icon is tapped
  final VoidCallback onBookmarkTap;
  // Boolean indicating whether this article is currently bookmarked
  final bool isBookmarked;

  // Constructor requires the article data, bookmark tap callback, and bookmark status
  const ArticleCard({
    Key? key,
    required this.article,
    required this.onBookmarkTap,
    required this.isBookmarked,
  }) : super(key: key);

  // Helper method to format the published date string
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Date N/A'; // Return a default string if the date is null or empty
    }
    try {
      // Attempt to parse the date string (assuming ISO 8601 format common from APIs)
      final DateTime dateTime = DateTime.parse(dateString);
      // Define the desired date format: [dd MMMM, yyyy] (e.g., [24 June, 2024])
      final DateFormat formatter = DateFormat('[dd MMMM, yyyy]');
      // Format the parsed DateTime object
      return formatter.format(dateTime);
    } catch (e) {
      // Catch any errors during parsing (e.g., invalid date format)
      print('Error parsing date: $dateString - $e'); // Log the error for debugging
      return 'Invalid Date'; // Return an error string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a Card widget to provide a styled container for the article item
    return Card(
      elevation: 2.0, // Add a subtle shadow effect
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add spacing around the card
      child: InkWell( // Use InkWell to make the card tappable and provide visual feedback
        onTap: () {
           // Action when the main part of the article card is tapped
           if (article.url != null && article.url!.isNotEmpty) {
             // If a valid article URL exists, navigate to the detail page
             print('Article tapped: ${article.title}'); // Debug print
             Navigator.push(
               context,
               MaterialPageRoute(
                 // Build the ArticleDetailPage and pass the article URL to it
                 builder: (context) => ArticleDetailPage(articleUrl: article.url!),
               ),
             );
           } else {
             // If no article URL is available, show a message
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('No URL available for this article.')),
             );
           }
        },
        child: Padding( // Add internal padding within the card
          padding: const EdgeInsets.all(12.0),
          child: Column( // Arrange widgets vertically within the card
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
            children: <Widget>[
              // --- Thumbnail Image ---
              // Check if the article has a valid image URL
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                // If URL exists, display the network image
                ClipRRect( // Clip the image to give it rounded corners
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage( // Use CachedNetworkImage for better performance with network images
                    imageUrl: article.urlToImage!, // The image URL
                    height: 180, // Fixed height for the image
                    width: double.infinity, // Make the image take the full width of the card
                    fit: BoxFit.cover, // Crop and scale the image to cover the allocated space
                    // Show a placeholder while the image is loading
                    placeholder: (context, url) => Container(
                      height: 180,
                      color: Colors.grey[200], // Placeholder background color
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0)), // Loading spinner
                    ),
                    // Show an error widget if the image fails to load
                    errorWidget: (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[300], // Error background color
                      child: Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey[600])), // Error icon
                    ),
                  ),
                )
              else
                // If no image URL, display a placeholder box
                 Container(
                   height: 180,
                   color: Colors.grey[300], // Placeholder background color
                   child: Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey[600])), // Placeholder icon
                 ),
              const SizedBox(height: 12.0), // Vertical spacing after image

              // --- Title ---
              Text(
                article.title ?? 'No Title Available', // Display title, or default text if null
                style: const TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  // consider slightly darker color for readability if needed
                ),
                maxLines: 2, // Limit the title to a maximum of 2 lines
                overflow: TextOverflow.ellipsis, // Add "..." if the title overflows
              ),
              const SizedBox(height: 6.0), // Vertical spacing after title

              // --- Description ---
              Text(
                article.description ?? 'No Description Available', // Display description, or default text if null
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey[700], // Slightly less prominent color
                ),
                maxLines: 3, // Limit the description to a maximum of 3 lines
                overflow: TextOverflow.ellipsis, // Add "..." if description overflows
              ),
              const SizedBox(height: 10.0), // Vertical spacing after description

              // --- Source and Date Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out the children (Source and Date)
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Source Name (Use Expanded to prevent overflow)
                  Expanded(
                    child: Text(
                      article.sourceName ?? 'Unknown Source', // Display source name, or default
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic, // Italicize source name
                      ),
                       overflow: TextOverflow.ellipsis, // Add "..." if source name is too long
                    ),
                  ),
                  const SizedBox(width: 8.0), // Horizontal space between source and date

                  // Published Date (Formatted)
                  Text(
                    _formatDate(article.publishedAt), // Display the formatted date
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey, // Use a muted color for the date
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0), // Vertical spacing before bookmark button

              // --- Bookmark Button ---
              Align( // Align the icon to the bottom right
                alignment: Alignment.bottomRight,
                child: IconButton(
                  // Change icon based on bookmark status
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border, // Filled or outlined icon
                    size: 28, // Slightly larger icon
                  ),
                  // Change icon color based on bookmark status
                  color: isBookmarked ? Theme.of(context).primaryColor : Colors.grey[600], // Theme color or grey
                  tooltip: isBookmarked ? 'Remove Bookmark' : 'Add Bookmark', // Tooltip text
                  onPressed: onBookmarkTap, // Call the callback function when the button is pressed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

