import 'package:flutter/material.dart';
import 'package:here/APIs/ocorrenciaAPI.dart';
import 'package:here/main.dart';
import 'package:here/model/ocorrencia.dart';
import 'package:here/pages/ListOcorrencia_page.dart';
import 'package:here/pages/graficos_page.dart';
import 'package:here/pages/graficosdash_page.dart';
import 'package:here/pages/graficos_dash_homicidios.dart';
import 'package:here/utils/nav.dart';
import 'package:here/pages/Cadastro.dart';
import 'package:here/pages/login_page.dart';
import 'package:here/pages/ocorrencia_page.dart';
import 'package:here/widgets/PageRouteAnimation.dart';

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
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color(0XFF3F51b5),
      ),
      backgroundColor: Colors.blue[100],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                'Usuario',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              accountEmail: Text('admin@admin.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRRe-E4rqR6LMzLi2KSkXRGZOUUGhwaY0gXoa_5OibXvVrDvG5C&usqp=CAU'),
              ),
              decoration: BoxDecoration(color: Colors.black12),
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
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            //MyMenu(title: 'Documentos', icon: Icons.create, warna: Colors.teal,),
            MyMenu(
              title: 'Ocorrências',
              icon: Icons.insert_drive_file,
              warna: Colors.blueGrey,
            ),
            //MyMenu(title: 'Informação', icon: Icons.info_outline, warna: Colors.green,),
            //MyMenu(title: 'Educação', icon: Icons.school, warna: Colors.orange,),
            MyMenu1(
              title: 'Gráficos',
              icon: Icons.insert_chart,
              warna: Colors.orange,
            ),
            //MyMenu(title: 'Livro', icon: Icons.local_library, warna: Colors.red,),
            MyMenu2(
              title: 'Gráficos Homicídio',
              icon: Icons.insert_chart,
              warna: Colors.orange,
            ),
            //MyMenu(title: 'Livro', icon: Icons.local_library, warna: Colors.red,),
          ],
        ),
      ),
    );
  }
}

Future<void> _onClickCard(context, title) async {
  if (title == 'Ocorrências') {
    await push(context, ListOcorrencia());
  } else if (title == 'Gráficos') {
    await push(context, GraficosDashPage());
  } else if (title == 'Gráficos Homicídio') {
    await push(context, GraficosDashPageHomicidios());
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
          Navigator.push(context, PageRouteAnimation(widget: ListOcorrencia()));
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
              Text(title, style: TextStyle(fontSize: 17.0))
            ],
          ),
        ),
      ),
    );
  }
}

class MyMenu1 extends StatelessWidget {
  MyMenu1({this.title, this.icon, this.warna});

  final String title;
  final IconData icon;
  final MaterialColor warna;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, PageRouteAnimation(widget: GraficosDashPage()));
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
              Text(title, style: TextStyle(fontSize: 17.0))
            ],
          ),
        ),
      ),
    );
  }
}

class MyMenu2 extends StatelessWidget {
  MyMenu2({this.title, this.icon, this.warna});

  final String title;
  final IconData icon;
  final MaterialColor warna;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              PageRouteAnimation(widget: GraficosDashPageHomicidios()));
        },
        splashColor: Colors.blue,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 70.0,
                color: Colors.red,
              ),
              Center(child: Text(title, style: TextStyle(fontSize: 15.0)))
            ],
          ),
        ),
      ),
    );
  }
}
