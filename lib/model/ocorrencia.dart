import 'package:here/model/usuario.dart';

class Ocorrencia {
  int      id;
  String   tipo_correncia;
  double   longitude;
  double   latitude;
  String   descricao;
  Endereco endereco;
  Usuario  usuario;
  String   data;
  String   pathFoto;
  String   image;
  List<int> byteImage;

//  Construtor para post
  Ocorrencia(this.tipo_correncia, this.longitude, this.latitude,
      this.descricao, this.endereco, this.data);

  Ocorrencia.fromjson(Map<String, dynamic> json) {
      id             = json['id'];
      tipo_correncia = json['tipo_ocorrencia'];
      endereco       = Endereco.fromjson(json['endereco']);
      longitude      = json['longitude'];
      latitude       = json['latitude'];
      descricao      = json['descricao'];
      data           = json['data'];
      pathFoto       = json['pathFoto'];
      usuario        = Usuario.fromJson(json['usuario']);
      image          = json['image'];
  }
}

class Endereco {
  final int id_endereco;
  final String nome_rua;
  String cep;

  //      Ajuste para com o cep. Existe um erro de arquitetura com o cep que precisa ser analisado.
  //      Basicamente ele é um int, e estamos mandando uma String, não da problema no primeiro momento mas
  //      na hora de receber o json de resposta da merda.
  //        Acho que não é prioridade ainda.
  Endereco({this.id_endereco, this.nome_rua, this.cep});

  factory Endereco.fromjson(Map<String, dynamic> json) {
    return Endereco(
        id_endereco: json['id_enreco'],
        nome_rua: json['nome_rua'],
        cep: json['cep'].toString());
  }
}
