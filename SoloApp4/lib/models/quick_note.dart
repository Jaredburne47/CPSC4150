// Data model representing a single note
class QuickNote {
  final String id;
  final String text;
  final DateTime createdAt;
  final bool isStarred;

  QuickNote({
    required this.id,
    required this.text,
    required this.createdAt,
    this.isStarred = false,
  });

  // Creates a copy of this note with updated fields
  QuickNote copyWith({String? text, bool? isStarred}) => QuickNote(
    id: id,
    text: text ?? this.text,
    createdAt: createdAt,
    isStarred: isStarred ?? this.isStarred,
  );

  // Convert a QuickNote to a JSON-compatible map
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'isStarred': isStarred,
  };

  // Construct a QuickNote from JSON data
  static QuickNote fromJson(Map<String, dynamic> m) => QuickNote(
    id: m['id'] as String,
    text: m['text'] as String,
    createdAt:
    DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
    isStarred: (m['isStarred'] as bool?) ?? false,
  );
}