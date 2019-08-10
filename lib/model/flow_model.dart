import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FlowModel extends Model {
  double _et0 = 0.0;
  double _etc = 0.0;
  String _stage = "";

  FlowModel();

  static FlowModel of(BuildContext context) => ScopedModel.of<FlowModel>(context);

  String get stage => _stage;

  void setStage(String value) {
    _stage = value;
    notifyListeners();
  }

  double get etc => _etc;

  void setEtc(double value) {
    _etc = value;
    notifyListeners();
  }

  double get et0 => _et0;

  void setEt0(double value) {
    _et0 = value;
    notifyListeners();
  }


}