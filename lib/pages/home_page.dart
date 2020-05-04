import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'dart:convert';
import 'package:here/pages/dashboard_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/pages/ocorrencia_page.dart';
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
    setCustomMapPin(2);
  }

  void setCustomMapPin(valueImg) async {
    var img = '';
    switch (valueImg) {
      case 0:
        img = 'blue';
        break;
      case 1:
        img = 'thief-png sizeRed';
        break;
      case 2:
        img = 'thief-png-2 sizeRe';
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

    final googleOffices = await locations.getGoogleOffices();
    final ocorrenciaList = await OcorrenciaAPI.getOcorencia();

    setState(() {
      _markers.clear();
      if (ocorrenciaList != null) {
        _getOcorrrencia(ocorrenciaList);
      }
      if (googleOffices != null) {
        _getMakerGeneric(googleOffices);
      }
    });
  }

  void _getOcorrrencia(ocorrenciaList) {
    for (final ocorencia in ocorrenciaList) {
      setCustomMapPin(ocorrenciaList.ocorrencia == 'Assalto' ? 2 : 1);
      final marker = Marker(
        markerId: MarkerId(ocorencia.id),
        position: LatLng(ocorencia.latitude, ocorencia.longetude),
        icon: pinLocationIcon,
        infoWindow: InfoWindow(
          title: ocorencia.tipo_ocorrencia,
          snippet: ocorencia.descricao,
        ),
      );
      _markers[ocorencia.id] = marker;
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

    print(
        'Latitude: ${resposta.latitude}, tipo Ocorrencia: ${resposta.tipo_correncia}, data: ${resposta.data}, CEP: ${resposta.endereco.cep} DEscrição: ${resposta.descricao}');

    if (false) {
      if (resposta.tipo_correncia.isEmpty && resposta.descricao.isEmpty) {
        // setCustomMapPin(resposta.ocorrencia == 'Assalto' ? 2 : 1);

        final markerId = MarkerId("${_markers.length}");
        final infoWindow = InfoWindow(
            title: 'resposta.tipo_correncia',
            snippet: 'resposta.descricao',
            anchor: Offset(0.5, 0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OcorrenciaPage(p)),
              );
            });
        final marker = Marker(
          markerId: markerId,
          position: p,
          icon: pinLocationIcon,
          infoWindow: infoWindow,
          draggable: true,
        );
        setState(() {
          _markers["${_markers.length}"] = marker;
        });
      }
    }
  }

  // void _onMapTypeButtonPressed() {
  //   setState(() {
  //     _currentMapType = _currentMapType == MapType.normal
  //         ? MapType.satellite
  //         : MapType.normal;
  //   });
  // }

  // FloatingActionButton _buttonSetMap() {
  //   return FloatingActionButton(
  //     onPressed: _onMapTypeButtonPressed,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.green,
  //     child: const Icon(Icons.map, size: 36.0),
  //   );
  // }

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

  // SearchMapPlaceWidget _searchMapPlaceWidget() {
  //   return SearchMapPlaceWidget(
  //     apiKey: "AIzaSyBH9jPUi9Pez_HtbXkS1LANmZa-YFg5q6E",
  //     // The language of the autocompletion
  //     language: 'pt-BR',
  //     // The position used to give better recomendations. In this case we are using the user position
  //     location: LatLng(37.42796133580664, -122.085749655962),
  //     radius: 30000,
  //     onSelected: (Place place) async {
  //       final geolocation = await place.geolocation;
  //       print(geolocation);

  //       // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
  //       final GoogleMapController controller = await _controller.future;
  //       controller
  //           .animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
  //       controller
  //           .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
  //     },
  //   );
  // }
}
