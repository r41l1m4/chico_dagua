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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 150.0),
        child: Form(
          key: _formKey2,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  "Qual é vazão do seu gotejador?",
                  style: TextStyle(
                    fontSize: 23.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                child: TextFormField(
                  controller: vazController,
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
                    suffix: Text("l/h"),
                    labelText: "Digite aqui",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  "Qual é o espaçamento:",
                  style: TextStyle(
                    fontSize: 23.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                child: TextFormField(
                  controller: espGotController,
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
                    suffix: Text("cm"),
                    labelText: "Entre os gotejadores?",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                child: TextFormField(
                  controller: espLinController,
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
                    suffix: Text("cm"),
                    labelText: "Entre as linhas?",
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
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
    );
  }
}
