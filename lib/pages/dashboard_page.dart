import 'package:flutter/material.dart';
import 'package:here/pages/graficos_page.dart';
import 'package:here/pages/graficosdash_page.dart';
import 'package:here/utils/nav.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.blue[100],

drawer: new Drawer(
  child: ListView(
    children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: new Text('Usuario', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
        accountEmail: new Text('admin@admin.com'),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRRe-E4rqR6LMzLi2KSkXRGZOUUGhwaY0gXoa_5OibXvVrDvG5C&usqp=CAU'),
        ),
        decoration: new BoxDecoration(color: Colors.blue[700]),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Perfil'),
      ),
      ListTile(
        leading: Icon(Icons.vpn_key),
        title: Text('Senha'),
      ),
      ListTile(
        leading: Icon(Icons.info),
        title: Text('Informação'),
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sair'),
      ),
    ],
  ),
),

      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            MyMenu(title: 'Ocorrencias', icon: Icons.account_balance, warna: Colors.brown,),
            MyMenu(title: 'Informação', icon: Icons.info_outline, warna: Colors.green,),
            MyMenu(title: 'Educação', icon: Icons.school, warna: Colors.orange,),
            MyMenu(title: 'Perfil', icon: Icons.person_pin, warna: Colors.blueGrey,),
            MyMenu(title: 'Livro', icon: Icons.local_library, warna: Colors.red,),
            MyMenu(title: 'Documentos', icon: Icons.library_books, warna: Colors.teal,),
          ],
        ),
      ),
    );
  }
}

Future<void> _onClickCard(context,title) async {
  if(title == 'Ocorrencias'){
   push(context, GraficosPage());
   }
   else if(title == 'Perfil'){
   push(context, GraficosDashPage());
   }
}

class MyMenu extends StatelessWidget {
  MyMenu({this.title, this.icon, this.warna});

final String title;
final IconData icon;
final MaterialColor warna;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _onClickCard(context,title);
        },
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 70.0,
                color: warna,
              ),
              Text(title, style: new TextStyle(fontSize: 17.0))
            ],
          ),
        ),
      ),
    );
  }
}
