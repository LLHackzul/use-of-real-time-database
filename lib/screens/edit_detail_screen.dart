import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import '../providers/places.dart';

class PlacesDetailScreen extends StatefulWidget {
  static const routeName = '/edit-place';

  @override
  State<PlacesDetailScreen> createState() => _PlacesDetailScreenState();
}

class _PlacesDetailScreenState extends State<PlacesDetailScreen> {
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedPlace = Place(
    id: '',
    title: '',
    description: '',
    img: '',
  );
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'img': '',
  };
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);

    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImage);
    _imageController.dispose();
    _imageFocusNode.dispose();

    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageController.text.isEmpty) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedPlace.id != '') {
      await Provider.of<Places>(context, listen: false)
          .updatePlace(_editedPlace.id, _editedPlace);
    } else {
      try {
        await Provider.of<Places>(context, listen: false)
            .addPlace(_editedPlace);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Ocurrio un error!',
                  ),
                  content: Text('Algo ocurrió mal :('),
                  actions: [
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      } /*  finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } */
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final placeId = ModalRoute.of(context)!.settings.arguments;
      if (placeId != null) {
        final place = Provider.of<Places>(context, listen: false)
            .findById(placeId as String);
        _editedPlace = place;
        _initValues = {
          'title': _editedPlace.title,
          'description': _editedPlace.description,
          /* 'imageUrl': _editedProduct.imageUrl, */
          'img': '',
        };
        _imageController.text = _editedPlace.img;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Titulo',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedPlace = Place(
                          title: value as String,
                          description: _editedPlace.description,
                          img: _editedPlace.img,
                          id: _editedPlace.id,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Porfavor ingrese un valor';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Descripcion',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedPlace = Place(
                          title: _editedPlace.title,
                          description: value as String,
                          img: _editedPlace.img,
                          id: _editedPlace.id,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Porfavor ingrese un valor';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 25,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageController.text.isEmpty
                              ? Text('Ingresa una URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageController.text,
                                    width: 5,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Url de la Imagen'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {},
                            onSaved: (value) {
                              _editedPlace = Place(
                                title: _editedPlace.title,
                                description: _editedPlace.description,
                                img: value as String,
                                id: _editedPlace.id,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Porfavor ingrese una imagen';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
