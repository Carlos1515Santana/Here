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
import 'package:here/widgets/PageRouteAnimation.dart';

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
      backgroundColor: Color(0XFF3F51b5),
      bottomNavigationBar: _criarConta(),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        SizedBox(height: 40),
        _topheader(),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.grey[50],
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
                  AppText('E-mail', 'Digite seu e-mail ',
                      controller: _tLogin,
                      validator: _validateLogin,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      nextFocus: _focusSenha),
                  SizedBox(height: 16),
                  AppText('Senha', "Digite sua senha",
                      controller: _tSenha,
                      password: true,
                      validator: _validateSenha,
                      keyboardType: TextInputType.text,
                      focusNode: _focusSenha),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        'Esqueceu a senha?',
                        style: TextStyle(
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    'Entrar',
                    onPressed: _onClickLogin,
                    showProgress: _showProgress,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _topheader() {
    return Padding(
      padding: EdgeInsets.only(left: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Here Ocorrências',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
          Container(
              padding: EdgeInsets.only(right: 30),
              child: Image.asset(
                'assets/Logo.png',
                height: 170,
                fit: BoxFit.fitHeight,
              )),
        ],
      ),
    );
  }

  _criarConta() {
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.only(bottom: 16),
      height: 60,
      child: InkWell(
        onTap: () {
          Navigator.push(context, PageRouteAnimation(widget: Cadastro()));
        },
        child: Center(
          child: Text(
            'Não tem um conta? Crie uma agora',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF416BC1),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Widget OKButton = FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          return AlertDialog(
            //title: Text(''),
            content: Text('Nome de usuário ou senha inválidos!'),
            actions: [
              //NaoMostrarMaisButton,
              OKButton,
            ],
          );
        });
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
    print("E-mail: $login, Senha: $senha");

    ApiResponse response = await LoginApi.login(login, senha);
    if (response.ok) {
      Customer user = response.result;
      push(context, HomePage());
    } else {
      _showDialog();
    }

    setState(() {
      _showProgress = false;
    });
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Digite o e-mail";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
