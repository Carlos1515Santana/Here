import 'dart:convert';
import 'dart:io';

import 'package:here/model/ocorrencia.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'api_response.dart';

class OcorrenciaAPI {
  static Future<ApiResponse<Ocorrencia>> postOcorrencia(Ocorrencia ocorrencia, File file) async {
    try {
      var url = 'https://help-api.herokuapp.com/api/Occurrence/PostOccurrence';

      ocorrencia.address.cep = ocorrencia.address.cep.replaceAll(new RegExp(r'-'), '');
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = convert.base64Encode(imageBytes);

      Map<String,String> headers = {"Content-Type": "application/json"};

      var params = {
        "occurrence_type": ocorrencia.occurrence_type,
        "address":        {
          "name_street" : ocorrencia.address.name_street,
          "cep"      : ocorrencia.address.cep
        },
        "longitude":       ocorrencia.longitude,
        "latitude":        ocorrencia.latitude,
        "description":       ocorrencia.description,
        "date":            ocorrencia.date,
        "pathFoto":        base64Image
      };

      String json = convert.jsonEncode(params);

      print(url);
      print("params: " + json);

      final response = await http.post(url, body: json, headers: headers);

      print("http.cadastro << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body);

      if (response.statusCode == 200) {
        final OcorrenciaTest =  Ocorrencia.fromjson(map);
        return ApiResponse.ok(result: OcorrenciaTest);
      }
      return ApiResponse.error(msg: map["error"]);

    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível cadastrar a ocorrência.");
    }
  }

  static Future<List<Ocorrencia>> getOcorencia() async {
    const urlAPI = 'https://help-api.herokuapp.com/api/Occurrence/GetAllOccurrence';

    print("GET > $urlAPI");

    var response = await http.get(urlAPI);

    String json = response.body;

    List list = convert.json.decode(json);

    List<Ocorrencia> ocorrencias = list.map<Ocorrencia>((map) => Ocorrencia.fromjson(map)).toList();

    ocorrencias.forEach((ocorrencia) =>
        imageDecoder(ocorrencia)
    );

//      João para usaar a imagem você deve fazer da seguinte forma:
//      return new Scaffold(
//          appBar: new AppBar(title: new Text('Example App')),
//          body: new ListTile(
//          leading: new Image.memory(bytes),
//    title: new Text(_base64),
    return ocorrencias;
  }

  static Ocorrencia imageDecoder(Ocorrencia ocorrencia){
    final _byteImage = Base64Decoder().convert(ocorrencia.image);
    ocorrencia.byteImage = _byteImage;
    return ocorrencia;
  }
}