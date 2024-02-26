import 'package:firebase_database/firebase_database.dart';

// Define a data model for slider data
class SliderData {
  final String country;
  final String category;

  SliderData({required this.country, required this.category});

  // Convert SliderData object to a map
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'category': category,
    };
  }

  // Create SliderData object from a map
  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      country: json['country'],
      category: json['category'],
    );
  }
}
