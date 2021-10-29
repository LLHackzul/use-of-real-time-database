import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/places_provider.dart';
import './screens/places_screen.dart';
import './screens/edit_detail_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Places(),
        ),
      ],
      child: MaterialApp(
        title: 'Segundo parcial',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white.withOpacity(1),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: PlacesScreen(),
        routes: {
          PlacesDetailScreen.routeName: (ctx)=> PlacesDetailScreen(),
        },
      ),
    );
  }
}


