import 'package:flutter/material.dart';
import 'package:here/APIs/cadastroCustomer.dart';
import 'package:here/model/usuario.dart';
import 'package:intl/intl.dart';

void main() => runApp(new Cadastro());

class Cadastro extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Cadastro> {
  GlobalKey<FormState> _key =  GlobalKey();
  bool _validate = false;
  String nome, email, Data, senha;
  final TextEditingController _controladorData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:  AppBar(
          title:  Text('Cadastrar'),
          backgroundColor: Colors.blueGrey,
        ),
        body:  SingleChildScrollView(
          child:  Container(
            margin:  EdgeInsets.all(15.0),
            child:  Form(
              key: _key,
              autovalidate: _validate,
              child: _formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: TextFormField(
            decoration: new InputDecoration(
              labelText: 'Nome',
              hintText: 'Digite seu nome',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
            ),
            maxLength: 40,
            validator: _validarNome,
            onSaved: (String val) {
              nome = val;
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: TextFormField(
              controller: _controladorData,
              decoration: InputDecoration(
                labelText: 'Data de nascimento',
                hintText: 'Insira a data',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
              maxLength: 10,
              //validator: _validarData,
              onTap: () async {
                DateTime dateT = DateTime(2010);
                FocusScope.of(context).requestFocus(FocusNode());
                dateT = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime.now(),
                );
                _controladorData.text =
                    DateFormat.yMd('pt').format(dateT);
              }
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: TextFormField(
              decoration: new InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 40,
              validator: _validarEmail,
              onSaved: (String val) {
                email = val;
              }
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: TextFormField(
              decoration: new InputDecoration(
                labelText: 'Senha',
                hintText: 'Digite sua senha',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF28b1b3), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              maxLength: 20,
              validator: _validarSenha,
              onSaved: (String val) {
                senha = val;
              }
          ),
        ),

        Container(
          width: 320.0,
          height: 67.0,
          padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
          child: RaisedButton(
            child: Text(
              'Registrar-se',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () {
              _sendForm();
            },
            textColor: Colors.white,
            color: Color(0XFF28b1b3),
          ),
        ),
      ],
    );
  }

  String _validarNome(String value) {
    var patttern = r'(^[a-zA-Z ]*$)';
    var regExp =  RegExp(patttern);
    if (value.isEmpty) {
      return 'Informe o nome';
    } else if (!regExp.hasMatch(value)) {
      return 'O nome deve conter caracteres de a-z ou A-Z';
    }
    return null;
  }

  String _validarEmail(String value) {
    var pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Informe o Email';
    } else if(!regExp.hasMatch(value)){
      return 'Email inválido';
    }else {
      return null;
    }
  }

  String _validarData(String value) {
    if(value.length == 0){
      return 'Insira uma data';
    }
  }

  String _validarSenha(String value) {
    if (value.isEmpty) {
      return 'Informe uma senha';
    } //else if(!regExp.hasMatch(value)){
      //return "Senha inválida";
    //}
    else {
      return null;
    }
  }

  _sendForm() async {
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();
      Data = _controladorData.text;
      ;
      var customer =  Customer(nome, email, senha, Data);
      final resposta = await CadastroCustomer.postCustomer(customer);
      if (resposta.msg != 'error') {
        Navigator.pop(context);
      }

    } else {
      // erro de validação print("Nome $nome");
      //      print("Ceclular $celular");
      //      print("Email $email");
      setState(() {
        _validate = true;
      });
    }
  }
}