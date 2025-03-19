import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'package:timetutor/models/settings.dart';

void main() {
  test("Test subject parsing", () {
    Subject s = "PHP".toSubject();
    expect(s.toJson(), {"name": "PHP"});
  });

  test("Test period parsing", () {
    Period p = "PHP".toPeriod();

    expect(p.toJson(), {
      "runtimeType": "withSubject",
      "subject": {"name": "PHP"}
    });

    expect("~none".toPeriod(), Period.none());

    expect("~none".toPeriod().toJson(), {
      "runtimeType": "none",
    });

    expect("~prev".toPeriod().toJson(), {
      "runtimeType": "previousCombined",
    });
  });

  test("Test timetable json parsing. Timetable object to json", () {
    Timetable t = Timetable(
        timings: [
          Timing(
              startTime: TimeTutorExtensionsOnDateTime.fromHM(hour: 9, minute: 0),
              endTime: TimeTutorExtensionsOnDateTime.fromHM(hour: 9, minute: 45)),
        ],
        days: Days(monday: [
          "PHP".toPeriod(),
          "AI".toPeriod(),
          "J2EE".toPeriod(),
        ], tuesday: [], wednesday: [], thursday: [
          "AI".toPeriod(),
          "PHP".toPeriod(),
          "J2EE".toPeriod(),
        ], friday: [], saturday: [], sunday: []));
    expect(t.toJson(), {
      "timings": [
        {"startTime": "-0001-11-30T09:00:00.000", "endTime": "-0001-11-30T09:45:00.000"}
      ],
      "days": {
        "monday": [
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
  });

  test("Test timetable json parsing. From json to timetable object", () {
    Timetable t = Timetable.fromJson({
      "timings": [
        {"startTime": "-0001-11-30T09:00:00.000", "endTime": "-0001-11-30T09:45:00.000"}
      ],
      "days": {
        "monday": [
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
    expect((t.days.monday[0] as PeriodWithSubject).subject.name, "PHP");
    expect((t.days.thursday[2] as PeriodWithSubject).subject.name, "J2EE");

    expect(t.timings.length, 1);
    expect(t.timings[0].startTime.hour, 9);
    expect(t.timings[0].endTime.hour, 9);
  });

  test("Check class equality", () {
    final DateTime dt = DateTime.now();

    final subject1 = Subject(name: "Hello");
    final subject2 = Subject(name: "Hello");

    expect(subject1, subject2);

    final timing1 = Timing(startTime: dt, endTime: dt);
    final timing2 = Timing(startTime: dt, endTime: dt);

    expect(timing1, timing2);

    final period1 = Timed(object: subject1.toPeriod(), timing: timing1);
    final period2 = Timed(object: subject1.toPeriod(), timing: timing1);

    expect(period1, period2);

    Timetable table1 = Timetable.fromJson({
      "timings": [
        {"startTime": "-0001-11-30T09:00:00.000", "endTime": "-0001-11-30T09:45:00.000"}
      ],
      "days": {
        "monday": [
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });

    Timetable table2 = Timetable.fromJson({
      "timings": [
        {"startTime": "-0001-11-30T09:00:00.000", "endTime": "-0001-11-30T09:45:00.000"}
      ],
      "days": {
        "monday": [
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {
            'subject': {'name': 'AI'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'PHP'},
            'runtimeType': 'withSubject'
          },
          {
            'subject': {'name': 'J2EE'},
            'runtimeType': 'withSubject'
          }
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });

    expect(table1 == table2, true);
  });

  test("Test generation of default settings", () {
    final AppSettings _settings = AppSettings.fromJson({});
  });

  test("Check timeofday to human readable string", () {
    expect(TimeOfDay(hour: 2, minute: 30).toHumanReadableString(), "02:30 AM");

    expect(TimeOfDay(hour: 12, minute: 30).toHumanReadableString(), "12:30 PM");

    expect(TimeOfDay(hour: 12, minute: 0).toHumanReadableString(), "12:00 PM");
  });

  test("Check human readable string to timeofday", () {
    expect("02:30 PM".toTimeOfDayFromHumanReadable(), TimeOfDay(hour: 14, minute: 30));

    expect("12:30 PM".toTimeOfDayFromHumanReadable(), TimeOfDay(hour: 12, minute: 30));
  });

  test("Check human readable string to timing", () {
    expect(
        "09:30 AM-10:30 AM".toTimingFromHumanReadable(),
        Timing(
            startTime: "09:30 AM".toTimeOfDayFromHumanReadable().toDateTime(),
            endTime: "10:30 AM".toTimeOfDayFromHumanReadable().toDateTime()));
  });

  test("Check for json types", () {
    Map<String, dynamic> json = {
      "timings": ["Hello", "World"]
    };
    expect(json["timings"] is List<String>, true);
  });
}
