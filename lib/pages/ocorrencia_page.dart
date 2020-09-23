import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:here/model/usuario.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brasil_fields/brasil_fields.dart';

class OcorrenciaPage extends StatefulWidget {
  LatLng localizacao;

  OcorrenciaPage(LatLng localizacao) {
    this.localizacao = localizacao;
  }

  @override
  State<StatefulWidget> createState() => _OcorrenciaPageState(localizacao);
}

class _OcorrenciaPageState extends State<OcorrenciaPage> {
  var _controladorTipo;
  var latitude;
  var longitude;
  final TextEditingController _controladorData = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  _OcorrenciaPageState(LatLng localizacao) {
    latitude = localizacao.latitude;
    longitude = localizacao.longitude;
  }

  List<String> _ocrcs = <String>[
    '',
    'Furto',
    'Roubo'
  ];

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
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 150);
    setState(() {
      _imagem = imagem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      home: Scaffold(
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Cadastrar Ocorrências'),
          backgroundColor: Colors.black12,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Selecione uma ocorrência',
                        errorText: state.hasError ? state.errorText : null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      isEmpty: _ocrc == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _ocrc,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _controladorTipo = newValue;
                              _ocrc = newValue;
                              state.didChange(newValue);
                              if(_ocrc != ''){
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
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Selecione o objeto roubado',
                        errorText: state.hasError ? state.errorText : null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                      isEmpty: _objeto == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _objeto,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _controladorTipo = newValue;
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
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 200.0),
                child: TextFormField(
                  controller: _controladorData,
                  decoration: InputDecoration(
                    labelText: 'Data do crime',
                    hintText: 'Data que ocorreu',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  validator: _validarData,
                  onTap: () async {
                    DateTime dateT = DateTime(2019);
                    FocusScope.of(context).requestFocus(FocusNode());
                    dateT = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2019),
                      lastDate: DateTime.now(),
                    );
                    _controladorData.text = DateFormat.yMd('pt').format(dateT);
                    
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 200.0),
                child: TextFormField(
                  //controller: _controladorData,
                  decoration: InputDecoration(
                    labelText: 'Hora do crime',
                    hintText: 'Hora que ocorreu',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  validator: _validarData,
                  onTap: () async {
                    TimeOfDay time = TimeOfDay();
                    FocusScope.of(context).requestFocus(FocusNode());
                    time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  controller: _cepController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    hintText: 'Insira o CEP onde ocorreu',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  onSaved: (String value) {
                    print('CEP: ' + value);
                  },
                  keyboardType: TextInputType.number,
                  validator: _validarEndereco,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextField(
                  controller: _controladorDescricao,
                  decoration: InputDecoration(
                    labelText: 'Local do crime',
                    hintText: 'Insira o local que acocnteceu',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextField(
                  controller: _controladorDescricao,
                  decoration: InputDecoration(
                    labelText: 'Descrição do crime',
                    hintText: 'Insira uma breve descrição',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 20.0),
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

              Container(
                width: 320.0,
                height: 67.0,
                padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                child: RaisedButton(
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    _enviarOcorrencia();
                  },
                  textColor: Colors.white,
                  color: Color(0XFF28b1b3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validarEndereco(String value) {
    String pattern = r'^\\d{5}-\\d{3}';
    RegExp regExp = new RegExp(pattern);
    if(value.length == 0) {
      return 'Informe um CEP';
    } else if(!regExp.hasMatch(value)) {
      return 'CEP inválido';
    }
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
            content: Text('Quando alguém entra numa casa vazia sem que os donos estejam lá dentro e leva bens de valor, configura-se um furto. O roubo, por sua vez, aconteceria se o ladrão invadisse a casa, encontrasse os moradores e os ameaçasse para levar seus bens.'),
            actions: [
              //NaoMostrarMaisButton,
              EntendiButton,
            ],
          );
        }
    );
  }

  String _validarData(String value) {
    if(value.length == 0){
      return 'Insira uma data';
    }
  }

  String _validarCEP(String value) {
    if(value.length == 0) {
      return 'Insira o CEP';
    }
  }

  void _enviarOcorrencia() {
    Address endereco = Address(cep: _cepController.text, name_street: 'N/A');
    Customer user;

    var data = _controladorData.text.replaceAll( RegExp(r'/'), '-');
    var l =  data.split('-');
    data = l[2] +'-' + l[1] + '-'+ l[0];
    Ocorrencia newOcorrencia = Ocorrencia( _controladorTipo, longitude,
        latitude, _controladorDescricao.text, endereco,  data);
    _cadastrarOcorrencia(newOcorrencia);
  }

  void _cadastrarOcorrencia(Ocorrencia newOcorrencia) async {
    final resposta = await OcorrenciaAPI.postOcorrencia(newOcorrencia, _imagem);
    if (resposta != null) {
      Navigator.pop(context, 'Ocorrencia cadastrada');
    }
    //imprimir os dados
     print(
        'Latitude: ${newOcorrencia.latitude}, tipo Ocorrencia: ${newOcorrencia.occurrence_type}, data: ${newOcorrencia.date}, CEP: ${newOcorrencia.address.cep} Descrição: ${newOcorrencia.description}');
  }
}
