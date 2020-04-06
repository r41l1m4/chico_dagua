import 'package:chico_dagua/ui/initial_flow/loc_perm_page.dart';
import 'package:flutter/material.dart';

/// Responsável pela primeira tela do aplicativo na coleta de dados da cultura.
class FirstUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Olá.",
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Bem vindo ao Chico d'Água.",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                //alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Antes de começarmos, é necessário que você nos ceda algumas informações "
                      "sobre onde você está, e sobre a sua cultura.",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: Text(
                      "Clique no botão abaixo para começar.",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              IconButton(
                highlightColor: Colors.lightBlueAccent[400],
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LocPermPage())
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
