import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_2/common/navigation.dart';
import 'package:restaurant_app_2/data/api/api_service.dart';
import 'package:restaurant_app_2/data/db/database_helper.dart';
import 'package:restaurant_app_2/pages/home_page.dart';
import 'package:restaurant_app_2/pages/restaurant_detail_page.dart';
import 'package:restaurant_app_2/provider/database_provider.dart';
import 'package:restaurant_app_2/provider/restaurant_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
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
        navigatorKey: navigatorKey,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              id: ModalRoute.of(context)!.settings.arguments as String)
        },
      ),
    );
  }
}
