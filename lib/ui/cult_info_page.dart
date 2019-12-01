import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:flutter/material.dart';

class CultInfoPage extends StatelessWidget {

  static final ds = DataStuff();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informação da Cultura",
          style: TextStyle(fontFamily: "Comfortaa"),
        ),
        backgroundColor: Colors.lightBlueAccent[400],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _infoTitle("Cultura", 40.0),
              _infoContent(ds.getCultName(SessionModel.of(context).cultId), 50.0),
              SizedBox(
                height: 20.0,
              ),
              _infoTitle("Local", 30.0),
              _infoContent("${SessionModel.of(context).city} - ${SessionModel.of(context).state}", 20.0),
              SizedBox(
                height: 15.0,
              ),
              _infoTitle("Vazão do Equipamento", 30.0),
              _infoContent("${SessionModel.of(context).q} l/h", 20.0),
              SizedBox(
                height: 15.0,
              ),
              _infoTitle("Espaçamentos", 30.0),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Plantas", 20.0),
              _infoContent("${SessionModel.of(context).Ep} cm", 20.0),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Gotejadores", 20.0),
              _infoContent("${SessionModel.of(context).Eem} cm", 20.0),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Linhas", 20.0),
              _infoContent("${SessionModel.of(context).El} cm", 20.0),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget _infoTitle(title, fontSize) {
    return Text(
      "$title:",
      style: TextStyle(
          color: Colors.lightBlueAccent[400],
          fontSize: fontSize,
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _infoContent(title, fontSize) {
    return Text(
      "$title",
      style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w700
      ),
    );
  }
}
