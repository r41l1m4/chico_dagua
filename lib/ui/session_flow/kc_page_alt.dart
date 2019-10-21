import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/session_flow/result_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// Classe alternativa para o cálculo do Kc, acionada quando a cultura é definida
/// como sendo "Outra", aqui não há opção de seleção para fase da cultura, só há a
/// entrada de um velho e seco Kc.
class KcPageAlt extends StatefulWidget {
  @override
  _KcPageAltState createState() => _KcPageAltState();
}

class _KcPageAltState extends State<KcPageAlt> {
  static DataStuff ds = DataStuff();
  static String dropdownValue;

  TextEditingController altKcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(top: 40.0, left: 15.0),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  alignment: Alignment.topLeft,
                ),
                Container(
                  padding: EdgeInsets.only(top: 40.0, right: 10.0),
                  alignment: Alignment.topRight,
                  child: Text(
                    SessionModel.of(context).city,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 550.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                    child: Text(
                      "Agora, digite o Kc da cultura.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 100.0),
                    child: TextFormField(
                      controller: altKcController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obrigatório!";
                        }
                        return null;
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Kc",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ScopedModelDescendant<FlowModel>(
                    builder: (context, child, model) {
                      return OutlineButton(
                        onPressed: () {
                          if (altKcController.text.contains(",")) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.lightBlueAccent[400],
                                    title: Text("Erro!"),
                                    content: Text(
                                      "Decimais devem ser separados por \"ponto\".",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                          } else {
                            double kc = double.parse(altKcController.text);
                            double etc = getETc(model.et0, kc);
                            model.setEtc(etc);
                            model.setStage("Kc Manual");
                            return Navigator.pushReplacement(
                                context,
                                //Define a animação de transição entre as telas.
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondAnimation) =>
                                      ResultPage(),
                                  transitionDuration: Duration(milliseconds: 400),
                                  transitionsBuilder:
                                      (context, animation, secondAnimation, child) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var tween = Tween(begin: begin, end: end);
                                    var offsetAnimation = animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ));
                          }
                        },
                        child: Text("Calcular"),
                        splashColor: Colors.white,
                        highlightColor: Colors.lightBlueAccent[400],
                        shape: StadiumBorder(),
                        borderSide: BorderSide(width: 0.2),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Dado o ETo e o Kc da cultura, retorna o ETc.
  double getETc(double eto, double kc) {
    double etc = eto * kc;
    double etc2 = double.parse(etc.toStringAsPrecision(3));
    return etc2;
  }
}
