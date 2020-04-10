import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/initial_flow/irr_query.dart';
import 'package:flutter/material.dart';

/// Responsável por coletar os dados da cultura.
class CultQuery extends StatefulWidget {
  @override
  _CultQueryState createState() => _CultQueryState();
}

/// Responsável por coletar os dados da cultura.
class _CultQueryState extends State<CultQuery> {
  static String dropdownValue;

  TextEditingController espCultController = TextEditingController();
  TextEditingController otherCultController = TextEditingController();

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
                  items: DataStuff()
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
                height: 10.0,
              ),
              AnimatedOpacity(
                opacity: dropdownValue == "Outra" ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 100.0),
                  child: TextFormField(
                    controller: otherCultController,
                    enabled: dropdownValue == "Outra",
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Campo obrigatório!";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Nome da cultura",
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
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
                    if(dropdownValue == "Outra") {
                      SessionModel.of(context).setCultName(otherCultController.text);
                      SessionModel.of(context).setCultId(25);
                    } else {
                      SessionModel.of(context).setCultName(dropdownValue);
                      SessionModel.of(context).setCultId(DataStuff().getCultId(dropdownValue));
                    }
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

  ///Retorna um campo de entrada de texto com a legenda (normalmente, uma pergunta)
  ///que foi passada por parâmetro.
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
