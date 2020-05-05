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
import 'package:flutter_masked_text/flutter_masked_text.dart';

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
  var controllerMask = MaskedTextController(mask: '00000-000');

  _OcorrenciaPageState(LatLng localizacao) {
    latitude = localizacao.longitude;
    longitude = localizacao.longitude;
  }

  List<String> _ocrcs = <String>[
    '',
    'Assalto',
    'Furto',
    'Estupro',
    'Latrocinio'
  ];
  String _ocrc = '';

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
          title: Text('Ocorrencias'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Cadastrar Ocorrência',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Schyler',
                  ),
                ),
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Selecione uma ocorrência',
                      errorText: state.hasError ? state.errorText : null,
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
              TextFormField(
                controller: _controladorData,
                decoration: InputDecoration(
                  labelText: 'Data do crime',
                  hintText: 'Insira a data que ocorreu',
                ),
                onTap: () async {
                  DateTime dateT = DateTime(2010);
                  FocusScope.of(context).requestFocus(FocusNode());

                  dateT = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2100),
                  );
                  _controladorData.text =
                      DateFormat('yyyy-MM-dd').format(dateT);
                },
              ),
              TextFormField(
                controller: controllerMask,
                decoration: InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Insira o CEP onde ocorreu',
                ),
                onSaved: (String value) {
                   print('CEP: ' + value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: TextField(
                  controller: _controladorDescricao,
                  decoration: InputDecoration(
                    labelText: 'Descrição do crime',
                    hintText: 'Insira uma breve descrição',
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
                width: 280.0,
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

                  //shape: RoundedRectangleBorder(
                  //    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  //),
                  textColor: Colors.white,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enviarOcorrencia() {
    Endereco endereco = Endereco(cep: controllerMask.text, nome_rua: '');
    Usuario user;
    Ocorrencia newOcorrencia = Ocorrencia( _controladorTipo, longitude,
        latitude, _controladorDescricao.text, endereco, _controladorData.text );
        _cadastrarOcorrencia(newOcorrencia);
  }

  void _cadastrarOcorrencia(Ocorrencia newOcorrencia) async {
    final resposta = await OcorrenciaAPI.postOcorrencia(newOcorrencia);
    if (resposta != null) {
      Navigator.pop(context, newOcorrencia);
    }
    //imprimir os dados
     print(
        'Latitude: ${newOcorrencia.latitude}, tipo Ocorrencia: ${newOcorrencia.tipo_correncia}, data: ${newOcorrencia.data}, CEP: ${newOcorrencia.endereco.cep} DEscrição: ${newOcorrencia.descricao}');
  }
}
