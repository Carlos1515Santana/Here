import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'dart:convert';
import 'package:here/pages/dashboard_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/pages/ocorrencia_page.dart';
import 'package:here/utils/nav.dart';
import '../model/locations.dart' as locations;
import '../utils/mapsUtils.dart';
import 'package:location/location.dart' as loca;
import 'package:search_map_place/search_map_place.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Center(child: Text("Here!")),
  //     ),
  //     body: _body(context),
  //   );
  // }
}

class _MyAppState extends State<HomePage> {
  final Map<String, Marker> _markers = {};
  // Map<MarkerId, Marker> _markers = Map();
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor pinLocationIcon;
  var interador = 0;

  Completer<GoogleMapController> _controller = Completer();

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
        img = 'furto';
        break;
      case 2:
        img = 'roubo';
        break;
    }
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'assets/' + img + '.png');
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
    await controller.setMapStyle(jsonEncode(mapStyle));
    _controller.complete(controller);

//    final googleOffices = await locations.getGoogleOffices();
    final ocorrenciaList = await OcorrenciaAPI.getOcorencia();

    setState(() {
      _markers.clear();
      if (ocorrenciaList != null) {
        _getOcorrrencia(Post.toList(ocorrenciaList));
      }
//      if (googleOffices != null) {
//        _getMakerGeneric(googleOffices);
//      }
    });
}
  Future<void> _findOcorrencia() async {
    final ocorrenciaList = await OcorrenciaAPI.getOcorencia();
    if (ocorrenciaList != null) {
      _getOcorrrencia(Post.toList(ocorrenciaList));
    }
  }


  Future<void> _getOcorrrencia(List<Post> ocorrenciaList) async {
    for (final ocorencia in ocorrenciaList) {

       await setCustomMapPin(ocorencia.tipo_ocorrencia == 'ROU'? 2 : 1 );

      final marker = Marker(
        markerId: MarkerId(ocorencia.descricao),
        position: LatLng(ocorencia.latitude, ocorencia.longitude),
        icon: pinLocationIcon,
        infoWindow: InfoWindow(
          title: ocorencia.tipo_ocorrencia,
          snippet: ocorencia.descricao,
        ),
      );
      _markers[ocorencia.descricao] = marker;
    }
  }

  void _getMakerGeneric(googleOffices) {
    for (final office in googleOffices.offices) {
      final marker = Marker(
        markerId: MarkerId(office.name),
        position: LatLng(office.lat, office.lng),
        icon: pinLocationIcon,
        infoWindow: InfoWindow(
          title: office.name,
          snippet: office.address,
        ),
      );
      _markers[office.name] = marker;
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
        context, MaterialPageRoute(builder: (context) => OcorrenciaPage(p)));
    push(context, HomePage());

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
        backgroundColor: Colors.blue[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
        ]);
  }


}
