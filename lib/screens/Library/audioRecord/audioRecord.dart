import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:snaptune/db/db.functions/functions.dart';
import 'package:snaptune/db/songmodel/model.dart';

class AudioRecord extends StatefulWidget {
  const AudioRecord({Key? key}) : super(key: key);

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  late Record audiorecord;
  late AudioPlayer audioPlay;
  bool isRecording = false;
  bool isPaused = false;
  String audioPath = '';
  int durationInSeconds = 0;
  late Timer durationTimer;

  @override
  void initState() {
    super.initState();
    audiorecord = Record();
    audioPlay = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    audiorecord.dispose();
    audioPlay.dispose();
    cancelDurationTimer(); // Ensure the duration timer is canceled when the widget is disposed.
  }

  void toggleRecording() async {
    try {
      if (!isRecording) {
        if (await audiorecord.hasPermission()) {
          await audiorecord.start();
          startDurationTimer();
          setState(() {
            isRecording = true;
          });
        }
      } else if (isPaused) {
        await audiorecord.resume();
        startDurationTimer();
        setState(() {
          isPaused = false;
        });
      } else {
        await audiorecord.pause();
        cancelDurationTimer();
        setState(() {
          isPaused = true;
        });
      }
    } catch (e) {
      // handle error
    }
  }

  void startDurationTimer() {
    durationTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        durationInSeconds++;
      });
    });
  }

  void cancelDurationTimer() {
    if (durationTimer != null && durationTimer.isActive) {
      durationTimer.cancel();
    }
  }

  void stopRecording() async {
    try {
      if (isRecording || isPaused) {
        cancelDurationTimer();
        String? path = await audiorecord.stop();
        setState(() {
          isRecording = false;
          isPaused = false;
          audioPath = path!;
          addAudio(audioPath);
          durationInSeconds = 0; // reset duration timer
        });
      }
    } catch (e) {
      // handle error
    }
  }

  Future<void> playAudioRecorded(String audioPath) async {
    try {
      if (audioPath.isNotEmpty) {
        Source urlSource = UrlSource(audioPath);
        await audioPlay.play(urlSource);
      }
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Audio Recording',
          style: GoogleFonts.aBeeZee(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
            width: double.infinity,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: toggleRecording,
                    icon: isRecording && !isPaused
                        ? const Icon(Icons.pause, size: 55)
                        : const Icon(Icons.play_arrow, size: 55),
                    label: isRecording || isPaused
                        ? Text(
                            isPaused ? 'Resume Recording' : 'Pause Recording')
                        : const Text('Start Recording'),
                        style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      // Change the text color here
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: stopRecording,
                    icon: const Icon(Icons.stop, size: 50),
                    label: const Text('Stop'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      // Change the text color here
                    ),
                  ),
                    const SizedBox(height: 15),
                  Container(
                    height: 55,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        'Duration :  ${Duration(seconds: durationInSeconds).toString().split('.').first}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20),
            child: Text(
              'Recorded Audios',
              style: GoogleFonts.aBeeZee(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<AudioModel>>(
              future: getAllAudio(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Record Audio & Play',
                      style: GoogleFonts.abyssinicaSil(fontSize: 25),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Image(
                            image:
                                AssetImage('assets/images/leadingImage.png')),
                        title: Text(
                          'Recorded Audio ${index + 1}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: const Text('<unknown>'),
                        onTap: () {
                          playAudioRecorded(snapshot.data![index].audioPath);
                        },
                        trailing: IconButton(
                          onPressed: () {
                            deleteAudio(snapshot.data![index].audioPath);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
