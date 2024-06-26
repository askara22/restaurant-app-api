import 'package:flutter/material.dart';
import 'package:restaurant_app_2/data/db/database_helper.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:restaurant_app_2/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavRest();
  }

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantList> _favRest = [];
  List<RestaurantList> get favRest => _favRest;

  void _getFavRest() async {
    _favRest = await databaseHelper.getFavRest();
    if (_favRest.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavRest(RestaurantList restaurant) async {
    try {
      await databaseHelper.insertFavRest(restaurant);
      _getFavRest();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final favoriteRestaurant = await databaseHelper.getFavRestById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeFavRest(String id) async {
    try {
      await databaseHelper.removeFavRest(id);
      _getFavRest();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
