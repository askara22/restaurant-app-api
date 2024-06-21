import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app_2/data/model/list_restaurant.dart';
import 'package:restaurant_app_2/pages/restaurant_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final RestaurantList restaurant;

  const CardRestaurant({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
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
}
