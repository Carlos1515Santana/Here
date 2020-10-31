class Customer{
  String name;
  String cpf;
  String email;
  String password;
  String birthday;
  String userName;
  List<String> roles;

  Customer(String name, String email, String password, String birthday, String userName, String cpf){
    this.name = name;
    this.cpf = cpf;
    this.email = email;
    this.userName = userName;
    this.password = password;
    this.birthday = birthday;
  }


  Customer.fromJson(Map<String, dynamic> json) {
    name =     json['name'];
    cpf =      json['cpf'];
    email =    json['email'];
    password = json['password'];
    userName = json['userName'];
    birthday = json['Birthday'];
//    roles = json['roles'] != null ? json['roles'].cast<String>() : null;
  }
}