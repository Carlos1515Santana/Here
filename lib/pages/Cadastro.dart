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
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nome, email, Data, senha;
  final TextEditingController _controladorData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Cadastrar'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
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
    return new Column(
      children: <Widget>[
      TextFormField(
          decoration: new InputDecoration(hintText: 'Nome Completo'),
          maxLength: 40,
          validator: _validarNome,
          onSaved: (String val) {
            nome = val;
          },
        ),
        TextFormField(
          controller: _controladorData,
          decoration: InputDecoration(
            labelText: 'Data de nascimento',
            hintText: 'Insira a data',
          ),
          onTap: () async {
            DateTime dateT = DateTime(2010);
            FocusScope.of(context).requestFocus(FocusNode());

            dateT = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1500),
              lastDate: DateTime(2021),
            );
            _controladorData.text =
                DateFormat('yyyy-MM-dd').format(dateT);
          }
        ),
         TextFormField(
            decoration: new InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            maxLength: 40,
            validator: _validarEmail,
            onSaved: (String val) {
              email = val;
            }),
         TextFormField(
            decoration: new InputDecoration(hintText: 'Senha'),
            keyboardType: TextInputType.text,
            obscureText: true,
            maxLength: 20,
            validator: _validarSenha,
            onSaved: (String val) {
              senha = val;
            }),
         SizedBox(height: 15.0),
         RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar'),
        )
      ],
    );
  }

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCelular(String value) {
    String patttern = r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o ano";
    } else if(value.length != 8){
      return "informe 8 digitos";
    }else if (!regExp.hasMatch(value)) {
      return "Verifique a idade";
    }
    return null;
  }

  String _validarEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }

  String _validarSenha(String value) {
    //String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe uma senha";
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
      Customer customer = new Customer(nome, email, senha, Data);
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