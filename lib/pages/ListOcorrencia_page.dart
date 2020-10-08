import 'package:flutter/material.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/oco.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:here/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'num_emergencia.dart';

void main() => runApp(new ListOcorrencia());

class ListOcorrencia extends StatefulWidget {
  @override
  _ListOcorrenciaState createState() => _ListOcorrenciaState();
}

class _ListOcorrenciaState extends State<ListOcorrencia> {
  final String url =
      "https://help-api.herokuapp.com/api/Occurrence/GetAllOccurrence";

  final String urlMinhaOc =
      "https://help-api.herokuapp.com/api/Occurrence/OcurrenceByIdUser";

  List<OcorrenciaList> myAllData = [];
  List<OcorrenciaList> myAllDataOC = [];

  @override
  void initState() {
    loadData();
    loadData2();
  }

  loadData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Aceept": "application/json"});
    if (response.statusCode == 200) {
      //var oc = OcorrenciaAPI.getOcorencia();
      //print(oc);
      String responeBody = response.body;
      var jsonBody = json.decode(responeBody);
      for (var data in jsonBody) {
        myAllData.add(OcorrenciaList(
            data['occurrence_type'],
            data['customer']['name'],
            data['longitude'],
            data['latitude'],
            data['description'],
            data['address']['name_street'],
            data['date'],
            data['image']));
      }
      setState(() {});
      //myAllData.forEach((someData) => print("Name : ${someData.usuario}"));
    } else {
      print('Algo deu errado');
    }
  }

  loadData2() async {
    var response = await http.get(Uri.encodeFull(urlMinhaOc),
        headers: {"Aceept": "application/json"});
    if (response.statusCode == 200) {
      //var oc = OcorrenciaAPI.getOcorencia();
      //print(oc);
      String responeBody = response.body;
      var jsonBody = json.decode(responeBody);
      for (var data in jsonBody) {
        myAllDataOC.add(OcorrenciaList(
            data['occurrence_type'],
            data['customer']['name'],
            data['longitude'],
            data['latitude'],
            data['description'],
            data['address']['name_street'],
            data['date'],
            data['image']));
      }
      setState(() {});
      myAllDataOC.forEach((someData) => print("Name : ${someData.usuario}"));
    } else {
      print('Algo deu errado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    text: "Todas as Ocorrências",
                    icon: Icon(Icons.format_list_bulleted)),
                Tab(text: "Minhas Ocorrências", icon: Icon(Icons.backup)),
                Tab(text: "Contatos de Emergencia", icon: Icon(Icons.call)),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('Ocorrências'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
          ),
          backgroundColor: Colors.blue[100],
          body: TabBarView(
            children: [
              myAllData.length == 0
                  ? new Center(
                      child: CircularProgressIndicator(),
                    )
                  : showMyUI(),
              myAllDataOC.length == 0
                  ? new Center(child: Text('Não Existe Ocorrencia!'))
                  : minhasOco(),
              Column(
                children: emergencyHelpList.map((eHL) {
                  return Card(
                    child: ListTile(
                      title: Text(eHL.title),
                      leading: Icon(Icons.call),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () => UrlLauncher.launch('tel:${eHL.number}'),
                      //onTap: _launchURL(),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<EmergencyHelpLineList> emergencyHelpList = [
    EmergencyHelpLineList(
      title: 'Policia',
      number: '190',
    ),
    EmergencyHelpLineList(
      title: 'Ambulância',
      number: '192',
    ),
    EmergencyHelpLineList(
      title: 'Corpo de Bombeiros',
      number: '193',
    ),
    EmergencyHelpLineList(
      title: 'Secretaria dos Direitos Humanos',
      number: '100',
    ),
    EmergencyHelpLineList(
      title: 'Polícia Federal',
      number: '194',
    ),
    EmergencyHelpLineList(
      title: 'Polícia Rodoviária Estadual',
      number: '198',
    ),
  ];

  Widget showMyUI() {
    var formatter = new DateFormat('yyyy-MM-dd');
    return ListView.builder(
        itemCount: myAllData.length,
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SecondPage(myAllData[index])));
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Ocorrência",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Ocorrência: ${myAllData[index].tipo_correncia}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Usuário: ${myAllData[index].usuario}'),
                      //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      //new Text('Tipo : ${myAllData[index].longitude}'),
                      //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      //new Text('Endereço : ${myAllData[index].latitude}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Descrição: ${myAllData[index].descricao}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Endereço: ${myAllData[index].endereco}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Data:' +
                          DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(
                              DateTime.parse(myAllData[index].data).toUtc())),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Image.network('${myAllData[index].image}',
                          fit: BoxFit.cover, width: 300),
                      //new Image.memory('${myAllData[index].image}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget minhasOco() {
    var formatter = new DateFormat('yyyy-MM-dd');
    return ListView.builder(
        itemCount: myAllDataOC.length,
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Card(
              elevation: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SecondPage(myAllDataOC[index])));
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Ocorrência",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Ocorrência: ${myAllDataOC[index].tipo_correncia}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Usuário: ${myAllDataOC[index].usuario}'),
                      //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      //new Text('Tipo : ${myAllData[index].longitude}'),
                      //new Padding(padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      //new Text('Endereço : ${myAllData[index].latitude}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Descrição: ${myAllDataOC[index].descricao}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Endereço: ${myAllData[index].endereco}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Text('Data:' +
                          DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(
                              DateTime.parse(myAllDataOC[index].data).toUtc())),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                      Image.network('${myAllDataOC[index].image}',
                          fit: BoxFit.cover, width: 300),
                      //new Image.memory('${myAllData[index].image}'),
                      Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
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
  var formatter = new DateFormat('yyyy-MM-dd');
  final data;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Detalhes da Ocorrência')),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (_, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              child: Card(
                elevation: 10.0,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('BO: ${data.tipo_correncia}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Usuario: ${data.usuario}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Longitude: ${data.longitude}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Latitude: ${data.latitude}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Descrição: ${data.descricao}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Endereço: ${data.endereco}'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Text('Data:' +
                            DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                                .format(DateTime.parse(data.data).toUtc())),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Image.network('${data.image}',
                            fit: BoxFit.cover, width: 300),
                        Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            'Agravantes:',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://comps.canstockphoto.com.br/assalto-%C3%ADcone-ilustra%C3%A7%C3%A3o_csp45736522.jpg'),
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
          }));
}
