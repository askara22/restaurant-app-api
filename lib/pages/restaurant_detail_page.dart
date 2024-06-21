import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_2/data/api/api_service.dart';
import 'package:restaurant_app_2/data/model/detail_restaurant.dart';
import 'package:restaurant_app_2/provider/restaurant_detail_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail/';

  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
      create: (_) => RestaurantDetailProvider(apiService: ApiService(), id: id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Detail'),
        ),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
              );
            } else if (state.state == ResultState.hasData) {
              var restaurantDetail = state.result.restaurant;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                        tag: restaurantDetail.pictureId,
                        child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/large/${restaurantDetail.pictureId}')),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                restaurantDetail.name,
                                style: GoogleFonts.sora(
                                    textStyle: const TextStyle(fontSize: 18)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                width: 46,
                                padding: const EdgeInsets.all(2),
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
                                      restaurantDetail.rating.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.green[700],
                                size: 16,
                              ),
                              Text(
                                restaurantDetail.city,
                                style: GoogleFonts.sora(
                                    textStyle: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            restaurantDetail.description,
                            style: const TextStyle(
                                fontSize: 14, letterSpacing: 0.5),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Foods :',
                            style: TextStyle(fontSize: 16),
                          ),
                          _buildFoodList(restaurantDetail),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Drinks :',
                            style: TextStyle(fontSize: 16),
                          ),
                          _buildDrinkList(restaurantDetail)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.state == ResultState.noData) {
              return const Center(
                child: Text('Restaurant not found'),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  SizedBox _buildDrinkList(RestaurantDetail restaurantDetail) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: restaurantDetail.menus.drinks.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[700],
              ),
              child: Text(
                textAlign: TextAlign.center,
                restaurantDetail.menus.drinks[index].name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }),
    );
  }

  SizedBox _buildFoodList(RestaurantDetail restaurantDetail) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: restaurantDetail.menus.foods.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[700],
              ),
              child: Text(
                textAlign: TextAlign.center,
                restaurantDetail.menus.foods[index].name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }),
    );
  }
}
