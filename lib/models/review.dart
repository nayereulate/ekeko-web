class Review {
  final String id;
  final String authorName;
  final double rating;
  final String comment;
  final int daysAgo;

  const Review({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.daysAgo,
  });
}
