import 'package:flutter/material.dart';
import './places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Places with ChangeNotifier {
  List<Place> _placesList = [
    /* Place(
      id: "L1",
      title: "Tikal",
      description: "Civilizacion maya, en su máxima expresion",
      img:
          'https://firebasestorage.googleapis.com/v0/b/example-89004.appspot.com/o/Tikal.jpeg?alt=media&token=f1680d67-0698-4ff7-bf1c-0550f8f764c0',
    ),
    Place(
      id: "L2",
      title: "Atitlán",
      description: "El lago más hermoso del mundo",
      img:
          'https://firebasestorage.googleapis.com/v0/b/example-89004.appspot.com/o/Atitlan.jpeg?alt=media&token=05ee0413-d7c4-4c9a-ab8d-815c614cd61b',
    ),
    Place(
      id: "L3",
      title: "Semuc",
      description: "Un paraíso natual en medio del bosque",
      img:
          'https://firebasestorage.googleapis.com/v0/b/example-89004.appspot.com/o/Semuc.jpeg?alt=media&token=0d1cec8b-7992-4e20-9bdc-c07f3ee244b1',
    ),
    Place(
      id: "L4",
      title: "Xela",
      description: "La cuna de la cultura y de los mejores ingenieros",
      img:
          'https://firebasestorage.googleapis.com/v0/b/example-89004.appspot.com/o/Xela.jpeg?alt=media&token=d1f27db5-e395-454f-97c3-6501b2f44bb1',
    ), */
  ];

  List<Place> get places {
    return [..._placesList];
  }

  Place findById(String id) {
    return _placesList.firstWhere((place) => place.id == id);
  }

  Future<void> fetchAndSetPlaces() async {
    final url = Uri.parse(
        'https://example-89004-default-rtdb.firebaseio.com/places.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Place> loadedPlaces = [];
      extractedData.forEach((placeId, placeData) {
        loadedPlaces.add(Place(
          id: placeId,
          title: placeData['title'],
          description: placeData['description'],
          img: placeData['img'],
        ));
      });
      _placesList = loadedPlaces;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addPlace(Place place) async {
    final url = Uri.parse(
        'https://example-89004-default-rtdb.firebaseio.com/places.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': place.title,
          'description': place.description,
          'img': place.img,
        }),
      );

      final newPlace = Place(
          id: json.decode(response.body)['name'],
          title: place.title,
          description: place.description,
          img: place.img);
      _placesList.add(newPlace);
      notifyListeners();
    } catch (e) {
     
      throw e;
    }
  }

  Future<void> updatePlace(String id, Place newPlace) async {
    final placeIndex = _placesList.indexWhere((place) => place.id == id);
    if (placeIndex >= 0) {
      final url = Uri.parse(
          'https://example-89004-default-rtdb.firebaseio.com/places/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newPlace.title,
            'description': newPlace.description,
            'img': newPlace.img,
          }));
      _placesList[placeIndex] = newPlace;
      notifyListeners();
    }
  }

  Future<void> deletePlace(String id) async {
    final url = Uri.parse(
        'https://example-89004-default-rtdb.firebaseio.com/places/$id.json');
    final existingPlaceIndex =
        _placesList.indexWhere((place) => place.id == id);
    Place? existingPlace = _placesList[existingPlaceIndex];
    _placesList.removeAt(existingPlaceIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _placesList.insert(existingPlaceIndex, existingPlace);
      notifyListeners();
      throw HttpException('No se pudo eliminar el lugar');
    }

    existingPlace = null;
  }
}
