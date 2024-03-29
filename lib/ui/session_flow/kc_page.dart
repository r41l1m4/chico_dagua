import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/flow_model.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:chico_dagua/ui/session_flow/result_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// Responsável pela tela de seleção de Kc da cultura e efetua o cálculo de ETc.
class   KcPage extends StatefulWidget {
  @override
  _KcPageState createState() => _KcPageState();
}

/// Responsável pela tela de seleção de Kc da cultura e efetua o cálculo de ETc.
class _KcPageState extends State<KcPage> {
  static DataStuff ds = DataStuff();
  static String dropdownValue = "Inicial";

  TextEditingController kcController = TextEditingController();

  bool manualKc = false;

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
                  padding: EdgeInsets.only(top: 50.0),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SessionModel.of(context).cultName,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        SessionModel.of(context).city,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
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
                      "Agora, selecione a fase em que se encontra a sua cultura.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: DropdownButton<String>(
                      key: const Key("dropdownKc"),
                      iconEnabledColor: Colors.grey,
                      hint: Text("Selecione"),
                      iconSize: 30.0,
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: ds
                          .getStageKeys()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                                    key: Key("dropItem_${value}_text"),),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        key: const Key("manualKcCheck"),
                        value: manualKc,
                        checkColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (value) {
                          setState(() {
                            manualKc = value!;
                          });
                        },
                      ),
                      Text("Quero digitar o Kc da cultura.")
                    ],
                  ),
                  //Define se o campo para entrada do Kc está oculto ou não.
                  AnimatedOpacity(
                    opacity: manualKc ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.0),
                      child: TextFormField(
                        key: const Key("manualKcForm"),
                        controller: kcController,
                        enabled: manualKc,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Campo obrigatório!";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Kc",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ScopedModelDescendant<FlowModel>(
                    builder: (context, child, model) {
                      return OutlinedButton(
                        key: const Key("kcFormButton"),
                        onPressed: () {
                          if ((dropdownValue == null && !manualKc) ||
                              (manualKc && kcController.text.isEmpty)) {
                            //TODO: verificar se a retirada do return demonstra problemas
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    title: Text("Erro!"),
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay',
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                    content: Text(
                                      "Todos os campos são obrigatórios.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                            return null;
                          } else if ((manualKc &&
                              kcController.text.contains(","))) {
                            //TODO: verificar se a retirada do return demonstra problemas
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    title: Text("Erro!"),
                                    actions: [
                                      TextButton(
                                        child: const Text('Okay',
                                          style: TextStyle(
                                              color: Colors.black
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                    content: Text(
                                      "Decimais devem ser separados por \"ponto\".",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                });
                            return null;
                          } else {
                            int cultId = ScopedModel.of<SessionModel>(context).cultId;
                            //Caso seja escolhido entrar manualmente com o Kc, pega o número
                            //do campo de texto, caso não, verifica qual o Kc padrão da cultura.
                            double kc = manualKc
                                ? double.parse(kcController.text)
                                : ds.getCultKc(
                                cultId, ds.getStageId(dropdownValue)!);
                            model.setKc(kc);
                            double etc = getETc(model.et0, model.kc);
                            model.setEtc(etc);
                            model.setStage(dropdownValue ?? "Kc Manual");
                            //TODO: verificar se a retirada do return demonstra problemas
                            Navigator.pushReplacement(
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
                            return null;
                          }
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: StadiumBorder(),
                          side: BorderSide(
                              width: 0.2,
                              color: Theme.of(context).accentColor
                          ),
                        ),
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
