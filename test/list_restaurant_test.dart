import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

class RestaurantListResult {
  bool error;
  String message;
  int count;
  List<RestaurantList> restaurants;

  RestaurantListResult({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResult.fromRawJson(String str) =>
      RestaurantListResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantListResult.fromJson(Map<String, dynamic> json) =>
      RestaurantListResult(
        error: json["error"] ?? false,
        message: json["message"] ?? '',
        count: json["count"] ?? 0,
        restaurants: List<RestaurantList>.from(
            json["restaurants"]?.map((x) => RestaurantList.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class RestaurantList {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  RestaurantList({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantList.fromRawJson(String str) =>
      RestaurantList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        pictureId: json["pictureId"] ?? '',
        city: json["city"] ?? '',
        rating: json["rating"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}

void main() {
  test('JSON parsing test for valid RestaurantListResult', () {
    const jsonString = '''
    {
      "error": false,
      "message": "success",
      "count": 1,
      "restaurants": [
        {
          "id": "1",
          "name": "Restaurant 1",
          "description": "Description 1",
          "pictureId": "pic1",
          "city": "City 1",
          "rating": 4.5
        }
      ]
    }
    ''';

    final result = RestaurantListResult.fromRawJson(jsonString);

    expect(result.error, false);
    expect(result.message, "success");
    expect(result.count, 1);
    expect(result.restaurants.length, 1);

    final restaurant = result.restaurants.first;
    expect(restaurant.id, "1");
    expect(restaurant.name, "Restaurant 1");
    expect(restaurant.description, "Description 1");
    expect(restaurant.pictureId, "pic1");
    expect(restaurant.city, "City 1");
    expect(restaurant.rating, 4.5);
  });

  test('JSON parsing test for empty RestaurantListResult', () {
    const jsonString = '''
    {
      "error": false,
      "message": "No restaurants found",
      "count": 0,
      "restaurants": []
    }
    ''';

    final result = RestaurantListResult.fromRawJson(jsonString);

    expect(result.error, false);
    expect(result.message, "No restaurants found");
    expect(result.count, 0);
    expect(result.restaurants.length, 0);
  });

  test('JSON parsing test for RestaurantListResult with null values', () {
    const jsonString = '''
    {
      "error": null,
      "message": null,
      "count": null,
      "restaurants": null
    }
    ''';

    final result = RestaurantListResult.fromRawJson(jsonString);

    expect(result.error, false);
    expect(result.message, '');
    expect(result.count, 0);
    expect(result.restaurants.length, 0);
  });

  test('JSON parsing test for RestaurantList with missing fields', () {
    const jsonString = '''
    {
      "id": "1",
      "name": "Restaurant 1",
      "rating": 4.5
    }
    ''';

    final restaurant = RestaurantList.fromRawJson(jsonString);

    expect(restaurant.id, "1");
    expect(restaurant.name, "Restaurant 1");
    expect(restaurant.description, '');
    expect(restaurant.pictureId, '');
    expect(restaurant.city, '');
    expect(restaurant.rating, 4.5);
  });

  test('JSON serialization test for RestaurantList', () {
    final restaurant = RestaurantList(
      id: "1",
      name: "Restaurant 1",
      description: "Description 1",
      pictureId: "pic1",
      city: "City 1",
      rating: 4.5,
    );

    final jsonString = restaurant.toRawJson();
    final expectedJsonString = '''
    {"id":"1","name":"Restaurant 1","description":"Description 1","pictureId":"pic1","city":"City 1","rating":4.5}
    '''
        .trim();

    expect(jsonString, expectedJsonString);
  });

  test('JSON serialization test for RestaurantListResult', () {
    final restaurant = RestaurantList(
      id: "1",
      name: "Restaurant 1",
      description: "Description 1",
      pictureId: "pic1",
      city: "City 1",
      rating: 4.5,
    );

    final result = RestaurantListResult(
      error: false,
      message: "success",
      count: 1,
      restaurants: [restaurant],
    );

    final jsonString = result.toRawJson();
    final expectedJsonString = '''
    {"error":false,"message":"success","count":1,"restaurants":[{"id":"1","name":"Restaurant 1","description":"Description 1","pictureId":"pic1","city":"City 1","rating":4.5}]}
    '''
        .trim();

    expect(jsonString, expectedJsonString);
  });
}
