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
  final String url = "https://help-api.herokuapp.com/api/Occurrence/GetAllOccurrence";

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
            data['occurrence_type'],data['customer']['name'],data['longitude'],
            data['latitude'],data['description'],data['address']['name_street'],
            data['date'],data['image'] ));
      }
      setState(() {});
      myAllData.forEach((someData) => print("Name : ${someData.usuario}"));
    } else {
      print('Algo deu errado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:  AppBar(
        bottom: TabBar(
              tabs: [
                Tab(text: "Todas as Ocorrências",icon: Icon(Icons.format_list_bulleted)),
                Tab(text: "Minhas Ocorrências",icon: Icon(Icons.format_list_bulleted)),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
        title:  Text('Ocorrências'),
        centerTitle: true,
        backgroundColor:  Colors.blueGrey,
      ),
      backgroundColor: Colors.blue[100],
      body: TabBarView(
            children: [ myAllData.length == 0 ? new Center(
              child:  CircularProgressIndicator(),
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
    return  ListView.builder(
        itemCount: myAllData.length,
        itemBuilder: (_, index) {
          return  Container(
            
            margin: EdgeInsets.symmetric(vertical: 2.0,horizontal: 8.0),
            child:  Card(
              elevation: 10.0,
              child:  InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                       MaterialPageRoute(
                          builder: (BuildContext context) =>
                               SecondPage(myAllData[index])));
                },
              child: Container(
                padding:  EdgeInsets.all(12.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Container(
                       decoration:  BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(12)),
                    padding:  EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage('https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'), 
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Ocorrência",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),),
                    )
                  ],
                    ),
                  ),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Ocorrência: ${myAllData[index].tipo_correncia}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Usuário: ${myAllData[index].usuario}'),
                    //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    //new Text('Tipo : ${myAllData[index].longitude}'),
                    //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    //new Text('Endereço : ${myAllData[index].latitude}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Descrição: ${myAllData[index].descricao}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Endereço: ${myAllData[index].endereco}'),
                     Text('Data: ${myAllData[index].data}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                    Image.network('${myAllData[index].image}', fit: BoxFit.cover, width: 300),
                    //new Image.memory('${myAllData[index].image}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
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
  Widget build(BuildContext context) =>  Scaffold(
      appBar:  AppBar(title:  Text('Detalhes da Ocorrência')),
      body:  ListView.builder(
        itemCount: 1,
        itemBuilder: (_, index) {
          return  Container(
            
            margin:  EdgeInsets.symmetric(vertical: 2.0,horizontal: 8.0),
            child:  Card(
              elevation: 10.0,
              child:  InkWell(
                
              child: Container(
                padding:  EdgeInsets.all(12.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('BO: ${data.tipo_correncia}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Usuario: ${data.usuario}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Longitude: ${data.longitude}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Latitude: ${data.latitude}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Descrição: ${data.descricao}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Endereço: ${data.endereco}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                     Text('Data: ${data.data}'),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 3.0)),
                    Image.network('${data.image}', fit: BoxFit.cover, width: 300),
                     Padding(padding:  EdgeInsets.symmetric(vertical: 1.0)),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('Agravantes:',
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

