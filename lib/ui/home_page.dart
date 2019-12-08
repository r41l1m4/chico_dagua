import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/cult_info_page.dart';
import 'package:chico_dagua/ui/history_page.dart';
import 'package:chico_dagua/ui/initial_flow/loc_perm_page.dart';
import 'package:chico_dagua/ui/work_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static final DataStuff  ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Comfortaa",),
      home: Scaffold(
          drawer: Drawer(
            child: contextMenu(),
            elevation: 30.0,
          ),
          appBar: AppBar(
            title: ScopedModelDescendant<SessionModel>(
              rebuildOnChange: true,
              builder: (context, child, model) {
                return Text(
                  "Chico d'Água",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.lightBlueAccent[400],
            elevation: 50.0,
          ),
          body: WorkPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Responsável pelo menu de contexto na página inicial do app.
  Widget contextMenu() {
    return ScopedModelDescendant<SessionModel>(
      builder: (context, child, model) {
        return Container(
          color: Colors.lightBlueAccent[400],
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 17.0, right: 8.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 38.0, bottom: 20.0),
                    child: ScopedModelDescendant<SessionModel>(
                      builder: (context, child, model) {
                        return Text("${model.city}", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),);
                      },
                    ),
                  ),
                ],
              ),
              _contextMenuTiles("Mudar dados", context, LocPermPage()),
              _contextMenuTiles("Histórico", context, HistoryPage()),
              _contextMenuTiles("Info. da Cultura", context, CultInfoPage()),
              Divider(
                color: Colors.white70,
                height: 2.0,
              ),
              ListTile(
                  title: Text("Sobre", style: TextStyle(
                    color: Colors.white,
                  ),),
                  onTap: () {
                    Navigator.pop(context);
                    _aboutInfo();
                  }
              ),
            ],
          ),
        );
      },
    );
  }

  ///Retorna um Widget com uma Tile para o menu de contexto, baseada em determinados
  ///parêmetros.
  Widget _contextMenuTiles(String title, BuildContext context, Widget newPage) {
    return ListTile(
      title: Text("$title", style: TextStyle(
        color: Colors.white,
      ),),
      onTap: () {
        Navigator.pop(context);
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => newPage
            )
        );
      },
    );
  }

  ///Retorna a tela com o "Sobre" do app.
  void _aboutInfo() {
    return showAboutDialog(
      context: context,
      applicationName: "Chico d'Água",
      applicationVersion: "v1.2.2",
      applicationIcon: Image.asset("imgs/cda.png", height: 55.0, width: 55.0,),
      children: <Widget>[
        Text("Este app é parte resultante do projeto de extensão \"Chico d'Água\" "
            "desenvolvido na Universidade Federal de Alagoas (UFAL) - "
            "Campus Arapiraca.",
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}