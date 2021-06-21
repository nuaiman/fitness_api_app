import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_api_app/helpers/exerciseHelper.dart';
import 'package:fitness_api_app/screens/exerciseMainScreen.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExerciseScreen extends StatefulWidget {
  late final Exercises exercises;
  ExerciseScreen({required this.exercises});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int seconds = 30;

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Hero(
          tag: (widget.exercises.id).toString(),
          child: Stack(
            children: [
              CachedNetworkImage(
                height: _deviceHeight,
                width: _deviceWidth,
                fit: BoxFit.cover,
                imageUrl: (widget.exercises.thumbnail).toString(),
              ),
              Container(
                height: _deviceHeight,
                width: _deviceWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF000000),
                      Color(0x00000000),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Container(
                  height: _deviceHeight * 0.25,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(),
                    onChange: (double value) {
                      setState(() {
                        seconds = value.toInt();
                      });
                    },
                    initialValue: 30,
                    min: 5,
                    max: 300,
                    innerWidget: (v) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          (v.toInt()).toString(),
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: _deviceHeight * 0.1,
                  width: _deviceWidth,
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExerciseMainScreen(
                            exercises: widget.exercises,
                            seconds: seconds,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'S  T  A  R  T',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
