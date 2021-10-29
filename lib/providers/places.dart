import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Place with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String img;

  Place({required this.id, required this.title, required this.description, required this.img});

}
