class Quote {
  final int id;
  final String category;
  final String quote;
  final String author;

  Quote({
    required this.id,
    required this.category,
    required this.quote,
    required this.author,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      category: map['category'],
      quote: map['quote'],
      author: map['author'],
    );
  }
}
