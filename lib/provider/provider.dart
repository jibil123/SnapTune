import 'package:flutter/material.dart';
import 'package:snaptune/db/songmodel/model.dart';

class SongModelProvider with ChangeNotifier{

  int _id=0;
  int get id => _id;
  
    void setId(int id){
      _id =id;
    }

  void updateCurrentSong(MusicModel findmusic) {}

}