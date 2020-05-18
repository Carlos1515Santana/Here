class Customer{
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

  String name;
  String cpf;
  String email;
  String password;
  String birthday;
  List<String> roles;

  Customer(String name, String email, String password, String birthday){
    this.name = name;
//    this.cpf = cpf;
    this.email = email;
    this.password = password;
    this.birthday = birthday;
  }


  Customer.fromJson(Map<String, dynamic> json) {
    name =     json['name'];
    cpf =      json['cpf'];
    email =    json['email'];
    password = json['password'];
    birthday = json['Birthday'];
//    roles = json['roles'] != null ? json['roles'].cast<String>() : null;
  }
}