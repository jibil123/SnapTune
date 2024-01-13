import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecord extends StatefulWidget {
  const AudioRecord({super.key});

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {

  late Record audiorecord;
  late AudioPlayer audioPlay;

  bool isRecording=false;
  String audioPath='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audiorecord = Record();
    audioPlay=AudioPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audiorecord.dispose();
  }

  void startRecording()async{
    try{
      if(await audiorecord.hasPermission()){
        await audiorecord.start();
        setState(() {
          isRecording=true;
        });
      }
    } catch(e){
      print('error for start recording $e');
    }
  }

  void stopRecording()async{
    try{
      String? path = await audiorecord.stop();
      setState(() {
        isRecording=false;
        audioPath = path!;
      });
    }
    catch(e){
      print('error for start recording $e');
    }
  }

  Future<void> playAduioRecorded()async{
    try{
      if(audioPath.isNotEmpty){
        print('song is recorded');
      }
      Source urlSource = UrlSource(audioPath);
      await audioPlay.play(urlSource);
    }
    catch(e){
      print('error for play record $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Audio Recording'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.orange,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    isRecording? stopRecording():startRecording();
                  },
                  icon:isRecording? Icon(Icons.pause) :Icon(Icons.play_arrow),
                  label:isRecording? Text('stop Recording'): Text('Start Recording'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
              height: double.infinity,
              width: double.infinity ,
              child: Column(
                children: [
                ElevatedButton(onPressed: (){
                  playAduioRecorded();
                }, child: Text('play record')),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
