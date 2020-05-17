import 'dart:convert';
import 'dart:io';

import 'package:here/model/ocorrencia.dart';
import 'package:here/model/usuario.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'api_response.dart';

class OcorrenciaAPI {
  static Future<ApiResponse<Ocorrencia>> postOcorrencia(
      Ocorrencia ocorrencia, File file) async {
    try {
      var url = 'https://help-api.herokuapp.com/api/Occurrence/PostOccurrence';

      ocorrencia.endereco.cep =
          ocorrencia.endereco.cep.replaceAll(new RegExp(r'-'), '');
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = convert.base64Encode(imageBytes);

      Map<String, String> headers = {"Content-Type": "application/json"};

      var params = {
        "occurrence_type": ocorrencia.tipo_correncia,
        "address": {
          "name_street": ocorrencia.endereco.nome_rua,
          "cep": ocorrencia.endereco.cep
        },
        "longitude": ocorrencia.longitude,
        "latitude": ocorrencia.latitude,
        "description": ocorrencia.descricao,
        "date": ocorrencia.data,
        "pathFoto": base64Image
      };

      String json = convert.jsonEncode(params);

      print(url);
      print("params: " + json);

      final response = await http.post(url, body: json, headers: headers);

      print("http.cadastro << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body);

      if (response.statusCode == 200) {
//        final OcorrenciaTest = Ocorrencia.fromjson(map);
        return ApiResponse.ok(msg: "Cadastro realizado!!");
      }
      return ApiResponse.error(msg: map["error"]);
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível cadastrar a ocorrência.");
    }
  }

  static Future<dynamic> getOcorencia() async {
    const urlAPI = 'https://help-api.herokuapp.com/api/Occurrence/GetOccurrenceMaps';

    // Retrieve the locations of Google offices
    final response = await http.get(urlAPI);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException(
          'Unexpected status code ${response.statusCode}:'
          ' ${response.reasonPhrase}',
          uri: Uri.parse(urlAPI));
    }
  }
}

class Post {
  final int id;
  final String tipo_ocorrencia;
  final String endereco;
  final double longitude;
  final double latitude;
  final String descricao;
  final String data;
  final String usuario;
  final String image;

  Post(
      {this.id,
      this.tipo_ocorrencia,
      this.endereco,
      this.longitude,
      this.latitude,
      this.descricao,
      this.data,
      this.usuario,
      this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        tipo_ocorrencia: json['tipo_ocorrencia'],
        endereco: json['endereco'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        descricao: json['descricao'],
        data: json['data'],
        usuario: json['usuario'],
        image: json['image']);
  }
  static List<Post> toList(dynamic json){
    List<Post> list = List<Post>();

    list = (json as List).map((item) => Post.fromJson(item)).toList();
    return list;
  }
}
