import 'package:flutter/material.dart';

class PlatformTotalsCard extends StatelessWidget {
  final Map<String, double> platformTotals;

  const PlatformTotalsCard({
    super.key,
    required this.platformTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Costs by Platform',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...platformTotals.entries.map((entry) => Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key),
                Text(
                  '${entry.value.toStringAsFixed(2)} LE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}