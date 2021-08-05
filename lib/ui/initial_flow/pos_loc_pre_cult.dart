import 'package:chico_dagua/ui/initial_flow/cult_query.dart';
import 'package:flutter/material.dart';

/// Responsável por confirmar a coleta da localização para o usuário, e introduzir
/// os próximos passos.
class PosLocPreCult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Ótimo...",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Agora, precisamos de algumas informações sobre "
                  "a sua cultura e seus equipamentos.",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
              //textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          OutlinedButton(
            key: const Key('posLocPerm'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => CultQuery()
                  ));
            },
            child: Text(
              "Avançar",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              side: BorderSide(
                width: 0.2,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
