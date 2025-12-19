import 'dart:convert';
import 'package:http/http.dart' as http;

class SpexApiService {
  static const String _baseUrl = 'https://webcrawler-h6ag.onrender.com';

  Future<Map<String, dynamic>> crawlWebsite({
    required String url,
    int maxDepth = 2,
    int maxPages = 20,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/crawl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'url': url,
          'max_depth': maxDepth,
          'max_pages': maxPages,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to crawl website: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> chatWithWebsite({
    required String collectionName,
    required String question,
    List<Map<String, String>> history = const [],
  }) async {
    print('🌐 API Service: Sending chat request...');
    print('   Collection: $collectionName');
    print('   Question: $question');

    try {
      final url = Uri.parse('$_baseUrl/chat');
      print('   URL: $url');

      final body = jsonEncode({
        'collection_name': collectionName,
        'question': question,
        'history': history,
      });

      print('   Request Body: $body');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('   Response Status: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('✅ API Service: Success!');
        return result;
      } else {
        print('❌ API Service: Failed with status ${response.statusCode}');
        throw Exception('Failed to get chat response: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Service: Network error: $e');
      throw Exception('Network error: $e');
    }
  }
}
