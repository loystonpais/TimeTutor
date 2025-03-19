import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/models/settings.dart';
import 'package:timetutor/models/supabase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notificationsPlugin = FlutterLocalNotificationsPlugin();
final initSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
final initSettings = InitializationSettings(android: initSettingsAndroid);

final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
  "timetutor_channel_id",
  "TimeTutor",
  channelDescription: "TimeTutor",
  importance: Importance.max,
  priority: Priority.high,
));

late Function materialPageSetState;

var logger = Logger();
var isWeb = kIsWeb;

final client = Supabase.instance.client;

late User authUser;

late UserProfile? userProfile;
late Class? userJoinedClass;
late Timetable? joinedClassTimetable;
late Institution userJoinedInstitution;

AppSettings appSettings = AppSettings();

final Timetable defaultTimetable = Timetable.fromJson({
  "days": {
    "friday": [
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      }
    ],
    "monday": [
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "A"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Class"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "You"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Want To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      }
    ],
    "sunday": [],
    "tuesday": [
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      }
    ],
    "saturday": [
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "A"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Class"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "You"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Want To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      }
    ],
    "thursday": [
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Welcome"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "TimeTutor"},
        "runtimeType": "withSubject"
      }
    ],
    "wednesday": [
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "A"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Class"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "You"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Want To"},
        "runtimeType": "withSubject"
      },
      {
        "subject": {"name": "Join"},
        "runtimeType": "withSubject"
      }
    ]
  },
  "timings": [
    {"endTime": "-0001-11-30T09:50:00.000", "startTime": "-0001-11-30T09:00:00.000"},
    {"endTime": "-0001-11-30T10:45:00.000", "startTime": "-0001-11-30T09:55:00.000"},
    {"endTime": "-0001-11-30T11:40:00.000", "startTime": "-0001-11-30T10:50:00.000"},
    {"endTime": "-0001-11-30T12:35:00.000", "startTime": "-0001-11-30T11:45:00.000"},
    {"endTime": "-0001-11-30T13:30:00.000", "startTime": "-0001-11-30T12:35:00.000"},
    {"endTime": "-0001-11-30T14:10:00.000", "startTime": "-0001-11-30T13:30:00.000"}
  ]
});
