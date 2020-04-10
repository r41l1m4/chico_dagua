import 'dart:convert';

import 'package:chico_dagua/aux/data_stuff.dart';
import 'package:chico_dagua/model/session_model.dart';
import 'package:flutter/material.dart';

/// Responsável pela coleta dos dados da irrigação do usuário.
class IrrQuery extends StatefulWidget {
  @override
  _IrrQueryState createState() => _IrrQueryState();
}

/// Responsável pela coleta dos dados da irrigação do usuário.
class _IrrQueryState extends State<IrrQuery> {
  static String dropdownValue;

  TextEditingController vazController = TextEditingController();
  TextEditingController espGotController = TextEditingController();
  TextEditingController espLinController = TextEditingController();

  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: DataStuff().readData(),
      builder: (context, snapshot) {
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

                          //Se há culturas já cadastradas no JSON
                          if(snapshot.data.length > 2 && (snapshot.data.isNotEmpty || snapshot.data != null)) {
                            //Transforma o arquivo já existente em um lista
                            List cult = json.decode(snapshot.data);
                            //Adiciona os dados da nova cultura, que está em formato de lista
                            //ao fim da lista geral
                            cult.addAll(SessionModel.of(context).toList());
                            //E por fim salva a lista completa com a a nova adição
                            DataStuff().saveData(cult);
                          }else {
                            //Se não há culturas já cadastradas, simplesmente salva a
                            //lista com a cultura no arquivo principal.
                            DataStuff().saveData(SessionModel.of(context).toList());
                          }
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
      },
    );
  }

  ///Retorna um campo de entrada de texto baseado nos parâmetros, que são uma legenda
  ///para a caixa de texto, um sufixo (se estiver sendo capturado uma temperatura, será
  ///o "ºC" da visualização), e um controlador para o campo de texto.
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

  ///Retorna um texto com a legenda (normalmente, uma pergunta)
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
