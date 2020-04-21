import 'package:flutter/material.dart';
import 'package:here/pages/dashboard_page.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/locations.dart' as locations;

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Here!")),
      ),
      body: _body(context),
    );
  }

  _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              //Container(height: 100, color: Colors.red),
              Container(
                height: 500,
                child: Center(
                  child: Text(
                    "Carlinhos",
                    style: TextStyle(fontSize: 33),
                  ),
                ),
              ),
              //Container(height: 200, color: Colors.green),
            ],
          )),
        ),
        Container(
            height: 100,
            //color: Colors.orange,
            child: Center(
                child: RaisedButton(
              child: Text('Ir para Dashboard'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            )))
      ],
    );
  }
}

class _MyAppState extends State<HomePage> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }
 @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
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
            ]
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(0, 0),
              zoom: 2,
            ),
            markers: _markers.values.toSet(),
          ),
        ),
      );
}
