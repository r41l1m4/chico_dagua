import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

///Modelo respónsavel por manter, durante a sessão os dados básicos do usuário,
///aqueles que foram inseridos no primeiro uso do app, que são usados para os cálculos
///e para definir quem é o usuário.
class SessionModel extends Model {
  bool _hasCity = false;
  int _cityId = 0;

  String _city = "";
  String _state = "";
  double _lat = 0.0;

  int _cultId = 0;
  double _Ep = 0.0;

  double _q = 0.0;
  double _Eem = 0.0;
  double _El = 0.0;

  SessionModel();

  ///Responsável por preencher os dados que o usuário inseriu no primeiro uso, e
  ///que estão salvos no arquivo no aparelho.
  SessionModel.init(this._hasCity, this._cityId, this._city, this._state,
      this._lat, this._cultId, this._Ep, this._q, this._Eem, this._El);

  ///Necessário para que consigamos acessar o modelo a partir do contexto.
  static SessionModel of(BuildContext context) =>
      ScopedModel.of<SessionModel>(context);

  ///Retorna um booleano para se a cidade já foi definada.
  bool get hasCity => _hasCity;

  ///Define o status de definição da cidade.
  void setCityState(bool value) {
    _hasCity = value;
    notifyListeners();
  }

  ///Retorna um inteiro com Id da cidade (entre a que tem os coeficientes calibrados).
  int get cityId => _cityId;

  ///Define o Id da cidade.
  void setCityId(int value) {
    _cityId = value;
    notifyListeners();
  }

  ///Retorna um double com o espaçamento entre as linhas.
  double get El => _El;

  ///Retorna um String com o nome da cidade.
  String get city => _city;

  ///Define o nome da cidade.
  void setCity(String cityName) {
    _city = cityName;
    notifyListeners();
  }

  ///Retorna uma String com o nome do estado ao qual pertence o municipio que o
  ///usuário se encontra.
  String get state => _state;

  ///Define o estado onde se encontra o usuário.
  void setState(String stateName) {
    _state = stateName;
    notifyListeners();
  }

  ///Retorna um double com a latitude da localização do usuário.
  double get lat => _lat;

  ///Define a latitude da localização do usuário.
  void setLat(double lat) {
    _lat = lat;
    notifyListeners();
  }

  ///Define o espaçamento entre as linhas.
  void setEl(double value) {
    _El = value;
    notifyListeners();
  }

  ///Retorna um double com o espaçamento entre os gotejadores.
  double get Eem => _Eem;

  ///Define o espaçamento entre os gotejadores.
  void setEem(double value) {
    _Eem = value;
    notifyListeners();
  }

  ///Retorna um double com a vazão do gotejador.
  double get q => _q;

  ///Define a vazão do gotejador,
  void setq(double value) {
    _q = value;
    notifyListeners();
  }

  ///Retorna um double com o espaçamento entre as plantas.
  double get Ep => _Ep;

  ///Define o espaçamento entre as plantas.
  void setEp(double value) {
    _Ep = value;
    notifyListeners();
  }

  ///Retorna um int com o Id da cultura.
  int get cultId => _cultId;

  ///Define o Id da cultura.
  void setCultId(int value) {
    _cultId = value;
    notifyListeners();
  }

  ///Retorna um lista com os dados estruturados em formato de mapa, para que possam
  ///ser armazenados em JSON no aparelho.
  List toList() {
    List dataList = List();

    Map<String, dynamic> mapRoot = Map();
    Map<String, dynamic> mapCity = Map();
    Map<String, dynamic> mapCult = Map();
    Map<String, dynamic> mapIrrig = Map();
    mapRoot["\"hasCity\""] = hasCity;

    mapCity["\"cityId\""] = cityId;
    mapCity["\"cityName\""] = city;
    mapCity["\"stateName\""] = state;
    mapCity["\"latitude\""] = lat;
    mapRoot["\"city\""] = mapCity;

    mapCult["\"cultId\""] = _cultId;
    mapCult["\"Ep\""] = Ep;
    mapRoot["\"cult\""] = mapCult;

    mapIrrig["\"q\""] = q;
    mapIrrig["\"Eem\""] = Eem;
    mapIrrig["\"El\""] = El;
    mapRoot["\"irrig\""] = mapIrrig;

    dataList.add(mapRoot);

    return dataList;
  }
}
