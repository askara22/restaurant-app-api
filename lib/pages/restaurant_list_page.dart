import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app_2/data/api/api_service.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:restaurant_app_2/pages/restaurant_detail_page.dart';
import 'package:connectivity/connectivity.dart';

class RestaurantListPage extends StatefulWidget {
  final String title;
  static const routeName = '/restaurant_list';

  const RestaurantListPage({Key? key, required this.title}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantListPage> {
  bool _searchBoolean = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  late Future<RestaurantListResult> _restaurantList;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
      });
    });
    _loadRestaurantList();
    _restaurantList = ApiService().fetchRestaurantList();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
        if (searchQuery.isNotEmpty) {
          _restaurantList = ApiService().searchRestaurants(searchQuery);
        } else {
          _restaurantList = ApiService().fetchRestaurantList();
        }
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  Future<void> _loadRestaurantList() async {
    setState(() {
      _restaurantList = ApiService().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        searchController.clear();
                        _restaurantList = ApiService().fetchRestaurantList();
                      });
                    })
              ],
      ),
      body: isConnected ? _buildRestaurantList() : _buildNoInternetUI(),
    );
  }

  FutureBuilder<RestaurantListResult> _buildRestaurantList() {
    return FutureBuilder(
      future: _restaurantList,
      builder: (context, AsyncSnapshot<RestaurantListResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          if (snapshot.data!.restaurants.isEmpty) {
            return const Center(
              child: Text(
                'Please enter the restaurant name or menu name correctly!',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = snapshot.data!.restaurants[index];
                return _buildRestaurantItem(context, restaurant);
              },
            );
          }
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }

  Widget _buildNoInternetUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'No internet connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
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

  Card _buildRestaurantItem(BuildContext context, RestaurantList restaurant) {
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
        subtitle: Row(
          children: [
            Icon(
              Icons.location_pin,
              color: Colors.green[700],
              size: 12,
            ),
            Text(
              restaurant.city,
              style: const TextStyle(fontSize: 12),
            ),
          ],
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
