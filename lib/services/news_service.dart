// lib/services/news_service.dart

import 'package:dio/dio.dart'; // Import Dio
import '../models/article.dart'; // Import the Article model

class NewsService {
  // Use the Dio instance
  final Dio _dio = Dio();

  // Base URL for the API (Example using News API)
  static const String _baseUrl = 'https://newsapi.org/v2/';
  // Replace with your actual API Key! Get one from newsapi.org or another provider.
  static const String _apiKey = '35c584e873624cdd90cc2338ca34f0c7'; // <--- !!! REPLACE THIS !!!

  // Function to fetch top headlines (example endpoint)
  Future<List<Article>> fetchTopHeadlines({String category = 'technology', String country = 'us'}) async {
    try {
      // Make the GET request
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'apiKey': _apiKey,
          'category': category,
          'country': country,
          // You can add more parameters like 'q' for search later
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = response.data;

        // Get the list of articles from the 'articles' key
        final List<dynamic> articlesJson = data['articles'];

        // Convert the list of JSON objects into a list of Article objects
        List<Article> articles = articlesJson.map((json) => Article.fromJson(json)).toList();

        return articles;
      } else {
        // If the status code is not 200, throw an exception
        throw Exception('Failed to load news: Status code ${response.statusCode}');
      }
    } on DioException catch (e) { // Catch Dio specific errors
       if (e.response != null) {
         print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
         throw Exception('Failed to load news: Server error - ${e.response?.statusCode}');
       } else {
         print('Dio error! ${e.message}');
         throw Exception('Failed to load news: Network error - ${e.message}');
       }
    } catch (e) {
      // Catch any other exceptions
      print('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // You could add other methods here for searching news, getting everything, etc.
  // Future<List<Article>> searchNews({required String query}) async { ... }
}