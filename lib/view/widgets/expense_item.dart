import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/models/extra_expense.dart';

class ExpenseItem extends StatelessWidget {
  final ExtraExpense expense;
  final bool isNoraml;
  final Function(BuildContext, ExtraExpense) onTap;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onTap, 
    this.isNoraml = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context, expense),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isNoraml? 15 : 10, 
            horizontal:isNoraml? 20 : 15
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long,
                  size: isNoraml? 25 : 18,
                  color: mainColor,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.name.toString(),
                      style: TextStyle(
                        fontSize: isNoraml? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      expense.date.toString().split(' ')[0],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isNoraml? 13 : 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${expense.price} LE",
                style: TextStyle(
                  fontSize: isNoraml? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}