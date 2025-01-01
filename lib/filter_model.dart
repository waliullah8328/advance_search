class Course {
  final String title;
  final String imageUrl;
  final String category;
  final double price;
  final String language;
  final double rating;
  final int duration; // Duration in hours
  final int lessons; // Number of lessons

  Course({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.language,
    required this.rating,
    required this.duration,
    required this.lessons,
  });
}
