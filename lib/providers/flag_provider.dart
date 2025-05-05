import 'package:flutter/cupertino.dart';

class FlagProvider extends ChangeNotifier{

  bool _isLoading = false;
  bool _isVisible = false;

  bool get isLoading => _isLoading;
  bool get isVisible => _isVisible;

  void toggleLoading(){
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void toggleVisibility(){
    _isVisible = !_isVisible;
    notifyListeners();
  }


}