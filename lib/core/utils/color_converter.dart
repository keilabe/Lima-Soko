import 'package:flutter/material.dart';

Color getColorFromString(String colorString) {
  switch (colorString.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'brown':
      return Colors.brown;
    default:
      return Colors.grey;
  }
} 