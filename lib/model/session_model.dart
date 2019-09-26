import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SessionModel extends Model {
  bool _hasCity = false;
  int _cityId = 0;

  String _city = "";
  String _state = "";
  double _long = 0.0;

  int _cultId = 0;
  double _Ep = 0.0;

  double _q = 0.0;
  double _Eem = 0.0;
  double _El = 0.0;

  SessionModel();

  SessionModel.init(this._hasCity, this._cityId, this._city, this._state,
      this._long, this._cultId, this._Ep, this._q, this._Eem, this._El);

  static SessionModel of(BuildContext context) =>
      ScopedModel.of<SessionModel>(context);

  bool get hasCity => _hasCity;

  void setCityState(bool value) {
    _hasCity = value;
    notifyListeners();
  }

  int get cityId => _cityId;

  void setCityId(int value) {
    _cityId = value;
    notifyListeners();
  }

  double get El => _El;

  String get city => _city;

  void setCity(String cityName) {
    _city = cityName;
    notifyListeners();
  }

  String get state => _state;

  void setState(String stateName) {
    _state = stateName;
    notifyListeners();
  }

  double get long => _long;

  void setLong(double long) {
    _long = long;
    notifyListeners();
  }

  void setEl(double value) {
    _El = value;
    notifyListeners();
  }

  double get Eem => _Eem;

  void setEem(double value) {
    _Eem = value;
    notifyListeners();
  }

  double get q => _q;

  void setq(double value) {
    _q = value;
    notifyListeners();
  }

  double get Ep => _Ep;

  void setEp(double value) {
    _Ep = value;
    notifyListeners();
  }

  int get cultId => _cultId;

  void setCultId(int value) {
    _cultId = value;
    notifyListeners();
  }

  List toList() {
    List dataList = List();

    Map<String, dynamic> mapRoot = Map();
    Map<String, dynamic> mapCity = Map();
    Map<String, dynamic> mapCult = Map();
    Map<String, dynamic> mapIrrig = Map();
    mapRoot["\"hasCity\""] = hasCity;

    mapCity["\"cityId\""] = cityId;
    mapCity["\"cityName\""] = city;
    mapCity["\"cityName\""] = state;
    mapCity["\"longitude\""] = long;
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
