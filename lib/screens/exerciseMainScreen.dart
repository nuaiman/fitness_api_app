import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_api_app/helpers/exerciseHelper.dart';
import 'package:fitness_api_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';

class ExerciseMainScreen extends StatefulWidget {
  late final Exercises exercises;
  final int seconds;
  ExerciseMainScreen({required this.exercises, required this.seconds});

  @override
  _ExerciseMainScreenState createState() => _ExerciseMainScreenState();
}

class _ExerciseMainScreenState extends State<ExerciseMainScreen> {
  int seconds = 30;

  bool _isCompleted = false;

  int elapsedSeconds = 0;

  Timer? timer;

  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache _audioCache = AudioCache();

  void playAudio() async {
    await _audioCache.play(
      'sample.wav',
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (t) {
        if (t.tick == widget.seconds - 1) {
          playAudio();
        }
        if (t.tick == widget.seconds) {
          t.cancel();
          setState(() {
            _isCompleted = true;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
        setState(() {
          elapsedSeconds = t.tick;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              height: _deviceHeight,
              width: _deviceWidth,
              fit: BoxFit.contain,
              imageUrl: (widget.exercises.gif).toString(),
            ),
          ),
          !_isCompleted
              ? SafeArea(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '$elapsedSeconds / ${widget.seconds} s',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 40,
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
