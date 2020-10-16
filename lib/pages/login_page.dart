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
      bottomNavigationBar: _createAccountLink(),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                          AppText('Nome', 'Digite o nome de usuário',
                              controller: _tLogin,
                              validator: _validateLogin,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              nextFocus: _focusSenha
                          ),
                          SizedBox(height: 16),
                          AppText('Senha', "Digite a senha",
                              controller: _tSenha,
                              password: true,
                              validator: _validateSenha,
                              keyboardType: TextInputType.number,
                              focusNode: _focusSenha
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {

                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          AppButton('Entrar',
                            onPressed: _onClickLogin, showProgress: _showProgress,
                          ),
                          SizedBox(height: 12),

                        ],
                    ),
                  ),
                ),
            ),
        ]
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
          Widget OKButton = FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
          return AlertDialog(
            //title: Text('Diferença entre furto e roubo'),
            content: Text('Nome de usuário ou senha inválidos!'),
            actions: [
              //NaoMostrarMaisButton,
              OKButton,
            ],
          );
        }
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
            'Crie Sua Conta',
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
              )
          ),

        ],
      ),
    );
  }

  _createAccountLink() {
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
    else{
      _showDialog();
    }

    setState(() {
      _showProgress = false;
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
