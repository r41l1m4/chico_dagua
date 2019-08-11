import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:flutter/material.dart';

class IrrQuery extends StatefulWidget {
  @override
  _IrrQueryState createState() => _IrrQueryState();
}

class _IrrQueryState extends State<IrrQuery> {
  static String dropdownValue;
  static final DataStuff ds = DataStuff();

  TextEditingController vazController = TextEditingController();
  TextEditingController espGotController = TextEditingController();
  TextEditingController espLinController = TextEditingController();

  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 150.0),
          child: Form(
            key: _formKey2,
            child: Column(
              children: <Widget>[
                _tempQuestionBox("Qual é vazão do seu gotejador?"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                  child: _tempInputBox("Digite aqui", "l/h", vazController),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _tempQuestionBox("Qual é o espaçamento:"),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: _tempInputBox("Entre os gotejadores?", "cm", espGotController),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: _tempInputBox("Entre as linhas?", "cm", espLinController),
                ),
                SizedBox(
                  height: 30.0,
                ),
                IconButton(
                  highlightColor: Colors.lightBlueAccent[400],
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    if(_formKey2.currentState.validate()) {
                      SessionModel.of(context).setq(double.parse(vazController.text));
                      SessionModel.of(context).setEem(double.parse(espGotController.text));
                      SessionModel.of(context).setEl(double.parse(espLinController.text));
                      ds.saveData(SessionModel.of(context).toList());
                      Navigator.pushNamedAndRemoveUntil(context, "/", ModalRoute.withName("/"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tempInputBox(label, suffix, controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if(value.isEmpty) {
          return "Campo obrigatório!";
        }else if(value.contains(",")) {
          return "Decimais com \"ponto\"!";
        }
        return null;
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffix: Text("$suffix"),
        labelText: "$label",
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.0,
      ),
    );
  }

  Widget _tempQuestionBox(question) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
        "$question",
        style: TextStyle(
          fontSize: 23.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
