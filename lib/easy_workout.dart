import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'database/connection.dart';
import 'model/classifier.dart';
import 'userprovider.dart';

enum Workout { punches, jumpingJacks, lunges }

class EasyWorkout extends StatefulWidget {
  const EasyWorkout({Key? key}) : super(key: key);

  @override
  EasyWorkoutState createState() => EasyWorkoutState();
}

class EasyWorkoutState extends State<EasyWorkout>
    with TickerProviderStateMixin {
  final AudioPlayer audioCache = AudioPlayer();
  late final AudioCache player;
  late String currentWorkout;
  String apiData = '';
  late String? email;
  late int age, weight, height;

  bool _isPlaying = false;
  bool _showCountdown = false;
  bool _firstClick = true;
  double _timerValue = 0;
  int elapsed = 0;
  late Timer _timer, _sensorTimer, _workoutCheckTimer;
  final List<Map<String, dynamic>> gifs = [
    {
      'duration': 30,
      'gif': const AssetImage('images/punches.gif'),
      'text': 'Punches',
      'gifduration': 1000,
    },
    {
      'duration': 10,
      'gif': const AssetImage('images/jumping jack.gif'),
      'text': '\t\t\t\t\tRest\nUpcoming: Jumping Jack',
      'gifduration': 1000,
    },
    {
      'duration': 30,
      'gif': const AssetImage('images/jumping jack.gif'),
      'text': 'Jumping Jack',
      'gifduration': 1000,
    },
    {
      'duration': 10,
      'gif': const AssetImage('images/lunges.gif'),
      'text': '\t\t\t\t\tRest\nUpcoming: Lunges',
      'gifduration': 3000,
    },
    {
      'duration': 30,
      'gif': const AssetImage('images/lunges.gif'),
      'text': 'Lunges',
      'gifduration': 3000,
    },
  ];

  // Added variables to keep track of reps and calories burned
  int reps = 0;
  int totalReps = 0;
  int caloriesBurned = 0;

  late GifController _controller;
  int currentGifIndex = 0;
  int _countdownValue = 5;
  ImageProvider currentGif = const AssetImage('images/jumping jack.gif');
  final ValueNotifier<String> currentText = ValueNotifier('');

  // final databaseReference = FirebaseDatabase.instance.ref();
  void startSensorTimer() {
    // _sensorTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    // predictedWorkoutAsync();
    checkWorkoutStatus();

    // });
  }

  void stopSensorTimer() {
    _sensorTimer.cancel();
  }

  void checkWorkoutStatus() {
    checkWorkout();
  }

  void checkWorkout() {
    final databaseReference = FirebaseDatabase.instance.ref();
    databaseReference
        .child('sensor_data')
        .limitToLast(1)
        .onValue
        .listen((event) async {
      // await Future.delayed(const Duration(seconds: 3));
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      var entry = data.entries.first;
      var gx = entry.value['gx'];
      var gy = entry.value['gy'];
      var gz = entry.value['gz'];
      var ax = entry.value['ax'];
      var ay = entry.value['ay'];
      var az = entry.value['az'];
      List<double> sensorValues = [
        ax.toDouble(),
        ay.toDouble(),
        az.toDouble(),
        gx.toDouble(),
        gy.toDouble(),
        gz.toDouble()
      ];
      currentWorkout = await predictedWorkoutAsync(sensorValues);
      print('Currrent workout = $currentWorkout');

      // Added code to count reps and calculate calories burned
      if (currentGifIndex == gifs.length - 1) {
        // if it is the last workout
        if (currentWorkout == "lunges") {
          reps++;
          totalReps++;
          int durationInSeconds = gifs[currentGifIndex]['duration'];
          caloriesBurned +=
              calculateWorkout(Workout.lunges, durationInSeconds, weight);
        }
      } else if (currentGifIndex % 2 == 0) {
        // if it is an even index, it is a workout
        if (currentWorkout == gifs[currentGifIndex]['text'].toLowerCase()) {
          reps++;
          totalReps++;
          int durationInSeconds = gifs[currentGifIndex]['duration'];
          if (currentWorkout == "punches") {
            caloriesBurned +=
                calculateWorkout(Workout.punches, durationInSeconds, weight);
          } else if (currentWorkout == "jumping jack") {
            caloriesBurned += calculateWorkout(
                Workout.jumpingJacks, durationInSeconds, weight);
          }
        }
      }
    });
  }

  // int calculateWorkout(
  //     Workout workout, int reps, int age, int weight, int height) {
  //   double bmr = 10 * weight + 6.25 * height - 5 * age + 5;
  //   double caloriesBurned;
  //   switch (workout) {
  //     case Workout.punches:
  //       caloriesBurned = bmr * 0.5 * reps / 24;
  //       break;
  //     case Workout.jumpingJacks:
  //       caloriesBurned = bmr * 0.2 * reps / 24;
  //       break;
  //     case Workout.lunges:
  //       caloriesBurned = bmr * 0.3 * reps / 24;
  //       break;
  //     default:
  //       caloriesBurned = 0;
  //   }
  //   return caloriesBurned.round();
  // }
  int calculateWorkout(
      Workout workout, int durationInSeconds, int weightInKilograms) {
    double met;
    switch (workout) {
      case Workout.punches:
        met = 8.0;
        break;
      case Workout.jumpingJacks:
        met = 3.8;
        break;
      case Workout.lunges:
        met = 3.8;
        break;
      default:
        met = 1.0;
    }
    double caloriesBurnedPerMinute = (met * weightInKilograms) / 60;
    int caloriesBurned =
        (caloriesBurnedPerMinute * (durationInSeconds / 60)).round();
    return caloriesBurned;
  }

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this)..stop();
    _timer = Timer(Duration.zero, () {});
    _sensorTimer = Timer(Duration.zero, () {});
    _workoutCheckTimer = Timer(Duration.zero, () {});
    // Check this code
    // player = AudioCache(fixedPlayer: audioCache);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //  email = Provider.of<UserProvider>(context).email;
    email = "hell@gmail.com";
    print(email);
    getUserDetails(email!).then((value) {
      DateTime birthDate = value['dob'];
      final currentDate = DateTime.now();
      int calculatedAge = currentDate.year - birthDate.year;
      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        calculatedAge--;
      }
      age = calculatedAge;
      height = (value['height'] as double).round();
      weight = (value['weight'] as double).round();
    });
  }

  void _startNextTimer() {
    if (currentGifIndex < gifs.length) {
      // startSensorTimer();
      _controller.stop();
      _controller.repeat(
          min: 0,
          max: 1,
          period: Duration(milliseconds: gifs[currentGifIndex]['gifduration']));
      int duration = gifs[currentGifIndex]['duration'];
      ImageProvider gif = gifs[currentGifIndex]['gif'];
      String text = gifs[currentGifIndex]['text'];
      currentGif = gif;
      currentText.value = text;

      // Added code to reset reps for each workout
      if (currentGifIndex % 2 == 0) {
        // if it is an even index, it is a workout
        reps = 0;
      }

      _startTimer(duration);
    } else {
      currentGifIndex--;
      _controller.stop();
      stopSensorTimer();

      // Added code to show total reps and calories burned at the end of the workout
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Workout Complete!',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text('Total Reps: $totalReps\nCalories Burned: $caloriesBurned'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _togglePlay() {
    setState(() {
      if (_isPlaying) {
        _timer.cancel();
        _isPlaying = false;
        _controller.stop();
      } else {
        startSensorTimer();
        if (_firstClick) {
          // player.play('countdwn.mp3');
          player.load('countdwn.mp3');
          _showCountdown = true;
          _startCountdown();
          _firstClick = false;
        } else {
          _startNextTimer();
        }
        // _controller.stop();
        // _controller.repeat(min: 0, max: 1, period: const Duration(milliseconds: 1000));
        _isPlaying = true;
      }
    });
  }

  void _startTimer(int durationInSeconds) {
    const interval = Duration(milliseconds: 100);
    int totalTime = (durationInSeconds * 1000);
    elapsed = (_timerValue * totalTime).round();
    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        elapsed += interval.inMilliseconds;
        if (elapsed >= totalTime) {
          // currentGifIndex++;

          elapsed = totalTime;

          timer.cancel();
          _isPlaying = false;

          _isPlaying = true;
          elapsed = 0;
          _timerValue = 0;

          currentGifIndex++;
          _startNextTimer();

          // }
        }
        _timerValue = elapsed / totalTime;
        // if(_showCountdown){
        // _countdownValue--;
        // }
      });
      // Print the elapsed time every second
      // if (elapsed % 1000 == 0) {
      // print('Elapsed time: ${elapsed ~/ 1000} seconds');
      // }
      // startSensorTimer();
      if (elapsed == 27000) {
        player.load('tadaaa.mp3');
      } else if (gifs[currentGifIndex]['duration'] == 10 && elapsed == 9500) {
        player.load('start.mp3');
      }
    });
  }

  void _startCountdown() {
    setState(() {
      _countdownValue = 5;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdownValue--;
        if (_countdownValue == 0) {
          timer.cancel();
          _showCountdown = false;
          _startNextTimer();
        }
      });
    });
  }

  Future<bool> _onWillPop() async {
    // Pause the gif
    _controller.stop();

    // Pause the timer
    _timer.cancel();
    // _isPlaying = false;
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Don\'t give up!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Do you really want to quit workout?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Resume the gif
                  // _controller.stop();
                  if (_isPlaying) {
                    _controller.repeat(
                        min: 0,
                        max: 1,
                        period: Duration(
                            milliseconds: gifs[currentGifIndex]
                                ['gifduration']));

                    // Resume the timer
                    if (_showCountdown) {
                      _startCountdown();
                    } else {
                      _startTimer(gifs[currentGifIndex]['duration']);
                    }
                    // _isPlaying = false;
                  }
                  // _isPlaying = true;
                  Navigator.of(context).pop(false);
                },
                child: const Text('Resume'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Quit workout'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Beginner'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ValueListenableBuilder<String>(
                      //     valueListenable: currentText,
                      //     builder: (BuildContext context, String value,
                      //         Widget? child) {
                      //       return Text(value);
                      //     }),
                      Text(
                        "${gifs[currentGifIndex]['text']} \nReps: $reps",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: CircularProgressIndicator(
                            value: _timerValue,
                            strokeWidth: 10,
                            backgroundColor:
                                const Color.fromARGB(10, 0, 72, 255),
                          ),
                        ),
                        ClipOval(
                          child: SizedBox(
                            width: 280,
                            height: 280,
                            child: Container(
                              color: const Color(0xFFB7DFFF),
                              child: Stack(
                                children: [
                                  Visibility(
                                    visible: _showCountdown,
                                    child: Center(
                                      child: Text(
                                        '${(_countdownValue)}',
                                        style: GoogleFonts.getFont(
                                          'Lato',
                                          textStyle: const TextStyle(
                                            fontSize: 200,
                                            fontWeight:
                                                FontWeight.w900, // color:
                                            // Color(0xFF50B0FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !_showCountdown,
                                    child: Gif(
                                      controller: _controller,
                                      fps: 30,
                                      image: currentGif,
                                      placeholder: (context) =>
                                          const Text('Loading...'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "Calorie Count: $caloriesBurned",
                  style: GoogleFonts.getFont(
                    'Lato',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900, // color:
                      // Color(0xFF50B0FF),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Text(
                      '${(gifs[currentGifIndex]['duration'] - (_timerValue * gifs[currentGifIndex]['duration'])).round()}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: AbsorbPointer(
                          absorbing: _showCountdown,
                          child: ElevatedButton(
                            onPressed: () => _togglePlay(),
                            style: _showCountdown
                                ? ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    disabledBackgroundColor: Colors.grey,
                                  )
                                : null,
                            child: Text(
                              _isPlaying ? 'Pause Timer' : 'Start Timer',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
