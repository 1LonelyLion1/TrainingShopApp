import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.priceCents,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
  });

  /// Бросает [FormatException] или [TypeError] на некорректных данных.
  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    final ratingMap = rating is Map<String, dynamic>
        ? rating
        : const <String, dynamic>{};
    final price = (json['price'] as num).toDouble();
    if (price < 0 || !price.isFinite) {
      throw const FormatException('Invalid price');
    }
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      priceCents: (price * 100).round(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingMap['rate'] as num?)?.toDouble() ?? 0,
      ratingCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }

  final int id;
  final String title;
  final int priceCents;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int ratingCount;

  @override
  List<Object?> get props => [
    id,
    title,
    priceCents,
    description,
    category,
    imageUrl,
    rating,
    ratingCount,
  ];
}
