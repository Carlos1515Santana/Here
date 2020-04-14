import 'package:flutter/material.dart';
import 'package:here/pages/dashboard_page.dart';


class HomePage extends StatelessWidget {
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
