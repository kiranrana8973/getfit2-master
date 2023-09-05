import 'dart:typed_data';
import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<String> predictedWorkoutAsync(List<double> inputValues) async {
  return await predictWorkout(inputValues);
}

Future<String> predictWorkout(List<double> inputValues) async {
  // Load the model
  Interpreter interpreter =
      await Interpreter.fromAsset('images/workout_predictor.tflite');

  //Conversion
  Float32List inputBytes = Float32List.fromList(inputValues);

  // Create a buffer for the output values
  var outputBuffer = List.generate(1, (i) => List<double>.filled(4, 0));

  // Run inference on the input values
  interpreter.run(inputBytes.buffer.asFloat32List(), outputBuffer);

  // rounding up
  int predictedClass =
      outputBuffer[0].indexOf(outputBuffer[0].reduce(math.max));

  // Map the predicted class to a workout name
  List<String> workouts = ['jumping jack', 'lunges', 'punches', 'steady'];
  String predictedWorkout = workouts[predictedClass];

  // Print the results
  // print(outputBuffer);
  // print(predictedWorkout);
  return predictedWorkout;
}
