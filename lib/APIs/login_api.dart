import 'dart:convert';

import 'package:here/model/usuario.dart';
import 'package:http/http.dart'as http;

import 'api_response.dart';

class LoginApi {
  static Future<ApiResponse<Usuario>> login(String login, String senha) async {
    try {
//      O que estiver comentado é algo relaciondo ao login oficial
//    Isso é só um mero paliativo.
//      var url = 'https://carros-springboot.herokuapp.com/api/v2/login';
      var url = 'https://help-api.herokuapp.com/api/Customer/login/$login/$senha';
//      var url = 'http://192.168.15.49:8080/cadastro/login/$login/$senha';

      Map<String,String> headers = {
        "Content-Type": "application/json"
      };

      Map params = {
        "username": login,
        "password": senha
      };

      String s = json.encode(params);
      print(url);
      print(">> $s");

      var response = await http.post(url, body: s, headers: headers);
//      var response = await http.post(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if(response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);
        return ApiResponse.ok(result: user);
      }
      return ApiResponse.error(msg:mapResponse["error"]);
    } catch(error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg:"Não foi possível fazer o login.");
    }
  }
}