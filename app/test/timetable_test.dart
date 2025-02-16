import 'package:flutter_test/flutter_test.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/extensions/extensions.dart';

void main() {
  test("Test timetable json parsing. Timetable object to json", () {
    StandardTimeTable t = StandardTimeTable(
        timings: [
          Timing(
              startTime: DateTimeHM.fromHM(hour: 9, minute: 0),
              endTime: DateTimeHM.fromHM(hour: 9, minute: 45)),
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
    StandardTimeTable t = StandardTimeTable.fromJson({
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
}
