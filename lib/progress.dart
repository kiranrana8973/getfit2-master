import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

import 'user_profile/user_profile.dart';

class Progress extends StatelessWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: const [UserProfile()],
      ),
      //     body: DefaultTextStyle(
      //       style: GoogleFonts.getFont(
      //         'Lato',
      //         textStyle: const TextStyle(
      //           fontSize: 15,
      //           fontWeight: FontWeight.w600,
      //           color: Color(0xFF000000),
      //         ),
      //       ),
      //       child: Padding(
      //           padding: const EdgeInsets.all(10.0),
      //           child: Column(
      //             children: [
      //               Container(
      //                 padding: const EdgeInsets.all(10),
      //                 width: double.infinity,
      //                 height: 300,
      //                 child: LineChart(
      //                   LineChartData(
      //                     borderData: FlBorderData(show: false),
      //                     lineBarsData: [
      //                       LineChartBarData(spots: [
      //                         const FlSpot(0, 1),
      //                         const FlSpot(1, 3),
      //                         const FlSpot(2, 10),
      //                         const FlSpot(3, 7),
      //                         const FlSpot(4, 12),
      //                         const FlSpot(5, 13),
      //                         const FlSpot(6, 17),
      //                         const FlSpot(7, 15),
      //                         const FlSpot(8, 20)
      //                       ])
      //                     ],
      //                     axisTitlesData: FlAxisTitlesData(
      //   topTitles: AxisTitles(showTitles: false),
      //   rightTitles: AxisTitles(showTitles: false),
      //   bottomTitles: AxisTitles(
      //     showTitles: true,
      //     // Customize bottom titles here
      //   ),
      //   leftTitles: AxisTitles(
      //     showTitles: true,
      //     // Customize left titles here
      //   ),
      // ),
      //                   ),
      //                 ),
      //               ),
      //               const Text('Overall calorie burnt till date: XXXX')
      //             ],
      //           )),
      //     ),
    );
  }
}
