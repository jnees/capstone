import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattedDateFromString extends StatelessWidget {
  const FormattedDateFromString({Key? key, required this.date})
      : super(key: key);
  final String date;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(date);
    return Text(
      DateFormat('MM/d/y').format(dateTime),
    );
  }
}
