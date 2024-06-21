import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:restaurant_app_2/data/api/api_service.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isConnected = true;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _isSearching = false;
  List<RestaurantList> _restaurants = [];

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  List<RestaurantList> get restaurants => _restaurants;

  RestaurantProvider() {
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected = (result != ConnectivityResult.none);
      notifyListeners();
    });
    fetchRestaurantList();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = (connectivityResult != ConnectivityResult.none);
    notifyListeners();
  }

  Future<void> fetchRestaurantList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await ApiService().fetchRestaurantList();
      _restaurants = result.restaurants;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load restaurants: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query) async {
    _isLoading = true;
    _searchQuery = query;
    notifyListeners();
    try {
      final result = await ApiService().searchRestaurants(query);
      _restaurants = result.restaurants;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load search results: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    fetchRestaurantList();
  }

  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearch() {
    _searchQuery = '';
    _isSearching = false;
    fetchRestaurantList();
  }
}
