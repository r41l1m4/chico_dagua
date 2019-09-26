import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/irr_query.dart';
import 'package:flutter/material.dart';

class CultQuery extends StatefulWidget {
  @override
  _CultQueryState createState() => _CultQueryState();
}

class _CultQueryState extends State<CultQuery> {
  static String dropdownValue;
  static final DataStuff ds = DataStuff();

  TextEditingController espCultController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _tempQuestionBox("Qual é a sua cultura?"),
              Container(
                child: DropdownButton<String>(
                  iconEnabledColor: Colors.grey,
                  hint: Text("Selecione"),
                  iconSize: 30.0,
                  value: dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: ds
                      .getCultKeys()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              _tempQuestionBox("Qual é o espaçamento entre as plantas?"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Form(
                  key: _formKey,
                    child: TextFormField(
                      controller: espCultController,
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
                        labelText: "Digite aqui",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.black),
                        //border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              IconButton(
                highlightColor: Colors.lightBlueAccent[400],
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if(dropdownValue == null) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            backgroundColor: Colors.lightBlueAccent[400],
                            title: Text("Erro!"),
                            content: Text("Selecione a sua cultura.",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          );
                        }
                    );
                  }else if(_formKey.currentState.validate()) {
                    SessionModel.of(context).setCultId(ds.getCultId(dropdownValue));
                    SessionModel.of(context).setEp(double.parse(espCultController.text));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new IrrQuery()
                        )
                    );
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
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
