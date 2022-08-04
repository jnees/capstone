import 'package:flutter/material.dart';
import '../models/profile_data.dart';

class AvailabilityTable extends StatelessWidget {
  const AvailabilityTable({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        const TableRow(children: [
          Text("", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("AM", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("PM", style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        TableRow(children: [
          const DayText(day: "Sunday"),
          profileData.availSunAm ? const CheckText() : const DashText(),
          profileData.availSunPm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Monday"),
          profileData.availMonAm ? const CheckText() : const DashText(),
          profileData.availMonPm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Tuesday"),
          profileData.availTueAm ? const CheckText() : const DashText(),
          profileData.availTuePm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Wednesday"),
          profileData.availWedAm ? const CheckText() : const DashText(),
          profileData.availWedPm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Thursday"),
          profileData.availThuAm ? const CheckText() : const DashText(),
          profileData.availThuPm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Friday"),
          profileData.availFriAm ? const CheckText() : const DashText(),
          profileData.availFriPm ? const CheckText() : const DashText(),
        ]),
        TableRow(children: [
          const DayText(day: "Saturday"),
          profileData.availSatAm ? const CheckText() : const DashText(),
          profileData.availSatPm ? const CheckText() : const DashText(),
        ]),
      ],
    );
  }
}

class DayText extends StatelessWidget {
  const DayText({
    Key? key,
    required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(day),
    );
  }
}

class CheckText extends StatelessWidget {
  const CheckText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill, child: Text("✅"));
  }
}

class DashText extends StatelessWidget {
  const DashText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("-"),
        ));
  }
}
