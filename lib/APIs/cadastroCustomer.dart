import 'package:here/APIs/api_response.dart';
import 'package:here/model/usuario.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CadastroCustomer{
  static Future<ApiResponse<Customer>> postCustomer(Customer customer) async {
    try {
      var url = 'https://help-api.herokuapp.com/api/Customer/SaveCustomer';
      Map<String, String> headers = {"Content-Type": "application/json"};

      var params = {
        "name": customer.name,
        "cpf": customer.cpf,
        "rg": customer.rg,
        "userName": customer.userName,
        "email": customer.email,
        "password": customer.password,
        "birthday": customer.birthday
      };

      String json = convert.jsonEncode(params);

      print(url);
      print("params: " + json);

      var  response = await http.post(url, body: json, headers: headers);

      print("http.cadastro << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse.ok(msg: "Usuario cadastrado");
      }
      return ApiResponse.error(msg: "Usuario cadastrado");
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      return ApiResponse.error(msg: "Não foi possível cadastrar o usuário.");
    }
  }
}