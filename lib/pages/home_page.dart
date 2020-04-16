import 'package:flutter/material.dart';
import 'package:here/pages/dashboard_page.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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
            child: Center(child: RaisedButton(
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
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}