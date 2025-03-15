import 'package:flutter_test/flutter_test.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'package:timetutor/models/settings.dart';

void main() {
  test("Test timetable json parsing. Timetable object to json", () {
    StandardTimetable t = StandardTimetable(
        timings: [
          Timing(
              startTime:
                  TimeTutorExtensionsOnDateTime.fromHM(hour: 9, minute: 0),
              endTime:
                  TimeTutorExtensionsOnDateTime.fromHM(hour: 9, minute: 45)),
        ],
        days: Days(monday: [
          "PHP".toSubject(),
          "AI".toSubject(),
          "J2EE".toSubject(),
        ], tuesday: [], wednesday: [], thursday: [
          "AI".toSubject(),
          "PHP".toSubject(),
          "J2EE".toSubject(),
        ], friday: [], saturday: [], sunday: []));
    expect(t.toJson(), {
      "timings": [
        {
          "startTime": "-0001-11-30T09:00:00.000",
          "endTime": "-0001-11-30T09:45:00.000"
        }
      ],
      "days": {
        "monday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {"name": "AI"},
          {"name": "PHP"},
          {"name": "J2EE"}
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
  });

  test("Test timetable json parsing. From json to timetable object", () {
    StandardTimetable t = StandardTimetable.fromJson({
      "timings": [
        {
          "startTime": "-0001-11-30T09:00:00.000",
          "endTime": "-0001-11-30T09:45:00.000"
        }
      ],
      "days": {
        "monday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
    expect(t.days.monday[0].name, "PHP");
    expect(t.days.thursday[2].name, "J2EE");

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

    final period1 = Period(subject: subject1, timing: timing1);
    final period2 = Period(subject: subject1, timing: timing1);

    expect(period1, period2);

    StandardTimetable table1 = StandardTimetable.fromJson({
      "timings": [
        {
          "startTime": "-0001-11-30T09:00:00.000",
          "endTime": "-0001-11-30T09:45:00.000"
        }
      ],
      "days": {
        "monday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });

    StandardTimetable table2 = StandardTimetable.fromJson({
      "timings": [
        {
          "startTime": "-0001-11-30T09:00:00.000",
          "endTime": "-0001-11-30T09:45:00.000"
        }
      ],
      "days": {
        "monday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "tuesday": [],
        "wednesday": [],
        "thursday": [
          {"name": "PHP"},
          {"name": "AI"},
          {"name": "J2EE"}
        ],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
    //expect(table1.timings, table2.timings);

    //expect(table1.days, table2.days);

    expect(table1 == table2, true);
  });

  test("Test generation of default settings", () {
    final AppSettings settings = AppSettings.fromJson({});
  });
}
