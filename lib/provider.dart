import 'package:flutter/material.dart';

class TextProvider extends ChangeNotifier
{
  String shortLink='';
  void changeLink(String link)
  {
    shortLink=link;
    notifyListeners();
  }
}