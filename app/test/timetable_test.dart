import 'package:flutter_test/flutter_test.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/extensions/datetime.dart';

void main() {
  test("Test timetable json parsing. Timetable object to json", () {
    StandardTimeTable t = StandardTimeTable(
        timings: [
          Timing(
              startTime: DateTimeHM.fromHM(hour: 9, minute: 0),
              endTime: DateTimeHM.fromHM(hour: 9, minute: 45)),
        ],
        days: Days(monday: [
          "PHP",
          "AI",
          "J2EE",
        ], tuesday: [], wednesday: [], thursday: [
          "AI",
          "PHP",
          "J2EE"
        ], friday: [], saturday: [], sunday: []));
    expect(t.toJson(), {
      "timings": [
        {
          "startTime": "-0001-11-30T09:00:00.000",
          "endTime": "-0001-11-30T09:45:00.000"
        }
      ],
      "days": {
        "monday": ["PHP", "AI", "J2EE"],
        "tuesday": [],
        "wednesday": [],
        "thursday": ["AI", "PHP", "J2EE"],
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
        "monday": ["PHP", "AI", "J2EE"],
        "tuesday": [],
        "wednesday": [],
        "thursday": ["AI", "PHP", "J2EE"],
        "friday": [],
        "saturday": [],
        "sunday": [],
      }
    });
    expect(t.days.monday, ["PHP", "AI", "J2EE"]);
    expect(t.days.thursday, ["AI", "PHP", "J2EE"]);

    expect(t.timings.length, 1);
    expect(t.timings[0].startTime.hour, 9);
    expect(t.timings[0].endTime.hour, 9);
  });
}
