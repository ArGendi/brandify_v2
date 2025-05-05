import 'package:flutter/material.dart';

class DateTimeUtils {
  /// Checks if a target date is between start and end dates (inclusive)
  /// 
  /// [target] The date to check
  /// [start] The start date of the range
  /// [end] The end date of the range
  /// [useTime] Whether to include time in comparison (defaults to false)
  /// 
  /// Returns true if target is between start and end (inclusive)
  static bool isBetweenInclusive(
    DateTime target,
    DateTime start,
    DateTime end, {
    bool useTime = false,
  }) {
    if (!useTime) {
      // Use only dates without time
      DateTime startOfDay = DateTime(start.year, start.month, start.day, 0, 0, 0);
      DateTime endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
      return (target.isAfter(startOfDay) || target.isAtSameMomentAs(startOfDay)) &&
            (target.isBefore(endOfDay) || target.isAtSameMomentAs(endOfDay));
    } else {
      // Use exact time comparison
      return (target.isAfter(start) || target.isAtSameMomentAs(start)) &&
            (target.isBefore(end) || target.isAtSameMomentAs(end));
    }
  }

  /// Formats a DateTime to a string in the format "yyyy-MM-dd"
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Gets the start of day for a given DateTime
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  /// Gets the end of day for a given DateTime
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
} 