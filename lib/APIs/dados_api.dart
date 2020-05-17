import 'package:here/model/ocorrenciaAgrupadoDTO.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Dados_api
{
   static Future<List<OcorrenciaAgrupadoDTO>> getOcorrenciaAgrupada(String url) async {
    var urlAPI = 'http://192.168.0.20:8080/OcorrenciaListagem/' + url;

    print("GET > $urlAPI");

    var response = await http.get(urlAPI);

    String json = response.body;

    List list = convert.json.decode(json);

    List<OcorrenciaAgrupadoDTO> ocorrenciasAgrupadas = list.map<OcorrenciaAgrupadoDTO>((map) => OcorrenciaAgrupadoDTO.fromjson(map)).toList();

    return ocorrenciasAgrupadas;
  }
}