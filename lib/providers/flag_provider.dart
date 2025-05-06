import 'package:flutter/cupertino.dart';

class FlagProvider extends ChangeNotifier{

  bool _isLoading = false;
  bool _isVisible = false;
  String _searchQuery = "";

  bool get isLoading => _isLoading;
  bool get isVisible => _isVisible;
  String get searchQuery => _searchQuery;

  void toggleLoading(){
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void toggleVisibility(){
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void updateSearchQuery(String newText){
    _searchQuery = newText.toLowerCase();
    notifyListeners();
  }

}