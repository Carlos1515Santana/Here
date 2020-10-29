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
  String rg;
  String email;
  String password;
  String birthday;
  String userName;
  List<String> roles;

  Customer(String name, String email, String password, String birthday, String userName, String cpf, String rg){
    this.name = name;
    this.cpf = cpf;
    this.rg = rg;
    this.email = email;
    this.userName = userName;
    this.password = password;
    this.birthday = birthday;
  }


  Customer.fromJson(Map<String, dynamic> json) {
    name =     json['name'];
    cpf =      json['cpf'];
    rg =      json['rg'];
    email =    json['email'];
    password = json['password'];
    userName = json['userName'];
    birthday = json['Birthday'];
//    roles = json['roles'] != null ? json['roles'].cast<String>() : null;
  }
}