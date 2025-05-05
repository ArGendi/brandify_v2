// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class ProductPieChart extends StatelessWidget {
//   // Sample data (replace with your actual data)
//   final List<ChartData> data = [
//     ChartData(name: 'Online', value: 40, color: Colors.blue),
//     ChartData(name: 'Offline', value: 30, color: Colors.green),
//     ChartData(name: 'Event', value: 20, color: Colors.orange),
//     ChartData(name: 'Other', value: 10, color: Colors.grey),
//   ];

//   double get totalValue => data.fold(0, (sum, item) => sum + item.value);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Most Bought Products by Place'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: 4,
//                   centerSpaceRadius: 50,
//                   sections: _buildSections(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildLegend(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> _buildSections() {
//     return data.map((data) {
//       final double percentage = (data.value / totalValue) * 100;
//       return PieChartSectionData(
//         color: data.color,
//         value: data.value.toDouble(),
//         title: '${percentage.toStringAsFixed(1)}%',
//         radius: 55,
//         titleStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     }).toList();
//   }

//   Widget _buildLegend() {
//     return Wrap(
//       alignment: WrapAlignment.center,
//       spacing: 16,
//       runSpacing: 8,
//       children: data.map((data) {
//         final double percentage = (data.value / totalValue) * 100;
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 16,
//               height: 16,
//               color: data.color,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               '${data.name} (${percentage.toStringAsFixed(1)}%)',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }

// class ChartData {
//   final String name;
//   final int value;
//   final Color color;

//   ChartData({
//     required this.name,
//     required this.value,
//     required this.color,
//   });
// }