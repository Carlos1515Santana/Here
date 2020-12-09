import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/ocorrencia.dart';
import 'dart:convert';
import 'package:here/pages/dashboard_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/pages/ocorrencia_page.dart';
import 'package:here/utils/nav.dart';
import 'package:intl/intl.dart';
import '../model/locations.dart' as locations;
import '../utils/mapsUtils.dart';
import 'package:location/location.dart' as loca;
import 'package:search_map_place/search_map_place.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:here/widgets/PageRouteAnimation.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  final Map<String, Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor pinLocationIcon;
  var interador = 0;
  bool _visible = false;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;

  String searchAddr;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-23.5489, -46.638823),
    zoom: 1.4746,
  );

  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
//    setCustomMapPin(2);
  }

  void setCustomMapPin(valueImg, type) async {
    var img = '';
    switch (valueImg) {
      case 0:
        img = 'blue' + type;
        break;
      case 1:
        img = 'thief' + type;
        break;
      case 2:
        img = 'roubo' + type;
        break;
    }
    print('assets/' + img + '.png');
    print('assets/' + img + '.png');
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.7), 'assets/' + img + '.png');
  }

  void _startTracking() {
    final geolocator = Geolocator();
    final locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 2);

    _positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((_onLocationUpdate));
  }

  void _onLocationUpdate(Position position) {
    if (position != null) {
      print(
          "posição latitude: ${position.latitude}; longetude: ${position.longitude}");
      //tentativa de alterar a posição inicial do maps
      _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 1.4746,
      );
    }
  }

  @override
  void dispose() {
    if (_positionStream != null) {
      _positionStream.cancel();
      _positionStream = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(appBar: _appBar(), body: Container(child: _body())),
      );

  AppBar _appBar() {
    return AppBar(
        title: const Text('Maps'),
        backgroundColor: Color(0XFF3F51b5),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              this.searchandNavigate();
            },
          ),
          IconButton(
            icon: Icon(Icons.wysiwyg),
            onPressed: () {
              setState(() {
                _visible = !_visible;
                // _visible ? _onMapUpdate(0) : '';
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {
              Navigator.push(
                  context, PageRouteAnimation(widget: DashboardPage()));
            },
          ),
        ]);
  }

  Stack _body() {
    return Stack(children: <Widget>[
      _buildGoogleMaps(),
      Positioned(
        top: 80.0,
        right: 15.0,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Column(children: <Widget>[
            SizedBox(height: 16.0),
            _buttonFindMyLocal(),
            // _buttonSetMap()
          ]),
        ),
      ),
      AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 400),
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FlatButton.icon(
                    icon: const Icon(Icons.circle),
                    label: const Text(
                      '3 meses',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.red,
                    onPressed: () {
                      _onMapUpdate(1);
                    }),
              ),
              Expanded(
                child: FlatButton.icon(
                    icon: const Icon(Icons.circle),
                    label: const Text(
                      'Este mês',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.blueAccent,
                    onPressed: () {
                      _onMapUpdate(2);
                    }),
              ),
              Expanded(
                child: FlatButton.icon(
                    icon: const Icon(Icons.circle),
                    label: const Text(
                      'Tudo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    textColor: Colors.green,
                    onPressed: () {
                      _onMapUpdate(3);
                    }),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    this.controller = controller;
    await controller.setMapStyle(jsonEncode(mapStyle));
    _controller.complete(controller);
    final List<Ocorrencia> ocorrenciaList =
        await OcorrenciaAPI.getOcorencia("");

    setState(() {
      _markers.clear();
      if (ocorrenciaList != null) {
        _getOcorrrencia(ocorrenciaList);
      }
    });
  }

  Future<void> _onMapUpdate(int tipo) async {
    //    _controller.complete(controller);
    final List<Ocorrencia> ocorrenciaList =
        await OcorrenciaAPI.getOcorencia(tipo == 2
            ? "este_mes"
            : tipo == 1
                ? "3_meses"
                : tipo == 3
                    ? ""
                    : "");

    print(tipo);
    print(tipo);

    setState(() {
      _markers.clear();
      if (ocorrenciaList != null) {
        _getOcorrrencia(ocorrenciaList);
      }
    });
  }

  // _validateDataYear(DateTime dt) {
  //   return dt.year == DateTime.now().year;
  // }

  // _validateDataMonth(DateTime dt) {
  //   if (dt.year - DateTime.now().year == 1 ||
  //       dt.year - DateTime.now().year == 0) {
  //     var month = DateTime.now().month - dt.month;
  //     return dt.month - 3 >= month;
  //   } else {
  //     return false;
  //   }
  // }

  // _validateData6Month(DateTime dt) {
  //   if (dt.year - DateTime.now().year == 1 ||
  //       dt.year - DateTime.now().year == 0) {
  //     var month = DateTime.now().month - dt.month;
  //     return dt.month - 6 >= month;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> _getOcorrrencia(List<Ocorrencia> ocorrenciaList) async {
    for (final ocorencia in ocorrenciaList) {
      await setCustomMapPin(
          ocorencia.occurrence_type == 'Roubo' ? 2 : 1, ocorencia.type);

      final marker = Marker(
        markerId: MarkerId(ocorencia.description),
        position: LatLng(ocorencia.latitude, ocorencia.longitude),
        icon: pinLocationIcon,
        infoWindow: InfoWindow(
          title: ocorencia.occurrence_type,
          snippet: ocorencia.description,
        ),
      );
      _markers[ocorencia.description] = marker;
    }
  }

  Widget _buildGoogleMaps() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: _currentMapType,
      onMapCreated: _onMapCreated,
      onTap: (LatLng p) {
        _onTap(p);
      },
      markers: Set.of(_markers.values),
      initialCameraPosition: _kGooglePlex,
      // markers: _markers.values.toSet(),
    );
  }

  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = new GoogleMapsPlaces(
        apiKey:
            "AIzaSyBEe-EjMOAIqv28XeyVpzdybTBnNMxvWY4"); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = prediction.description;

    var camera = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 25.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(camera));
  }

  searchandNavigate() async {
    print(searchAddr);
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyBEe-EjMOAIqv28XeyVpzdybTBnNMxvWY4",
        mode: Mode.overlay, // Mode.overlay
        language: "br",
        components: [Component(Component.country, "br")]);
    this._getLatLng(prediction);
  }

  void _onTap(LatLng p) async {
    var resposta = await Navigator.push(
        context, PageRouteAnimation(widget: OcorrenciaPage(p)));
    this._onMapUpdate(0);
    print(resposta);
  }

  // button find my local
  FloatingActionButton _buttonFindMyLocal() {
    return FloatingActionButton(
      child: Icon(Icons.my_location, size: 25.0, color: Colors.blue),
      onPressed: _currentLocation,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
    );
  }

  Future<void> _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    loca.LocationData currentLocation;
    var location = loca.Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }
}
