import 'package:flutter/material.dart';

/// Return the corresponding star icon and rating value
Row buildRateStars(dynamic rate, String align) {
  return Row(
    mainAxisAlignment:
        align == 'center' ? MainAxisAlignment.center : MainAxisAlignment.start,
    children: [
      // Generate star icons based on rating
      ...getStarIconsBasedOnRate(rate),
      const SizedBox(width: 4),
      // Display the rating number
      Text(
        rate.toStringAsFixed(1),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

/// Return the corresponding star icon based on the rating
List<Icon> getStarIconsBasedOnRate(dynamic rate) {
  // Parse the rate to double, default to 0.0 if rate is not a number (or no rating available)
  double parsedRate = rate is num ? rate.toDouble() : 0.0;

  // Calculate the number of full stars and half stars
  int fullStars = parsedRate.floor();
  int halfStars = parsedRate.ceil() - fullStars;

  // Initialize an empty list to hold the star icons
  List<Icon> stars = [];

  // If the parsed rate is zero, then add an empty star
  if (parsedRate == 0.0) {
    stars.add(const Icon(Icons.star_border_outlined, color: Colors.yellow));
  } else {
    // Add full star icons based on the fullStars count
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.yellow));
    }
    // If there's a half star, add a half star icon
    if (halfStars > 0) {
      stars.add(const Icon(Icons.star_half, color: Colors.yellow));
    }
  }

  return stars; // Return the list of star icons
}
