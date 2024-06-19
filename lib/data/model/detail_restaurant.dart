class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final List<String> categories;
  final List<String> menus;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.categories,
    required this.menus,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    var categoriesList = json['categories'] as List;
    var menusList = json['menus'] as List;

    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
      categories: categoriesList.map((i) => i['name'].toString()).toList(),
      menus: menusList.map((i) => i['name'].toString()).toList(),
    );
  }
}
