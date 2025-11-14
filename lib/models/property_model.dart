class Property {
  final int id;
  final String title;
  final String? description;
  final String category;
  final String location;
  final double? price;
  final String? priceType; // 'month', 'day', 'sale'
  final double? rating;
  final String? imageUrl;
  final List<String>? images;
  final bool? isFavorite;
  final Map<String, dynamic>? details; // rooms, area, etc.

  Property({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.location,
    this.price,
    this.priceType,
    this.rating,
    this.imageUrl,
    this.images,
    this.isFavorite,
    this.details,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Price parsing - string, int, double olabilir
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    // Rating parsing - string, int, double olabilir
    double? parseRating(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return Property(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      category: json['category'] ?? json['type'] ?? '',
      location: json['location'] ?? json['address'] ?? '',
      price: parsePrice(json['price']),
      priceType: json['price_type'] ?? json['priceType'],
      rating: parseRating(json['rating']),
      imageUrl: json['image'] ?? json['image_url'] ?? json['imageUrl'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      isFavorite: json['is_favorite'] ?? json['isFavorite'],
      details: json['details'] ?? json,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'price': price,
        'price_type': priceType,
        'rating': rating,
        'image': imageUrl,
        'images': images,
        'is_favorite': isFavorite,
        'details': details,
      };
}

