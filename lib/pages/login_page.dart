import 'package:flutter/material.dart';
import 'package:here/APIs/api_response.dart';
import 'package:here/APIs/login_api.dart';
import 'package:here/model/usuario.dart';
import 'package:here/pages/Cadastro.dart';
import 'package:here/pages/home_page.dart';
import 'package:here/utils/alert.dart';
import 'package:here/utils/nav.dart';
import 'package:here/widgets/AppButton.dart';
import 'package:here/widgets/app_text.dart';
import 'package:here/utils/nav.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _tLogin = TextEditingController(text: "");
  final _tSenha = TextEditingController(text: "");
  final _focusSenha = FocusNode();
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("HERE!")),
        backgroundColor: Colors.blueGrey,
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.only(top: 120),
        child: ListView(
          children: <Widget>[
            AppText("Login", "Digite o login",
                controller: _tLogin,
                validator: _validateLogin,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                nextFocus: _focusSenha),
            SizedBox(height: 10),
            AppText("Senha", "Digite a senha",
                controller: _tSenha,
                password: true,
                validator: _validateSenha,
                keyboardType: TextInputType.number,
                focusNode: _focusSenha),
            SizedBox(
              height: 20,
            ),
            AppButton("Login", onPressed: _onClickLogin, showProgress: _showProgress),

            Container(
              height: 20,
            ),

            AppButton("Fazer Cadastro", onPressed: _onClickCadastro,),

          ],
        ),
      ),
    );
  }

  Future<void> _onClickCadastro() async {
      await push(context, Cadastro());
  }

  Future<void> _onClickLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _showProgress = true;
    });

    String login = _tLogin.text;
    String senha = _tSenha.text;
    print("Login: $login, Senha: $senha");

    ApiResponse response = await LoginApi.login(login, senha);
    if(response.ok) {
      Customer user = response.result;
      push(context, HomePage());
    }
    else
      alert(context, response.msg);

    setState(() {
      _showProgress = true;
    });
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Digite o login";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter pelo menos 3 números";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
