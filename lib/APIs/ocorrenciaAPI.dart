import 'dart:convert';
import 'dart:io';

import 'package:here/model/ocorrencia.dart';
import 'package:here/model/usuario.dart';
import 'package:http/http.dart' as http;

import 'api_response.dart';

class OcorrenciaAPI {
  static Future<ApiResponse<Usuario>> postOcorrencia(
      Ocorrencia ocorrencia) async {
    try {
      var url = 'endPonit';

      Map<String, String> headers = {"Content-Type": "application/json"};

      print(url);
      print(">> $ocorrencia");

      var response = await http.post(url, body: ocorrencia, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);
        return ApiResponse.ok(result: user);
      }

      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível Cadastrar ocorrencia.");
    }
  }

 static Future<Ocorrencia> getOcorencia() async {
    const urlAPI =
        'https://github.com/shalomfernando/testAPI/blob/master/db.json';

    // Retrieve the locations of Google offices
    final response = await http.get(urlAPI);

    if (response.statusCode == 200) {
      return Ocorrencia.fromjson(json.decode(response.body));
    } else {
      throw HttpException(
          'Unexpected status code ${response.statusCode}:'
          ' ${response.reasonPhrase}',
          uri: Uri.parse(urlAPI));
    }
  }
}
