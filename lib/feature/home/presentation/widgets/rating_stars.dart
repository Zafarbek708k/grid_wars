import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        ...List.generate(rating, (i) => const Icon(Icons.star, color: Colors.amber, size: 16)),
        ...List.generate(5 - rating, (i) => const Icon(Icons.star_border, color: Colors.amber, size: 16)),
      ],
    );
  }
}
