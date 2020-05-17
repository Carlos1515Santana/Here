import 'package:here/model/usuario.dart';

class Ocorrencia {
  int      id;
  String   occurrence_type;
  double   longitude;
  double   latitude;
  String   description;
  Address address;
  Customer  customer;
  String   date;
  String   pathFoto;
  String   image;
  List<int> byteImage;

//  Construtor para post
  Ocorrencia(this.occurrence_type, this.longitude, this.latitude,
      this.description, this.address, this.date);

  Ocorrencia.fromjson(Map<String, dynamic> json) {
      id             = json['id'];
      occurrence_type = json['occurrence_type'];
      address       = Address.fromjson(json['address']);
      longitude      = json['longitude'];
      latitude       = json['latitude'];
      description      = json['description'];
      date           = json['date'];
      pathFoto       = json['pathFoto'];
      customer        = Customer.fromJson(json['customer']);
      image          = json['image'];
  }
}

class Address {
  final int id_addres;
  final String name_street;
  String cep;

  //      Ajuste para com o cep. Existe um erro de arquitetura com o cep que precisa ser analisado.
  //      Basicamente ele é um int, e estamos mandando uma String, não da problema no primeiro momento mas
  //      na hora de receber o json de resposta da merda.
  //        Acho que não é prioridade ainda.
  Address({this.id_addres, this.name_street, this.cep});

  factory Address.fromjson(Map<String, dynamic> json) {
    return Address(
        id_addres: json['id_enreco'],
        name_street: json['nome_rua'],
        cep: json['cep'].toString());
  }
}
