import 'package:flutter/material.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/oco.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new ListOcorrencia());

class ListOcorrencia extends StatefulWidget {
  @override
  _ListOcorrenciaState createState() => _ListOcorrenciaState();
}

class _ListOcorrenciaState extends State<ListOcorrencia> {
  final String url =
      "https://help-api.herokuapp.com/api/Occurrence/GetAllOccurrence";

  List<OcorrenciaList> myAllData = [];

  @override
  void initState() {
    loadData();
  }

  loadData() async {
    var response = await http.get(Uri.encodeFull(url), headers: {"Aceept": "application/json"});
    if (response.statusCode == 200) {
      //var oc = OcorrenciaAPI.getOcorencia();
      //print(oc);
      String responeBody = response.body;
      var jsonBody = json.decode(responeBody);
      for (var data in jsonBody) {
         
                myAllData.add(OcorrenciaList(
                    data['occurrence_type'],data['customer']['name'],data['longitude'],data['latitude'],data['description'],data['address']['name_street'],data['date'],data['image'] ));
            //print(data['customer']['name']);
            //data['location']['street']['name'], data['email'], data['registered']['date'],data["picture"]["thumbnail"]));
      }
      setState(() {});
      myAllData.forEach((someData) => print("Name : ${someData.usuario}"));
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new AppBar(
        bottom: TabBar(
              tabs: [
                Tab(text: "Todas Ocorrencias",icon: Icon(Icons.directions_car)),
                Tab(text: "Minhas Ocorrencias",icon: Icon(Icons.directions_transit)),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
        title: new Text('Ocorrencias'),
        centerTitle: true,
        backgroundColor:  Colors.blue[700],
      ),
      backgroundColor: Colors.blue[100],
      body: TabBarView(
            children: [ myAllData.length == 0 ? new Center(
              child: new CircularProgressIndicator(),
            )
          : showMyUI(),

          Center(child: Text("Em manutenção!", 
             style: TextStyle(fontSize: 30),
          ))
          
            ],
      ),
    ),
    ),
    );
  }

  Widget showMyUI() {
    return new ListView.builder(
        itemCount: myAllData.length,
        itemBuilder: (_, index) {
          return new Container(
            
            margin: new EdgeInsets.symmetric(vertical: 2.0,horizontal: 8.0),
            child: new Card(
              elevation: 10.0,
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SecondPage(myAllData[index])));
                },
              child: Container(
                padding: new EdgeInsets.all(12.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Container(
                       decoration: new BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'), 
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Roubo",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    )
                  ],
                    ),
                  ),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Ocorrencia : ${myAllData[index].tipo_correncia}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Usuario : ${myAllData[index].usuario}'),
                    //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    //new Text('Tipo : ${myAllData[index].longitude}'),
                    //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    //new Text('Endereço : ${myAllData[index].latitude}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Descrição : ${myAllData[index].descricao}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Endereço : ${myAllData[index].endereco}'),
                    new Text('Data : ${myAllData[index].data}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    Image.network('${myAllData[index].image}', fit: BoxFit.cover, width: 300),
                    //new Image.memory('${myAllData[index].image}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                  ],
                ),
              ),
            ),
            ),
          );
        });
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text('Detalhes da Ocorrencia')),
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (_, index) {
          return new Container(
            
            margin: new EdgeInsets.symmetric(vertical: 2.0,horizontal: 8.0),
            child: new Card(
              elevation: 10.0,
              child: new InkWell(
                
              child: Container(
                padding: new EdgeInsets.all(12.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('BO : ${data.occurrence_type}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Tipo : ${data.customer}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Longitude : ${data.longitude}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Latitude : ${data.latitude}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Descrição : ${data.description}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Endereço : ${data.address}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    new Text('Data : ${data.date}'),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    Image.network('${data.image}', fit: BoxFit.cover, width: 300),
                    new Padding(padding: new EdgeInsets.symmetric(vertical: 1.0)),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Agravantes:",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    ),
                    Container(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'), 
                    )
                  ],
                    ),
                  ),
                  ],
                ),
              ),
            ),
            ),
          );
        })
      );
}

