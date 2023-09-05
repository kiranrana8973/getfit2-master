import 'package:firebase_database/firebase_database.dart';

class DataModel {
  final double gx;
  final double gy;
  final double gz;
  final double ax;
  final double ay;
  final double az;

  DataModel(
      {required this.gx,
      required this.gy,
      required this.gz,
      required this.ax,
      required this.ay,
      required this.az});

   DataModel.fromMap({required String key, required Map<String, double> value}):
        gx = value['gx'] ?? 0.0,
        gy = value['gy'] ?? 0.0,
        gz = value['gz'] ?? 0.0,
        ax = value['ax'] ?? 0.0,
        ay = value['ay'] ?? 0.0,
        az = value['az'] ?? 0.0;

  toJson() {
    return {"gx": gx, "gy": gy, "gz": gz, "ax": ax, "ay": ay, "az": az};
  }
}

class DatabaseService {
  static Future<List<DataModel>> getData() async {
    try {
      final snapshot =
          await FirebaseDatabase.instance.ref("sensor_data").limitToLast(1).orderByKey().get();

      List<DataModel> needs = [];
      Map<String, dynamic> values = (snapshot.value as Map).cast<String, dynamic>();
      // print(values.runtimeType);
      values.forEach((key, values) {
        print('Hello');
        needs.add(DataModel.fromMap(key: key, value: values));
      });

      return needs;
    } catch (e) {
      print('This is Error: $e');
      return [];
    }
  }
}
