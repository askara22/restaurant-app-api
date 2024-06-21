import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_2/provider/restaurant_provider.dart';
import 'package:restaurant_app_2/widgets/card_restaurant.dart';
import 'package:restaurant_app_2/widgets/no_internet_ui.dart';

class RestaurantListPage extends StatefulWidget {
  final String title;
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key, required this.title});

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantListPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<RestaurantProvider>(
            builder: (context, provider, _) {
              return !provider.isSearching
                  ? Text(widget.title)
                  : _searchTextField(context, provider);
            },
          ),
          actions: [
            Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                return IconButton(
                  icon: Icon(provider.isSearching ? Icons.clear : Icons.search),
                  onPressed: () {
                    if (provider.isSearching) {
                      provider.stopSearch();
                      searchController.clear();
                    } else {
                      provider.startSearch();
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<RestaurantProvider>(
          builder: (context, provider, _) {
            if (!provider.isConnected) {
              return const NoInternetUI();
            }
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }
            if (provider.restaurants.isEmpty) {
              return const Center(
                child: Text(
                  'Restaurant not found',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = provider.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          },
        ),
      ),
    );
  }

  TextField _searchTextField(
      BuildContext context, RestaurantProvider provider) {
    return TextField(
      controller: searchController,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: 'Search Restaurants',
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) {
        if (query.isNotEmpty) {
          provider.searchRestaurants(query);
        } else {
          provider.fetchRestaurantList();
        }
      },
    );
  }
}
