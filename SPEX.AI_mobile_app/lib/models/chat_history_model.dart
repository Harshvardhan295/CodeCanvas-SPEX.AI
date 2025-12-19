class ChatHistoryItem {
  final String id;
  final String websiteUrl;
  final String collectionName;
  final DateTime createdAt;
  final int pageCount;
  final String? lastQuestion;
  final String? lastAnswer;

  ChatHistoryItem({
    required this.id,
    required this.websiteUrl,
    required this.collectionName,
    required this.createdAt,
    required this.pageCount,
    this.lastQuestion,
    this.lastAnswer,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'websiteUrl': websiteUrl,
      'collectionName': collectionName,
      'createdAt': createdAt.toIso8601String(),
      'pageCount': pageCount,
      'lastQuestion': lastQuestion,
      'lastAnswer': lastAnswer,
    };
  }

  // Create from Map
  factory ChatHistoryItem.fromMap(Map<String, dynamic> map) {
    return ChatHistoryItem(
      id: map['id'] as String,
      websiteUrl: map['websiteUrl'] as String,
      collectionName: map['collectionName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      pageCount: map['pageCount'] as int,
      lastQuestion: map['lastQuestion'] as String?,
      lastAnswer: map['lastAnswer'] as String?,
    );
  }

  // Get domain for display
  String get domain {
    try {
      final uri = Uri.parse(websiteUrl);
      return uri.host;
    } catch (e) {
      return websiteUrl;
    }
  }

  // Format date for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}
