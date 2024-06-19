import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_2/data/model/list_restaurant.dart';

Future<RestaurantList> fetchRestaurantList() async {
  final response =
      await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

  if (response.statusCode == 200) {
    return RestaurantList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant list');
  }
}
