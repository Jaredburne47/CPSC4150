class Quote {

  String text;
  String author;
  String category;
  int likes;
  DateTime createdAt;

  Quote({ required this.text, required this.author,
    required this.category, this.likes = 0,  DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

