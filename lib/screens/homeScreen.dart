import 'dart:convert';

import 'package:fitness_api_app/helpers/exerciseHelper.dart';
import 'package:fitness_api_app/screens/exerciseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl =
      'https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json';

  ExerciseHub? exerciseHub;

  void getExercises() async {
    var response = await http.get(Uri.parse(apiUrl));
    var body = response.body;
    var json = jsonDecode(body);

    setState(() {
      exerciseHub = ExerciseHub.fromJson(json);
    });
  }

  @override
  void initState() {
    super.initState();
    getExercises();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: exerciseHub == null
          ? Center(
              child: LinearProgressIndicator(),
            )
          : Container(
              child: SafeArea(
                child: ListView.builder(
                  itemCount: exerciseHub!.exercises.length,
                  itemBuilder: (ctx, i) => Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ExerciseScreen(
                                    exercises: exerciseHub!.exercises[i],
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: (exerciseHub!.exercises[i].id).toString(),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: _deviceHeight * 0.25,
                                placeholder: AssetImage('assets/gym.jpeg'),
                                image: NetworkImage(
                                  (exerciseHub!.exercises[i].thumbnail)
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, bottom: 10),
                            alignment: Alignment.centerLeft,
                            width: _deviceWidth * 0.8,
                            height: _deviceHeight * 0.05,
                            color: Colors.black54,
                            child: Text(
                              (exerciseHub!.exercises[i].title).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
