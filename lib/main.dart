import 'package:flutter/material.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:restaurant_app_2/pages/restaurant_detail_page.dart';
import 'package:restaurant_app_2/pages/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.white,
              onPrimary: Colors.black,
              secondary: Colors.green[400],
            ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 242, 244, 243),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
      ),
      initialRoute: RestaurantListPage.routeName,
      routes: {
        RestaurantListPage.routeName: (context) => const RestaurantListPage(
              title: 'Restaurant App',
            ),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            id: ModalRoute.of(context)?.settings.arguments as String)
      },
    );
  }
}
