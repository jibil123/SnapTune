import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecord extends StatefulWidget {
  const AudioRecord({Key? key}) : super(key: key);

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  late Record audiorecord;
  late AudioPlayer audioPlay;
  late Duration recordingDuration;
  late DateTime startTime;
  late Timer timer;

  bool isRecording = false;
  bool isPaused = false;
  String audioPath = '';

  @override
  void initState() {
    super.initState();
    audiorecord = Record();
    audioPlay = AudioPlayer();
    recordingDuration = Duration(seconds: 0);
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer timer) {
      if (isRecording || isPaused) {
        setState(() {
          recordingDuration = DateTime.now().difference(startTime);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    audiorecord.dispose();
    audioPlay.dispose();
  }

  void toggleRecording() async {
    try {
      if (!isRecording) {
        if (await audiorecord.hasPermission()) {
          await audiorecord.start();
          setState(() {
            isRecording = true;
            startTime = DateTime.now();
          });
        }
      } else if (isPaused) {
        await audiorecord.resume();
        setState(() {
          isPaused = false;
          startTime = DateTime.now(); // Update start time when resuming
        });
      } else {
        await audiorecord.pause();
        setState(() {
          isPaused = true;
        });
      }
    } catch (e) {
      print('error for recording operation $e');
    }
  }

  void stopRecording() async {
    try {
      if (isRecording || isPaused) {
        String? path = await audiorecord.stop();
        setState(() {
          isRecording = false;
          isPaused = false;
          audioPath = path!;
        });
      }
    } catch (e) {
      print('error for stop recording $e');
    }
  }

  Future<void> playAudioRecorded() async {
    try {
      if (audioPath.isNotEmpty) {
        Source urlSource = UrlSource(audioPath);
        await audioPlay.play(urlSource);
      }
    } catch (e) {
      print('error for play record $e');
    }
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Audio Recording'),
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
                  onPressed: toggleRecording,
                  icon: isRecording && !isPaused
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  label: isRecording || isPaused
                      ? Text(isPaused ? 'Resume Recording' : 'Pause Recording')
                      : Text('Start Recording'),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: stopRecording,
                  icon: Icon(Icons.stop),
                  label: Text('Stop'),
                ),
                SizedBox(height: 16),
                Text('Recording Duration: ${formatDuration(recordingDuration)}'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      playAudioRecorded();
                    },
                    child: Text('Play Recorded Audio'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

