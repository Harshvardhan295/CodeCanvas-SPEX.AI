import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/spex_api_service.dart';

class SpexChatProvider extends ChangeNotifier {
  final SpexApiService _apiService = SpexApiService();

  // App states
  bool _isInitialized = false;
  bool _isCrawling = false;
  bool _isIndexing = false;
  bool _isChatActive = false;

  // Website data
  String? _websiteUrl;
  String? _collectionName;
  List<String> _crawledPages = [];

  // Chat data
  final List<Map<String, dynamic>> _messages = [];

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isCrawling => _isCrawling;
  bool get isIndexing => _isIndexing;
  bool get isChatActive => _isChatActive;
  String? get websiteUrl => _websiteUrl;
  String? get collectionName => _collectionName;
  List<String> get crawledPages => _crawledPages;
  List<Map<String, dynamic>> get messages => _messages;

  // Initialize website crawling
  Future<void> initializeWebsite(String url) async {
    if (_isCrawling) return;

    _isCrawling = true;
    _websiteUrl = url;
    notifyListeners();

    try {
      // Step 1: Start crawling
      final crawlResult = await _apiService.crawlWebsite(url: url);

      _collectionName = crawlResult['collection_name'];
      _crawledPages = List<String>.from(crawlResult['crawled_urls'] ?? []);
      _isCrawling = false;
      _isIndexing = true;
      notifyListeners();

      // Simulate indexing delay (you can remove this if backend is fast)
      await Future.delayed(const Duration(seconds: 2));

      _isIndexing = false;
      _isInitialized = true;
      _isChatActive = true;

      // Add welcome message
      _messages.add({
        'role': 'assistant',
        'content':
            '✅ Website indexed successfully!\n\n${_crawledPages.length} pages crawled. You can ask anything from within these pages. What would you like to ask?',
        'isSystem': true,
      });

      notifyListeners();
    } catch (e) {
      _isCrawling = false;
      _isIndexing = false;
      notifyListeners();
      rethrow;
    }
  }

  // DEV ONLY: Instant mock initialization
  void debugJumpToChat(String url) {
    _websiteUrl = url;
    _collectionName = "debug_collection";
    _crawledPages = List.generate(15, (i) => "$url/page-$i.html");
    _isInitialized = true;
    _isChatActive = true;
    _isCrawling = false;
    _isIndexing = false;

    _messages.clear();
    _messages.add({
      'role': 'assistant',
      'content':
          'Hello! This is debug mode.\n\nWebsite: $url\n15 pages loaded (mock data)\n\nYou can now test the full chat UI instantly!',
      'isSystem': true,
    });

    notifyListeners();
  }

  Future<void> sendChatMessage(String message) async {
    print('🔍 Provider: sendChatMessage called with: "$message"');

    if (!_isChatActive) {
      print('❌ Provider: Chat is not active! isChatActive: $_isChatActive');
      return;
    }

    if (_collectionName == null) {
      print('❌ Provider: No collection name! collectionName: $_collectionName');
      return;
    }

    print('✅ Provider: Conditions met, proceeding...');

    // Add user message
    _messages.add({
      'role': 'user',
      'content': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifyListeners();

    print('✅ Provider: User message added to UI');

    try {
      print('🌐 Provider: Calling API with collection: $_collectionName');

      final chatResult = await _apiService.chatWithWebsite(
        collectionName: _collectionName!,
        question: message,
      );

      print('✅ Provider: API response received: ${chatResult.keys}');

      // Add AI response
      _messages.add({
        'role': 'assistant',
        'content': chatResult['answer'] ?? 'No answer returned',
        'sources': List<String>.from(chatResult['sources'] ?? []),
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('✅ Provider: AI response added to UI');
    } catch (e) {
      print('❌ Provider: Error: $e');

      // Add error message
      _messages.add({
        'role': 'assistant',
        'content': '❌ Error: $e',
        'isError': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    notifyListeners();
    print('✅ Provider: UI notified of changes');
  }

  // Reset chat
  void reset() {
    _isInitialized = false;
    _isCrawling = false;
    _isIndexing = false;
    _isChatActive = false;
    _websiteUrl = null;
    _collectionName = null;
    _crawledPages.clear();
    _messages.clear();
    notifyListeners();
  }
}
