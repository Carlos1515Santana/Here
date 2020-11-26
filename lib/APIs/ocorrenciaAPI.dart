import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:here/pages/graficosdash_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'api_response.dart';

class OcorrenciaAPI {
  static Future<ApiResponse<Ocorrencia>> postOcorrencia(
      Ocorrencia ocorrencia, File file) async {
    try {
      var url = 'http://192.168.15.49:8080/api/Occurrence/PostOccurrence';

      ocorrencia.address.cep =
          ocorrencia.address.cep.replaceAll(RegExp(r'-'), '');
      ocorrencia.address.cep =
          ocorrencia.address.cep.replaceAll(RegExp(r'.'), '');

      String base64Image;
      if (file != null) {
        List<int> imageBytes = file.readAsBytesSync();
        base64Image = convert.base64Encode(imageBytes);
      } else
        base64Image = null;

      Map<String, String> headers = {"Content-Type": "application/json"};

      var params = {
        "occurrence_type": ocorrencia.occurrence_type,
        "address": {
          "name_street": ocorrencia.address.name_street,
          "cep": ocorrencia.address.cep
        },
        "longitude": ocorrencia.longitude,
        "latitude": ocorrencia.latitude,
        "description": ocorrencia.description,
        "date": ocorrencia.date,
        "pathFoto": base64Image,
        "stolen_object": ocorrencia.stolen_object,
        "crime_scene": ocorrencia.crime_scene,
        "crime_time": ocorrencia.crime_time
      };

      String json = convert.jsonEncode(params);

      print(url);
      print("params: " + json);

      final response = await http.post(url, body: json, headers: headers);

      print("http.cadastro << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body);

      if (response.statusCode == 200) {
        final OcorrenciaTest = Ocorrencia.fromjson(map);
        return ApiResponse.ok(result: OcorrenciaTest);
      }
      return ApiResponse.error(msg: map["error"]);
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível cadastrar a ocorrência.");
    }
  }

  static Future<List<Ocorrencia>> getOcorencia(String type) async {
    const urlAPI =
        'http://192.168.15.49:8080/api/OccurrencePolice/GetOccurrenceType?tipo=';

    print("GET > $urlAPI");

    var response = await http.get(urlAPI + type);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Ocorrencia> ocorrencias =
        list.map<Ocorrencia>((map) => Ocorrencia.fromjson2(map)).toList();

    // ocorrencias.forEach((ocorrencia) => imageDecoder(ocorrencia));

//      João para usaar a imagem você deve fazer da seguinte forma:
//      return new Scaffold(
//          appBar: new AppBar(title: new Text('Example App')),
//          body: new ListTile(
//          leading: new Image.memory(bytes),
//    title: new Text(_base64),
    return ocorrencias;
  }

  static Future<List<Ocorrencia>> getOcorenciaMaps() async {
    const urlAPI =
        'http://192.168.15.49:8080/api/OccurrencePolice/GetAllOccurrence';

    print("GET > $urlAPI");

    var response = await http.get(urlAPI);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Ocorrencia> ocorrencias =
        list.map<Ocorrencia>((map) => Ocorrencia.fromjson2(map)).toList();

//    ocorrencias.forEach((ocorrencia) =>
//        imageDecoder(ocorrencia)
//    );

//      João para usaar a imagem você deve fazer da seguinte forma:
//      return new Scaffold(
//          appBar: new AppBar(title: new Text('Example App')),
//          body: new ListTile(
//          leading: new Image.memory(bytes),
//    title: new Text(_base64),
    return ocorrencias;
  }

  static Future<String> getGeolocalMaps(LatLng localizacao) async {
    var urlAPI =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${localizacao.latitude},${localizacao.longitude}&key=AIzaSyBEe-EjMOAIqv28XeyVpzdybTBnNMxvWY4';

    print("GET > $urlAPI");

    var response = await http.get(urlAPI);

    String json = response.body;

    Map<String, dynamic> map = convert.json.decode(response.body);

//    List<Ocorrencia> ocorrencias = list.map<Ocorrencia>((map) => Ocorrencia.fromjson2(map)).toList();

    return map["results"][0]["formatted_address"];

//    ocorrencias.forEach((ocorrencia) =>
//        imageDecoder(ocorrencia)
//    );

//      João para usaar a imagem você deve fazer da seguinte forma:
//      return new Scaffold(
//          appBar: new AppBar(title: new Text('Example App')),
//          body: new ListTile(
//          leading: new Image.memory(bytes),
//    title: new Text(_base64),
//    return ocorrencias;
  }

  static Ocorrencia imageDecoder(Ocorrencia ocorrencia) {
    final _byteImage = Base64Decoder().convert(ocorrencia.image);
    ocorrencia.byteImage = _byteImage;
    return ocorrencia;
  }
}
