import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:here/APIs/cadastroCustomer.dart';
import 'package:here/model/usuario.dart';
import 'package:here/utils/alert.dart';
import 'package:here/widgets/AppButton.dart';
import 'package:intl/intl.dart';
import 'package:here/widgets/AppText2.dart';

void main() => runApp(new Cadastro());

class Cadastro extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Cadastro> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  String nome, userName, email, data, cpf, rg, senha;
  final TextEditingController _controladorData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cadastrar'),
          backgroundColor: Color(0XFF3F51b5),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: _formUI(),
            ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return Column(
      children: <Widget>[
        AppText2("Login", "Digite um nome de usuário",
          validator: _validarNome,
          onSaved: (String val) {
            userName = val;
          },
        ),
        SizedBox(height: 15),

        AppText2("Nome", "Digite seu nome completo",
          validator: _validarNome,
          onSaved: (String val) {
            nome = val;
          },
        ),
        SizedBox(height: 15),

        AppText2("Data de nascimento", "Insira a data de nascimento",
          controller: _controladorData,
          validator: _validarData,
          onSaved: (String val) {
            data = val;
          },
          onTap: () async {
            DateTime dateT = DateTime(2010);
            FocusScope.of(context).requestFocus(FocusNode());
            dateT = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1800),
              lastDate: DateTime.now(),
            );
            _controladorData.text = DateFormat.yMd('pt').format(dateT);
          },
        ),
        SizedBox(height: 15),

        AppText2('CPF', 'Digite Seu CPF',
          validator: _validarCPF,
          controller: cpfController,
          maxLines: 1,
          onSaved: (String val) {
            cpf = val;
          },
        ),
        SizedBox(height: 12),

        AppText2('RG', 'Digite Seu RG',
          validator: _validarRG,
          controller: rgController,
          maxLines: 1,
          onSaved: (String val) {
            rg = val;
          },
        ),
        SizedBox(height: 10),

        AppText2('E-mail', 'Digite seu e-mail',
          validator: _validarEmail,
          onSaved: (String val) {
            email = val;
          },
        ),
        SizedBox(height: 15),

        AppText2('Senha', 'Digite uma senha',
          validator: _validarSenha,
          password: true,
          maxLines: 1,
          onSaved: (String val) {
            senha = val;
          },
        ),
        SizedBox(height: 20),

        AppButton(
          "Cadastrar",
          onPressed: () {
            _sendForm();
          },
        ),
      ],
    );
  }

  String _validarData(String value) {
    if(value.isEmpty) {
      return 'Insira uma data';
    }
  }

  String _validarNome(String value) {
    var patttern = r'(^[a-zA-Z ]*$)';
    var regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Informe o nome';
    } else if (!regExp.hasMatch(value)) {
      return 'O nome deve conter caracteres de a-z ou A-Z';
    }
    return null;
  }

  String _validarEmail(String value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Informe o Email';
    } else if (!regExp.hasMatch(value)) {
      return 'Email inválido';
    } else {
      return null;
    }
  }
  String _validarCPF(String value) {
    if (value.isEmpty) {
      return 'Informe um CPF valido';
    } //else if(!regExp.hasMatch(value)){
    //return "CPF inválido";
    //}
    else {
      return null;
    }
  }

  String _validarRG(String value) {
    if (value.isEmpty) {
      return 'Informe um RG valido';
    } //else if(!regExp.hasMatch(value)){
    //return "RG inválido";
    //}
    else {
      return null;
    }
  }
  var cpfController = new MaskedTextController(text: '', mask: '000.000.000-00');
  var rgController = new MaskedTextController(text: '', mask: '00.000.000-@');


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
      var data = _controladorData.text.replaceAll(RegExp(r'/'), '-');
      var l = data.split('-');
      data = l[2] + '-' + l[1] + '-' + l[0];

      var customer = Customer(nome, email, senha, data, userName, cpf, rg);
      final resposta = await CadastroCustomer.postCustomer(customer);
      if (resposta.msg != 'error') {
        Navigator.pop(context);
        alert(context, resposta.msg);
      } else {
        alert(context, "Não foi possivel cadastrar usuario");
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
