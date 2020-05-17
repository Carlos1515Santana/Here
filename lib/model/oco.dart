import 'package:here/model/usuario.dart';

class OcorrenciaList {
  int      id;
  String   tipo_correncia;
  double   longitude;
  double   latitude;
  String   descricao;
  String endereco;
  String  usuario;
  String   data;
  String   pathFoto;
  String   image;
  List<int> byteImage;

//  Construtor para post
  OcorrenciaList(this.tipo_correncia, this.usuario, this.longitude, this.latitude,
      this.descricao, this.endereco, this.data, this.image);
      

  OcorrenciaList.fromjson(Map<String, dynamic> json) {
      id             = json['id'];
      tipo_correncia = json['tipo_ocorrencia'];
      endereco       = json['endereco'];
      longitude      = json['longitude'];
      latitude       = json['latitude'];
      descricao      = json['descricao'];
      data           = json['data'];
      pathFoto       = json['pathFoto'];
      usuario        = json['usuario'];
      image          = json['image'];
  }
}
 
class EnderecoList {
  final int id_endereco;
  final String nome_rua;
  String cep;

  //      Ajuste para com o cep. Existe um erro de arquitetura com o cep que precisa ser analisado.
  //      Basicamente ele é um int, e estamos mandando uma String, não da problema no primeiro momento mas
  //      na hora de receber o json de resposta da merda.
  //        Acho que não é prioridade ainda.
  EnderecoList({this.id_endereco, this.nome_rua, this.cep});

  factory EnderecoList.fromjson(Map<String, dynamic> json) {
    return EnderecoList(
        id_endereco: json['id_enreco'],
        nome_rua: json['nome_rua'],
        cep: json['cep'].toString());
  }
}
