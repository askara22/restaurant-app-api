import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app_2/data/api/api_service_list.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:restaurant_app_2/pages/restaurant_detail_page.dart';

class RestaurantListPage extends StatefulWidget {
  final String title;
  static const routeName = '/restaurant_list';

  const RestaurantListPage({Key? key, required this.title}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantListPage> {
  bool _searchBoolean = false;
  List<Restaurant> restaurants = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
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
      body: FutureBuilder<RestaurantList>(
        future: fetchRestaurantList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = snapshot.data!.restaurants[index];
                return _buildRestaurantItem(context, restaurant);
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
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
            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
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
          Navigator.pushNamed(
            context,
            RestaurantDetailPage.routeName,
            arguments: restaurant.id,
          );
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
