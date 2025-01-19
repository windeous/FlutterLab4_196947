import 'package:google_maps_flutter/google_maps_flutter.dart';

class Exam {
  DateTime date;
  String subject;
  LatLng? location;
  bool isReminderSet;

  Exam({
    required this.date,
    required this.subject,
    this.location,
    this.isReminderSet = false,
  });

  static List<Exam> getAllExams() {
    return [
    Exam(
      date: DateTime(2025, 1, 20, 10, 0),
      subject: 'Math Exam',
      location: const LatLng(42.004136893941585, 21.40953984131099), 
    ),
    Exam(
      date: DateTime(2025, 1, 25, 14, 0),
      subject: 'History Exam',
      location: null,
    ),
    Exam(
      date: DateTime(2025, 2, 10, 9, 0),
      subject: 'Science Exam',
      location: const LatLng(42.004582733929205, 21.408130286025415), 
    ),
  ];
  }
}

