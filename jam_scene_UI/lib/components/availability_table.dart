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
          Text("Day", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("AM", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("PM", style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        TableRow(children: [
          const Text("Sunday"),
          profileData.availSunAm ? const Text("✅") : const Text("-"),
          profileData.availSunPm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Monday"),
          profileData.availMonAm ? const Text("✅") : const Text("-"),
          profileData.availMonPm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Tuesday"),
          profileData.availTueAm ? const Text("✅") : const Text("-"),
          profileData.availTuePm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Wednesday"),
          profileData.availWedAm ? const Text("✅") : const Text("-"),
          profileData.availWedPm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Thursday"),
          profileData.availThuAm ? const Text("✅") : const Text("-"),
          profileData.availThuPm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Friday"),
          profileData.availFriAm ? const Text("✅") : const Text("-"),
          profileData.availFriPm ? const Text("✅") : const Text("-"),
        ]),
        TableRow(children: [
          const Text("Saturday"),
          profileData.availSatAm ? const Text("✅") : const Text("-"),
          profileData.availSatPm ? const Text("✅") : const Text("-"),
        ]),
      ],
    );
  }
}
