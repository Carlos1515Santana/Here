import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:here/model/usuario.dart';
import 'package:here/widgets/AppButton.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:here/widgets/AppText2.dart';

class OcorrenciaPage extends StatefulWidget {
  LatLng localizacao;

  OcorrenciaPage(LatLng localizacao) {
    this.localizacao = localizacao;
  }

  @override
  State<StatefulWidget> createState() => _OcorrenciaPageState(localizacao);
}

class _OcorrenciaPageState extends State<OcorrenciaPage> {
  var _controladorOcr;
  var _controladorObj;
  var latitude;
  var longitude;
  final TextEditingController _controladorData = TextEditingController();
  final TextEditingController _controladorHora = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController _controladorLocal = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  String ocorrencia, objeto, data, hora, local, descricao;

  _OcorrenciaPageState(LatLng localizacao) {
    latitude = localizacao.latitude;
    longitude = localizacao.longitude;
    OcorrenciaAPI.getGeolocalMaps(localizacao)
        .then((value) => {street.text = value});
  }

  List<String> _ocrcs = <String>['', 'Furto', 'Roubo'];

  List<String> _objetos = <String>[
    '',
    'Celular',
    'Carro',
    'Bicicleta',
    'Documentos pessoais',
    'Moto'
  ];

  String _ocrc = '';
  String _objeto = '';
  File _imagem;

  Future getImagem() async {
    var imagem = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxHeight: 150);
    setState(() {
      _imagem = imagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cadastrar Ocorrências'),
          backgroundColor: Color(0XFF3F51b5),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
          child: Column(
            children: [
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  );
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Selecione uma ocorrência',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      errorText: state.hasError ? state.errorText : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF3F51b5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    isEmpty: _ocrc == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _ocrc,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _controladorOcr = newValue;
                            _ocrc = newValue;
                            state.didChange(newValue);
                            if (_ocrc != '') {
                              _showDialog();
                            }
                          });
                        },
                        items: _ocrcs.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: _validarOcorrencia,
                onSaved: (String val) {
                  ocorrencia = val;
                },
              ),
              SizedBox(height: 15),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Selecione o que foi roubado',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      errorText: state.hasError ? state.errorText : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFF28b1b3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    isEmpty: _objeto == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _objeto,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _controladorObj = newValue;
                            _objeto = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _objetos.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: _validarObjeto,
                onSaved: (String val) {
                  objeto = val;
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText2(
                        "Data do crime",
                        "Data do crime",
                        controller: _controladorData,
                        validator: _validarData,
                        onSaved: (String val) {
                          data = val;
                        },
                        onTap: () async {
                          DateTime dateT = DateTime(2019);
                          FocusScope.of(context).requestFocus(FocusNode());
                          dateT = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2019),
                            lastDate: DateTime.now(),
                          );
                          _controladorData.text =
                              DateFormat.yMd('pt').format(dateT);
                        },
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: AppText2(
                        "Hora do crime",
                        "Hora que ocorreu o crime",
                        controller: _controladorHora,
                        validator: _validarHora,
                        onSaved: (String val) {
                          hora = val;
                        },
                        onTap: () async {
                          TimeOfDay hora = TimeOfDay();
                          FocusScope.of(context).requestFocus(FocusNode());
                          hora = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          _controladorHora.text = hora.format(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              AppText2(
                "Local do crime",
                "Insira o local em que ocorreu o crime",
                controller: _controladorLocal,
                validator: _validarLocalCrime,
                onSaved: (String val) {
                  local = val;
                },
              ),
              SizedBox(height: 15),
              AppText2(
                "Descrição do crime",
                "Insira uma breve descrição do que aconteceu",
                controller: _controladorDescricao,
                validator: _validarDescCrime,
                maxLines: 2,
                onSaved: (String val) {
                  descricao = val;
                },
              ),
              SizedBox(height: 15),
              AppText2(
                "Endereço",
                "Endereço",
                controller: street,
                enabled: false,
              ),
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: _imagem == null
                    ? Text('Nenhuma imagem selecionada')
                    : Image.file(_imagem),
              ),
              Container(
                child: RaisedButton(
                  onPressed: () {
                    getImagem();
                  },
                  child: Text(
                    'Inserir uma imagem',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              AppButton("Registrar", onPressed: () {
                _enviarOcorrencia();
              }),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          /*Widget NaoMostrarMaisButton = FlatButton(
            child: Text('Não mostrar novamente'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ); */
          Widget EntendiButton = FlatButton(
            child: Text('Entendi'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          return AlertDialog(
            title: Text('Diferença entre furto e roubo'),
            content: Text(
                'Quando alguém entra numa casa vazia sem que os donos estejam lá dentro e leva bens de valor, configura-se um furto. '
                'O roubo, por sua vez, aconteceria se o ladrão invadisse a casa, encontrasse os moradores e os ameaçasse para levar seus bens.'),
            actions: [
              //NaoMostrarMaisButton,
              EntendiButton,
            ],
          );
        });
  }

  String _validarOcorrencia(String value) {
    if (value.isEmpty) {
      return 'Insira o local do crime';
    }
  }

  String _validarObjeto(String value) {
    if (value.isEmpty) {
      return 'Insira o local do crime';
    }
  }

  String _validarData(String value) {
    if (value.isEmpty) {
      return 'Insira uma data';
    }
  }

  String _validarHora(String text) {
    if (text.isEmpty) {
      return 'Insira um hórario';
    }
  }

  String _validarLocalCrime(String value) {
    if (value.isEmpty) {
      return 'Insira o local do crime';
    }
  }

  String _validarDescCrime(String value) {
    if (value.isEmpty) {
      return 'Insira uma descrição do crime';
    }
  }

  void _enviarOcorrencia() {
    Address endereco =
        Address(cep: _cepController.text, name_street: street.text);
    Customer user;

    var data = _controladorData.text.replaceAll(RegExp(r'/'), '-');
    var l = data.split('-');
    data = l[2] + '-' + l[1] + '-' + l[0];
    Ocorrencia newOcorrencia = Ocorrencia(
        _controladorOcr,
        longitude,
        latitude,
        _controladorDescricao.text,
        endereco,
        data,
        _controladorObj,
        _controladorLocal.text,
        _controladorHora.text);
    _cadastrarOcorrencia(newOcorrencia);
  }

  void _cadastrarOcorrencia(Ocorrencia newOcorrencia) async {
    final resposta = await OcorrenciaAPI.postOcorrencia(newOcorrencia, _imagem);
    if (resposta != null) {
      Navigator.pop(context, 'Ocorrencia cadastrada');
    }
    //imprimir os dados
    print(
        'Latitude: ${newOcorrencia.latitude}, tipo Ocorrencia: ${newOcorrencia.occurrence_type}, Objeto roubado: ${newOcorrencia.stolen_object}, '
        'data: ${newOcorrencia.date}, hora: ${newOcorrencia.crime_time}, CEP: ${newOcorrencia.address.cep}, '
        'Local do crime: ${newOcorrencia.crime_scene}, Descrição: ${newOcorrencia.description}');
  }
}
