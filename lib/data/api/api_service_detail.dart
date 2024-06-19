import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_2/data/model/detail_restaurant.dart';

Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'));

  if (response.statusCode == 200) {
    return RestaurantDetail.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load restaurant detail');
  }
}
