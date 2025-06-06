// lib/services/search_service.dart

import 'package:dio/dio.dart'; // Import Dio
import '../models/search_result.dart'; // Import SearchResult models

class SearchService {
  final Dio _dio = Dio();

  static const String _baseUrl = 'https://google.serper.dev/';
  // !!! REPLACE WITH YOUR ACTUAL SERPER API KEY !!!
  static const String _apiKey = 'b1ab6ee6c30c778888f06e03083d46bddf89b310'; // <--- !!! REPLACE THIS !!!

  // Function to perform a web search
  Future<List<OrganicResult>> searchWeb(String query) async {
    if (query.isEmpty) {
      return []; // Return empty list if query is empty
    }

    try {
      // Serper API uses POST requests for search
      final response = await _dio.post(
        '$_baseUrl/search',
        options: Options(
          headers: {
            'X-API-KEY': _apiKey, // API key goes in headers
            'Content-Type': 'application/json',
          },
        ),
        data: { // Search query and other parameters go in the request body
          'q': query,
          'num': 20, // Number of results to fetch (optional)
          // You can add more parameters like 'gl', 'hl', 'location', etc.
        },
      );

      // Check for success status code (usually 200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        // Parse the overall response and get the list of organic results
        final SerperResponse serperResponse = SerperResponse.fromJson(data);

        // Return the list of organic results (or an empty list if null)
        return serperResponse.organic ?? [];

      } else {
        // Handle non-200 status codes
        print('Serper API error! Status: ${response.statusCode}, Data: ${response.data}');
        throw Exception('Failed to perform search: Server error - ${response.statusCode}');
      }
    } on DioException catch (e) { // Catch Dio specific errors
       if (e.response != null) {
         print('Dio error! Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
         throw Exception('Failed to perform search: Server error - ${e.response?.statusCode}');
       } else {
         print('Dio error! ${e.message}');
         throw Exception('Failed to perform search: Network error - ${e.message}');
       }
    } catch (e) {
      // Catch any other exceptions
      print('An unexpected error occurred during search: $e');
      throw Exception('An unexpected error occurred during search: $e');
    }
  }
}