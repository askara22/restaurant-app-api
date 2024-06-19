import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app_2/model/restaurant.dart';
import 'package:restaurant_app_2/pages/restaurant_detail.dart';

class RestaurantList extends StatefulWidget {
  final String title;
  static const routeName = '/restaurant_list';

  const RestaurantList({Key? key, required this.title}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  bool _searchBoolean = false;
  List<Restaurant> restaurants = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadJsonData();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  Future<void> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/local_restaurant.json');
    final jsonResponse = jsonDecode(jsonString);
    final List<dynamic> restaurantsJson = jsonResponse['restaurants'];
    setState(() {
      restaurants = restaurantsJson
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Restaurant> filteredRestaurants = restaurants.where((restaurant) {
      return restaurant.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          restaurant.city.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: !_searchBoolean ? Text(widget.title) : _searchTextField(),
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                        });
                      })
                ]
              : [
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                        });
                      })
                ]),
      body: filteredRestaurants.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(
                    context, filteredRestaurants[index]);
              },
            ),
    );
  }

  TextField _searchTextField() {
    return TextField(
      controller: searchController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: 'Search Restaurants',
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
    );
  }

  Card _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            restaurant.pictureId,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          restaurant.name,
          style: GoogleFonts.sora(textStyle: const TextStyle(fontSize: 14)),
        ),
        subtitle: Text(
          restaurant.city,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
            width: 36,
            height: 25,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green[700],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 16,
                ),
                Text(
                  restaurant.rating.toString(),
                  style: const TextStyle(fontSize: 8, color: Colors.white),
                ),
              ],
            )),
        onTap: () {
          Navigator.pushNamed(context, RestaurantDetail.routeName,
              arguments: restaurant);
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
