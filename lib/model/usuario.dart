class Usuario{
//  int    id;
//  int    idade;
//  String usuario;
//  String email;
//  String senha;
//
//  Usuario.fromJson(Map<String, dynamic> json) {
//    id      = json['id'     ];
//    email   = json['email'  ];
//    senha   = json['senha'  ];
//    idade   = json['idade'  ];
//    usuario = json['usuario'];
//  }

  String login;
  String nome;
  String email;
  String token;
  List<String> roles;

  Usuario.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    nome = json['nome'];
    email = json['email'];
    token = json['token'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : null;
  }
}