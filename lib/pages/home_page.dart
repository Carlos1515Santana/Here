import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:here/pages/dashboard_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/locations.dart' as locations;

const mapStyle = [
  {
    "elementType": "geometry",
    "stylers": [
      {"color": "#1d2c4d"}
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#8ec3b9"}
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#1a3646"}
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#4b6878"}
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#64779e"}
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#4b6878"}
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#334e87"}
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {"color": "#023e58"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {"color": "#283d6a"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#6f9ba5"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#1d2c4d"}
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#023e58"}
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#3C7680"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {"color": "#304a7d"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#98a5be"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#1d2c4d"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {"color": "#2c6675"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#255763"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#b0d5ce"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#023e58"}
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#98a5be"}
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#1d2c4d"}
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#283d6a"}
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {"color": "#3a4762"}
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {"color": "#0e1626"}
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#4e6d70"}
    ]
  }
];
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
  // final Map<String, Marker> _markers = {};
  Map<MarkerId, Marker> _markers = Map();

  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
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
    controller.setMapStyle(jsonEncode(mapStyle));

    // final googleOffices = await locations.getGoogleOffices();
    // setState(() {
    //   _markers.clear();
    //   for (final office in googleOffices.offices) {
    //     final marker = Marker(
    //       markerId: MarkerId(office.name),
    //       position: LatLng(office.lat, office.lng),
    //       infoWindow: InfoWindow(
    //         title: office.name,
    //         snippet: office.address,
    //       ),
    //     );
    //     _markers[office.name] = marker;
    //   }
    // });
  }

  Container _body() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: <Widget>[
        _buildGoogleMaps(),
      ]),
    );
  }

  Widget _buildGoogleMaps() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: _onMapCreated,
      onTap: (LatLng p) {
        _onTap(p);
      },
      markers: Set.of(_markers.values),
      initialCameraPosition: _kGooglePlex,
      // markers: _markers.values.toSet(),
    );
  }

  void _onTap(LatLng p) {
    final markerId = MarkerId("${_markers.length}");
    final infoWindow = InfoWindow(
        title: "Ocorrencia Titulo",
        snippet: "Manoel ladrão de doce",
        anchor: Offset(0.5, 0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        });
    final marker = Marker(
      markerId: markerId,
      position: p,
      infoWindow: infoWindow,
    );
    setState(() {
      _markers[markerId] = marker;
    });
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
