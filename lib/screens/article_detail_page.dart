

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import webview_flutter

class ArticleDetailPage extends StatefulWidget {
  final String articleUrl; // The URL of the article to load

  const ArticleDetailPage({Key? key, required this.articleUrl}) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  // Controller for the WebView
  late final WebViewController _controller;
  bool _isLoading = true; // State to track if the page is loading

  @override
  void initState() {
    super.initState();

    // Initialize the WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JavaScript
      ..setNavigationDelegate( // Set a delegate to handle navigation events
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress (optional)
            debugPrint('WebView is loading (progress: $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
             setState(() { _isLoading = true; }); // Show loading on page start
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() { _isLoading = false; }); // Hide loading on page finish
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page loading failed:
                URL: ${error.url}
                Error Code: ${error.errorCode}
                Description: ${error.description}
                For കേരളം : ${error.errorType}
            ''');
             setState(() { _isLoading = false; }); // Hide loading on error
             // Optionally show an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load page: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
             // You can control which URLs are allowed to load here
             // if (request.url.startsWith('https://www.youtube.com/')) {
             //   return NavigationDecision.prevent; // Prevent loading youtube links
             // }
            debugPrint('Allowing navigation to ${request.url}');
            return NavigationDecision.navigate; // Allow navigation to the requested URL
          },
        ),
      );
      // You can add specific platform settings if needed
      // ..setPlatformNavigationDelegate() // Add platform-specific delegate
      // ..loadRequest(Uri.parse(widget.articleUrl)); // Load the initial URL

     // Load the initial URL after the controller is configured
      _controller.loadRequest(Uri.parse(widget.articleUrl));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'), // Generic title, as article title might be too long
        // Optional: Add a back button automatically provided by Navigator
        // Or add buttons to refresh, go back/forward in WebView history
        actions: <Widget>[
           IconButton(
             icon: Icon(Icons.refresh),
             onPressed: () {
                _controller.reload(); // Reload the current page
             },
           ),
           // Add more actions like forward/back buttons if needed
           // IconButton(
           //   icon: Icon(Icons.arrow_back),
           //   onPressed: () async {
           //     if (await _controller.canGoBack()) {
           //       await _controller.goBack();
           //     } else {
           //        // Optionally navigate back in the Flutter app if no web history
           //       Navigator.pop(context);
           //     }
           //   },
           // ),
        ],
      ),
      body: Stack( // Use Stack to overlay loading indicator on WebView
        children: [
          WebViewWidget(controller: _controller), // The WebView itself
          if (_isLoading) // Show loading indicator if isLoading is true
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}