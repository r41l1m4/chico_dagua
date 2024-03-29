import 'package:chico_dagua/model/session_model.dart';
import 'package:flutter/material.dart';

/// Responsável pela tela de informação da cultura atual.
class CultInfoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informação da Cultura"
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _infoTitle("Cultura", 40.0, context),
              _infoContent(SessionModel.of(context).cultName, 50.0, context),
              SizedBox(
                height: 20.0,
              ),
              _infoTitle("Local", 30.0, context),
              _infoContent("${SessionModel.of(context).city} - ${SessionModel.of(context).state}", 20.0, context),
              SizedBox(
                height: 15.0,
              ),
              _infoTitle("Vazão do Equipamento", 30.0, context),
              _infoContent("${SessionModel.of(context).q} l/h", 20.0, context),
              SizedBox(
                height: 15.0,
              ),
              _infoTitle("Espaçamentos", 30.0, context),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Plantas", 20.0, context),
              _infoContent("${SessionModel.of(context).Ep} cm", 20.0, context),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Gotejadores", 20.0, context),
              _infoContent("${SessionModel.of(context).Eem} cm", 20.0, context),
              SizedBox(
                height: 10.0,
              ),
              _infoTitle("Entre Linhas", 20.0, context),
              _infoContent("${SessionModel.of(context).El} cm", 20.0, context),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        )
      ),
    );
  }

  /// Retorna um Widget "Text" com o titulo da informação, numa determinada
  ///  formatação.
  Widget _infoTitle(title, fontSize, context) {
    return Text(
      "$title:",
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold
      ),
    );
  }

  /// Retorna um Widget "Text" com o conteudo da informação, numa determinada
  ///   formatação.
  Widget _infoContent(title, fontSize, context) {
    return Text(
      "$title",
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w700
      ),
    );
  }
}
