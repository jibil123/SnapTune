import 'package:flutter/material.dart';
import 'package:snaptune/db/model.dart';

class songModelProvider with ChangeNotifier{

  int _id=0;
  int get id => _id;
  
    void setId(int id){
      _id =id;
    }

  void updateCurrentSong(MusicModel findmusic) {}

}