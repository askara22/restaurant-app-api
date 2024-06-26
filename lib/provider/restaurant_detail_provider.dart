import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_2/data/api/api_service.dart';
import 'package:restaurant_app_2/data/model/detail_restaurant.dart';
import 'package:restaurant_app_2/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected = (result != ConnectivityResult.none);
      notifyListeners();
    });
    fetchRestaurantDetail();
  }

  late RestaurantDetailResult _restaurantDetailResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  RestaurantDetailResult get result => _restaurantDetailResult;
  ResultState get state => _state;

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = (connectivityResult != ConnectivityResult.none);
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.fetchRestaurantDetail(id);
      _state = ResultState.hasData;
      _restaurantDetailResult = restaurantDetail;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
