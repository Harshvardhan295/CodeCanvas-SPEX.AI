import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_history_model.dart';

class HistoryStorageService {
  static const String _historyKey = 'chat_history';
  static const int _maxHistoryItems = 50; // Limit stored items

  // Save history item
  static Future<void> saveHistoryItem(ChatHistoryItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing history
      final existingJson = prefs.getStringList(_historyKey) ?? [];
      final List<ChatHistoryItem> existingItems =
          existingJson
              .map(
                (json) => ChatHistoryItem.fromMap(
                  Map<String, dynamic>.from(json as Map),
                ),
              )
              .toList();

      // Remove duplicate if exists (same website)
      existingItems.removeWhere(
        (existing) => existing.websiteUrl == item.websiteUrl,
      );

      // Add new item at beginning
      existingItems.insert(0, item);

      // Limit the number of stored items
      final limitedItems =
          existingItems.length > _maxHistoryItems
              ? existingItems.sublist(0, _maxHistoryItems)
              : existingItems;

      // Convert to JSON and save
      final jsonList = limitedItems.map((item) => item.toMap()).toList();
      final stringList = jsonList.map((map) => map.toString()).toList();

      await prefs.setStringList(_historyKey, stringList);

      print('✅ History saved: ${item.websiteUrl}');
    } catch (e) {
      print('❌ Error saving history: $e');
    }
  }

  // Get all history items
  static Future<List<ChatHistoryItem>> getHistoryItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_historyKey) ?? [];

      final items =
          jsonList
              .map((jsonString) {
                try {
                  // Convert string back to Map
                  final json = jsonString
                      .replaceAll('{', '{"')
                      .replaceAll(': ', '": "')
                      .replaceAll(', ', '", "')
                      .replaceAll('}', '"}');
                  final map = <String, dynamic>{};
                  final pairs = json
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('"', '')
                      .split(', ');
                  for (final pair in pairs) {
                    final keyValue = pair.split(': ');
                    if (keyValue.length == 2) {
                      map[keyValue[0]] = keyValue[1];
                    }
                  }

                  return ChatHistoryItem.fromMap(map);
                } catch (e) {
                  print('❌ Error parsing history item: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<ChatHistoryItem>()
              .toList();

      return items;
    } catch (e) {
      print('❌ Error loading history: $e');
      return [];
    }
  }

  // Delete specific history item
  static Future<void> deleteHistoryItem(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final items = await getHistoryItems();

      // Remove item with matching ID
      final updatedItems = items.where((item) => item.id != id).toList();

      // Save back
      final jsonList = updatedItems.map((item) => item.toMap()).toList();
      final stringList = jsonList.map((map) => map.toString()).toList();

      await prefs.setStringList(_historyKey, stringList);

      print('🗑️ History item deleted: $id');
    } catch (e) {
      print('❌ Error deleting history item: $e');
    }
  }

  // Clear all history
  static Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      print('🧹 All history cleared');
    } catch (e) {
      print('❌ Error clearing history: $e');
    }
  }

  // Update last question/answer for a history item
  static Future<void> updateLastInteraction({
    required String websiteUrl,
    required String question,
    required String answer,
  }) async {
    try {
      final items = await getHistoryItems();
      final index = items.indexWhere((item) => item.websiteUrl == websiteUrl);

      if (index != -1) {
        final item = items[index];
        final updatedItem = ChatHistoryItem(
          id: item.id,
          websiteUrl: item.websiteUrl,
          collectionName: item.collectionName,
          createdAt: item.createdAt,
          pageCount: item.pageCount,
          lastQuestion: question,
          lastAnswer: answer,
        );

        items[index] = updatedItem;

        // Save back
        final prefs = await SharedPreferences.getInstance();
        final jsonList = items.map((item) => item.toMap()).toList();
        final stringList = jsonList.map((map) => map.toString()).toList();

        await prefs.setStringList(_historyKey, stringList);

        print('📝 Updated last interaction for: $websiteUrl');
      }
    } catch (e) {
      print('❌ Error updating interaction: $e');
    }
  }
}
