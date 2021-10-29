import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import '../providers/places_provider.dart';
import '../listadoActividades.dart';
import '../widgets/actitivie_item.dart';
import '../widgets/places_item.dart';
import '../screens/edit_detail_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  var _isInit = true;
  var _isLoading = false;

  
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading=true;
      });
      Provider.of<Places>(context).fetchAndSetPlaces().then((_) {
      _isLoading=false;
      });
      _isInit = false;

    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading? Center(child: CircularProgressIndicator(),) : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.02,
              ),
              titleWidget(),
              CarrouselPlaces(),
              ActivitiesTitleWidget(),
              ActivitiesListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivitiesTitleWidget extends StatelessWidget {
  const ActivitiesTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.04,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividades',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
    );
  }
}

class ActivitiesListWidget extends StatelessWidget {
  const ActivitiesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.30,
      child: ListView(
        children: LISTADO_Actividades.map((activitie) => Activities(
              name: activitie.name,
              time: activitie.time,
              price: activitie.price,
              img: activitie.img,
            )).toList(),
      ),
    );
  }
}

class CarrouselPlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placesData = Provider.of<Places>(context);
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: placesData.places.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: placesData.places[i],
          child: PlacesItem(),
        ),
      ),
    );
    /* child: ListView(
        scrollDirection: Axis.horizontal,
        children: LISTADO_LUGARES
            .map((placesData) => PlacesItem(
                  id: placesData.id,
                  title: placesData.title,
                  description: placesData.description,
                  img: placesData.img,
                ))
            .toList(),
      ), */
  }
}

class titleWidget extends StatelessWidget {
  const titleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.1,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Guatemala',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            Text('Corazon del mundo maya', style: TextStyle(fontSize: 15)),
          ]),
          FittedBox(
              child: Row(
            children: [
              Text(
                'Añadir Lugar',
                style: TextStyle(fontSize: 13),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(PlacesDetailScreen.routeName)
                      .then((value) => {});
                },
                icon: Icon(Icons.add),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
