import 'package:here/model/usuario.dart';

class Ocorrencia {
  int id;
  String occurrence_type;
  double longitude;
  double latitude;
  String description;
  Address address;
  Customer customer;
  String date;
  String pathFoto;
  String image;
  String stolen_object;
  String crime_scene;
  String crime_time;
  List<int> byteImage;
  String type;

//  Construtor para post
  Ocorrencia(
      this.occurrence_type,
      this.longitude,
      this.latitude,
      this.description,
      this.address,
      this.date,
      this.stolen_object,
      this.crime_scene,
      this.crime_time);

  Ocorrencia.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    occurrence_type = json['occurrence_type'];
    address = Address.fromjson(json['address']);
    longitude = json['longitude'];
    latitude = json['latitude'];
    description = json['description'];
    date = json['date'];
    pathFoto = json['pathFoto'];
    customer = Customer.fromJson(json['customer']);
    image = json['image'];
    stolen_object = json['stolen_object'];
    crime_scene = json['crime_scene'];
    crime_time = json['crime_time'];
  }

  Ocorrencia.fromjson2(Map<String, dynamic> json) {
    id = json['id'];
    occurrence_type = json['tipo_ocorrencia'];
//    address       = Address.fromjson(json['address']);
    longitude = json['longitude'];
    latitude = json['latitude'];
    description = json['descricao'];
    date = json['data'];
//    pathFoto       = json['pathFoto'];
//    customer        = Customer.fromJson(json['customer']);
    image = json['image'];
    stolen_object = json['stolen_object'];
    crime_scene = json['crime_scene'];
    crime_time = json['crime_time'];
    type = json['type'];
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
        id_addres: json['id_addres'],
        name_street: json['name_street'],
        cep: json['cep'].toString());
  }
}
