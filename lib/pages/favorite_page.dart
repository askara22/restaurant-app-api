import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_2/provider/database_provider.dart';
import 'package:restaurant_app_2/utils/result_state.dart';
import 'package:restaurant_app_2/widgets/card_restaurant.dart';
import 'package:restaurant_app_2/widgets/platform_widget.dart';

class FavoritePage extends StatelessWidget {
  static const String bookmarksTitle = 'My Favorite';

  const FavoritePage({super.key});

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(bookmarksTitle),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(bookmarksTitle),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favRest.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favRest[index]);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
