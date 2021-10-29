import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../providers/places.dart';
import '../providers/places_provider.dart';
import '../screens/edit_detail_screen.dart';

class PlacesItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final place = Provider.of<Place>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PlacesDetailScreen.routeName, arguments: place.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(
            image: NetworkImage(place.img),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Places>(context, listen: false)
                          .deletePlace(place.id);
                    } catch (e) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text(
                          'No se pudo eliminar!',
                          textAlign: TextAlign.center,
                        ),
                      ));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.white),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        backgroundColor: Colors.black54),
                  ),
                  Text(
                    place.description,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        decorationColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black54),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
