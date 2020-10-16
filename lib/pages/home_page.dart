import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/ocorrencia.dart';
import 'dart:convert';
import 'package:here/pages/dashboard_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/pages/ocorrencia_page.dart';
import 'package:here/utils/nav.dart';
import '../model/locations.dart' as locations;
import '../utils/mapsUtils.dart';
import 'package:location/location.dart' as loca;
import 'package:search_map_place/search_map_place.dart';
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

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;

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

  void setCustomMapPin(valueImg) async {
    var img = '';
    switch (valueImg) {
      case 0:
        img = 'blue';
        break;
      case 1:
        img = 'thief-old';
        break;
      case 2:
        img = 'roubo';
        break;
    }
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 101.1), 'assets/' + img + '.png');
  }

  void _startTracking() {
    final geolocator = Geolocator();
    final locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);

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
        home: Scaffold(appBar: _appBar(), body: _body()),
      );

  Future<void> _onMapCreated(GoogleMapController controller) async {
    this.controller = controller;
    await controller.setMapStyle(jsonEncode(mapStyle));
    _controller.complete(controller);
    final List<Ocorrencia> ocorrenciaList = await OcorrenciaAPI.getOcorenciaMaps();

    setState(() {
      _markers.clear();
      if (ocorrenciaList != null) {
        _getOcorrrencia(ocorrenciaList);
      }
    });
}

  Future<void> _onMapUpdate() async{
  //    _controller.complete(controller);
      final List<Ocorrencia> ocorrenciaList = await OcorrenciaAPI.getOcorenciaMaps();

      setState(() {
        _markers.clear();
        if (ocorrenciaList != null) {
          _getOcorrrencia(ocorrenciaList);
        }
      });
  }

  Future<void> _getOcorrrencia( List<Ocorrencia> ocorrenciaList) async {
    for (final ocorencia in ocorrenciaList) {

       await setCustomMapPin(ocorencia.occurrence_type == 'Roubo'? 2 : 1 );

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

  Stack _body() {
    return Stack(children: <Widget>[
      _buildGoogleMaps(),
      // _searchMapPlaceWidget(),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(children: <Widget>[
              SizedBox(height: 16.0),
              _buttonFindMyLocal(),
              // _buttonSetMap()
            ]),
          ))
    ]);
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


  void _onTap(LatLng p) async {
    var resposta = await Navigator.push(
        //context, MaterialPageRoute(builder: (context) => OcorrenciaPage(p)));
      context, PageRouteAnimation(widget: OcorrenciaPage(p)));
//    push(context, HomePage());
    this._onMapUpdate();
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

  AppBar _appBar() {
    return AppBar(
        title: const Text('Maps'),
        backgroundColor: Color(0XFF3F51b5),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {
              Navigator.push(context, PageRouteAnimation(widget: DashboardPage()));
            },
          ),
        ]
    );
  }
}
