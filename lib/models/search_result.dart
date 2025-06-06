// lib/models/search_result.dart

// Model for an individual organic search result item
class OrganicResult {
  final String? title;
  final String? link; // The URL
  final String? snippet; // The descriptive text
  // You could add more fields like displayLink, date, imageUrl etc. if needed

  OrganicResult({
    this.title,
    this.link,
    this.snippet,
  });

  // Factory constructor to create an OrganicResult from JSON
  factory OrganicResult.fromJson(Map<String, dynamic> json) {
    return OrganicResult(
      title: json['title'] as String?,
      link: json['link'] as String?,
      snippet: json['snippet'] as String?,
    );
  }
}

// Model for the overall Serper API response (simplified)
class SerperResponse {
  final List<OrganicResult>? organic; // The list of organic results

  SerperResponse({this.organic});

  // Factory constructor to create a SerperResponse from JSON
  factory SerperResponse.fromJson(Map<String, dynamic> json) {
    return SerperResponse(
      // Map the list of dynamic items under the 'organic' key to OrganicResult objects
      organic: (json['organic'] as List<dynamic>?)
          ?.map((item) => OrganicResult.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}