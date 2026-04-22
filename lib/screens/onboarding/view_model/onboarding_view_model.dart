import 'package:flutter/cupertino.dart';

class OnBoardingViewModel extends ChangeNotifier {
  
  final PageController _controller = PageController();
  bool _isLastPage = false;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  PageController get controller => _controller;
  bool get isLastPage => _isLastPage;

  void setPage(int index) {
    _isLastPage = index == 2;
    _currentIndex = index;
    notifyListeners();
  }

}
