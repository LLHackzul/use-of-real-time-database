import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Activities extends StatelessWidget {
  const Activities({
    Key? key,
    required this.name,
    required this.time,
    required this.price,
    required this.img,
  }) : super(key: key);
  final String name;
  final String time;
  final String price;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 300,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: ExactAssetImage(img),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 200,
            child: Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
          ),
          SizedBox(
            width: 90,
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Text(time,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              SizedBox(height: 5),
              Text(price,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ],
          ),
        ],
      ),
    );
  }
}
