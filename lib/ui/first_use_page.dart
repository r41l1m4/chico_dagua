import 'package:flutter/material.dart';

class FirstUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                //padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  "Olá.",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                //padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Antes de começarmos, é necessário que você nos ceda algumas informações"
                      "sobre onde você está, e sobre a sua cultura. \n"
                      "Clique no botão abaixo para começar.",
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                highlightColor: Colors.lightBlueAccent[400],
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
