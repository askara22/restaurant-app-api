class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
    );
  }
}

class RestaurantList {
  final List<Restaurant> restaurants;

  RestaurantList({required this.restaurants});

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    var list = json['restaurants'] as List;
    List<Restaurant> restaurantList =
        list.map((i) => Restaurant.fromJson(i)).toList();

    return RestaurantList(restaurants: restaurantList);
  }
}
