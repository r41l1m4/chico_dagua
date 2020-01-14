import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


///Modelo responsável por armazenar, durante a sessão de consulta, os valores
///temporários de alguns parâmetros que são gerados durante a sessão.
class FlowModel extends Model {
  double _et0 = 0.0;
  double _etc = 0.0;
  String _stage = "";
  double _tempMax = 0.0;
  double _tempMin = 0.0;

  FlowModel();

  ///Possibilita acesso ao Model partir do contexto.
  static FlowModel of(BuildContext context) => ScopedModel.of<FlowModel>(context);

  ///Retorna uma String com o estágio em que se encontra a cultura.
  String get stage => _stage;

  ///Define um novo estágio para a cultura, e notifica aos listeners da mudança.
  void setStage(String value) {
    _stage = value;
    notifyListeners();
  }

  ///Retorna um double com o etc da cultura.
  double get etc => _etc;

  ///Define o etc da cultura, e notifica aos listeners da mudança.
  void setEtc(double value) {
    _etc = value;
    notifyListeners();
  }

  ///Retorna um double com o ETo da cultura.
  double get et0 => _et0;

  ///Define o ETo da cultura, e notifica aos listeners da mudança.
  void setEt0(double value) {
    _et0 = value;
    notifyListeners();
  }

  double get tempMax => _tempMax;

  ///Define a temperatura máxima informada pelo usuário, e notifica aos listeners da mudança.
  void setTempMax(double value) {
    _tempMax = value;
    notifyListeners();
  }

  double get tempMin => _tempMin;

  ///Define a temperatura miníma informada pelo usuário, e notifica aos listeners da mudança.
  void setTempMin(double value) {
    _tempMin = value;
    notifyListeners();
  }

}