import 'package:flutter/material.dart';
import 'package:flutter_lab_4/models/exam.dart';
import 'package:flutter_lab_4/widgets/event_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ExamScheduleScreen extends StatelessWidget {
  final exams = Exam.getAllExams();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exam Schedule")),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: ExamDataSource(exams),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final Appointment? appointment = details.appointments!.first;
            showDialog(
              context: context,
              builder: (context) => EventDetailsDialog(
                exam: exams.firstWhere(
                  (exam) => exam.date == appointment!.startTime,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ExamDataSource extends CalendarDataSource {
  ExamDataSource(List<Exam> exams) {
    appointments = exams
        .map(
          (exam) => Appointment(
            startTime: exam.date,
            endTime: exam.date.add(const Duration(hours: 2)),
            subject: exam.subject,
            location: exam.location != null ? 'Location Set' : 'No Location',
            color: Colors.blue,
          ),
        )
        .toList();
  }
}
