import 'package:flutter/material.dart';
import 'package:flutter_wavysmap_native/map/ui/splash.dart';

import '../constants/restaurants.dart';

Widget carouselCard(int index, num distance, num duration) {
  return InkWell(
    onTap: (){
      print(index);
      print("タップ！");
    },
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              // backgroundImage: NetworkImage(restaurants[index]['image']),
              backgroundImage: NetworkImage(products[index].image),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // restaurants[index]['name'],
                    products[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Text(restaurants[index]['items'],
                  Text(products[index].items,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Text(
                    '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                    style: const TextStyle(color: Colors.tealAccent),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
