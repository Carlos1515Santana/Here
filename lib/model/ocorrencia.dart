import 'package:here/model/usuario.dart';

class Ocorrencia {
  int id;
  String tipo_correncia;
  double longitude;
  double latitude;
  String descricao;
  Endereco endereco;
  Usuario usuario;
  DateTime data;

  Ocorrencia(this.id, this.tipo_correncia, this.longitude, this.latitude,
      this.descricao, this.endereco, this.usuario, this.data);
  // Ocorrencia();

  Ocorrencia.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    tipo_correncia = json['tipo_ocorrencia'];
    endereco = Endereco.fromjson(json['property']);
    longitude = json['longitude'];
    latitude = json['latitude'];
    descricao = json['descricao'];
    usuario = json['usuario'];
  }
}

class Endereco {
  final int id_endereco;
  final String nome_rua;
  final String cep;

  Endereco({this.id_endereco, this.nome_rua, this.cep});

  factory Endereco.fromjson(Map<String, dynamic> json) {
    return Endereco(
        id_endereco: json['id_enreco'],
        nome_rua: json['nome_rua'],
        cep: json['cep']);
  }
}
