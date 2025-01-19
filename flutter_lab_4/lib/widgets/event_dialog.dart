import 'package:flutter/material.dart';
import 'package:flutter_lab_4/models/exam.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mini_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
  return tz.TZDateTime.from(dateTime, tz.local);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class EventDetailsDialog extends StatefulWidget {
  final Exam exam;

  const EventDetailsDialog({super.key, required this.exam});

  @override
  _EventDetailsDialogState createState() => _EventDetailsDialogState();
}

class _EventDetailsDialogState extends State<EventDetailsDialog> {
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.exam.location ??
        const LatLng(42.0040144, 21.4086502); 
  }

  Future<void> _addLocationBasedReminder() async {
    if (widget.exam.location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a location first')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    DateTime notificationTime =
        widget.exam.date.subtract(const Duration(minutes: 30));

    if (notificationTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        widget.exam.date.hashCode, 
        'Exam Reminder',
        'Your exam for ${widget.exam.subject} is coming up at ${widget.exam.date}',
        _convertToTZDateTime(notificationTime), 
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'exam_reminder_channel',
            'Exam Reminders',
            channelDescription: 'Reminders for upcoming exams',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      setState(() {
        widget.exam.isReminderSet = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder set successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot set a reminder in the past')),
      );
    }
  }

  void _pickLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      widget.exam.location = _selectedLocation;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location set successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exam.subject),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Date: ${widget.exam.date.toLocal()}'),
            const SizedBox(height: 10),
            widget.exam.location != null
                ? MiniMap(location: widget.exam.location!)
                : const Text('No location available for this event.'),
            const SizedBox(height: 10),
            if (widget.exam.location == null)
              ElevatedButton(
                onPressed: _pickLocation,
                child: const Text('Pick Location'),
              ),
            if (widget.exam.location != null)
              widget.exam.isReminderSet
                  ? const Text(
                      'A location-based reminder has already been set for this event.',
                    )
                  : ElevatedButton(
                      onPressed: _addLocationBasedReminder,
                      child: const Text('Add Location-Based Reminder'),
                    ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
