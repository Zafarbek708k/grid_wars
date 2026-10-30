import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16, this.spacing = 4});

  final int rating;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children: [
        ...List.generate(rating, (i) => Icon(Icons.star, color: Colors.amber, size: size)),
        ...List.generate(5 - rating, (i) => Icon(Icons.star_border, color: Colors.amber, size: size)),
      ],
    );
  }
}
