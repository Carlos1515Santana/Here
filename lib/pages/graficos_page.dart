import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'myflexiableappbar.dart';
import 'myappbar.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


class GraficosPage extends StatefulWidget {
  @override
  _GraficosPageState createState() => _GraficosPageState();
}

class _GraficosPageState extends State<GraficosPage> {
  List<double> data1 = [1.0, 1.1, 1.0, 1.2, 1.3, 1.3, 1.3, 1.3];
  List<double> data2 = [0.8, 0.7, 1.0, 0.9, 0.2, 1.3, 1.6, 0.8, 0.3, 0.0];
  List<double> data3 = [1.0, 1.1, 1.0, 0.9, 1.2, 1.2, 1.3, 1.4];
  List<double> data4 = [0.4,0.5,0.6,1.0,1.0,0.9,0.6,0.5];
  List<double> data5 = [1.0, 1.1, 1.0, 0.9, 1.2, 1.3, 0.8,1,2];
  List<double> data6 = [0.8,0.9,0.7,0.6,0.8,0.9];
  List<double> data7 = [0.2,0.3,0.6,1.0,0.6,0.3,0.2];
  List<double> data8 = [1.0,1.1,1.2,1.3,1.4,1.2,1.3];
  List<double> data9 = [1.0, 1.1, 1.0, 0.9, 1.2, 1.3, 1.0, 0.8, 1.3, 1.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: MyAppBar(),
              pinned: true,
              expandedHeight: 210.0,
              flexibleSpace: FlexibleSpaceBar(
                background: MyFlexiableAppBar(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  myCardDetails(
                      "", "São Paulo", data1, "4702", "3.0", "\u2191", 0xff07862b),
                  myCardDetails(
                      "", "Rio de Janeiro", data2, "3802", "4.0", "\u2193", 0xffff0000),
                  myCardDetails(
                      "", "Bahia", data3, "7702", "5.0", "\u2191", 0xff07862b),
                  myCardDetails(
                      "", "Minas Gerais", data7, "4702", "3.0", "\u2193", 0xffff0000),

                  myCardDetails(
                      "", "Paraná", data5, "8600", "2.0", "\u2191", 0xff07862b),
                  myCardDetails(
                      "", "Goias", data6, "4702", "2.5", "\u2191", 0xff07862b),
                  myCardDetails(
                      "", "Piaui", data4, "2345", "2.0", "\u2193", 0xffff0000),
                  myCardDetails(
                      "", "Pará", data8, "3800", "2.5", "\u2191", 0xffff0000),
                  myCardDetails(
                      "", "Amazonas", data9, "2000", "3.0", "\u2193", 0xffff0000),

                ],
              ),
            ),
          ],
        )
    );
  }

}

Widget myCardDetails(String imageVal, String currencyName, List<double> data,
    String currencyVal, String currencyPercentage, String currencyStatus,
    int colorVal) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.blue[700],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: myCurrencies(
            imageVal,
            currencyName,
            data,
            currencyVal,
            currencyPercentage,
            currencyStatus,
            colorVal),
      ),
    ),
  );
}

Center myCurrencies(String imageVal, String currencyName, List<double> data,
    String currencyVal, String currencyPercentage, String currencyStatus,
    int colorVal) {
  return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              myLeadingDetails(imageVal, currencyName),
              myGraphDetails(data),
              myCurrenciesDetails(
                  currencyVal, currencyPercentage, currencyStatus, colorVal),
            ],)
        ],)
  );
}


Widget myLeadingDetails(String imageVal, String currencyName) {
  return Container(
      child: Row(children: <Widget>[
        Container(child: Image(
          height:50.0,
          image:AssetImage(imageVal),
        ),),
        SizedBox(width: 10.0,),
        Container(child: Text(
          currencyName, style: TextStyle(
            color: Colors.blue[700],
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16.0
        ),),),
      ],)
  );
}

Widget myGraphDetails(List<double> data) {
  return Container(
    width: 80.0,
    height: 50.0,
    child: Sparkline(
      data: data,
      lineColor: Colors.blue[700],
      fillMode: FillMode.below,
      fillColor: Colors.blue[100],
    ),
  );
}

Widget myCurrenciesDetails(String currencyVal, String currencyPercentage,
    String currencyStatus, int colorVal) {
  return Container(child: Column(
    children: <Widget>[
      Container(child: Text(
          //"\u0024" + currencyVal,
          'Qtde OC: '+ currencyVal,
          style: TextStyle(
              color: Colors.blue[700],
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              fontSize: 20.0
          )
      ),),
      Container(child: Text(
          currencyPercentage + "\u0025\u0020" + currencyStatus,
          style: TextStyle(
            color: Color(colorVal),
            fontFamily: 'Poppins',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          )
      ),),
    ],
  ));
}