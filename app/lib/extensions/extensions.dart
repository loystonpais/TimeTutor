import 'package:flutter/material.dart';
import 'package:timetutor/models/misc.dart';
import 'package:intl/intl.dart';

extension TimetutorExtensionsOnString on String {
  Subject toSubject() {
    return Subject(name: this);
  }

  Period toPeriod(Timing timing) {
    return Period(subject: Subject(name: this), timing: timing);
  }
}

extension TimetutorExtenionsOnTimeOfDay on TimeOfDay {
  double toDouble() {
    return hour + (minute / 60.0);
  }

  double deviation({required TimeOfDay from, required TimeOfDay to}) {
    return (toDouble() - from.toDouble()) / (to.toDouble() - from.toDouble());
  }
}

extension TimeTutorExtensionsOnDateTime on DateTime {
  static DateTime fromHM({required int hour, required int minute}) {
    return DateTime(0, 0, 0, hour, minute);
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: hour, minute: minute);
  }
}

extension TimeTutorExtensionsOnInt on int {
  Day toDay() {
    return Day.getDayFromDateTimeInt(this);
  }
}

extension TimeTutorExtensionsOnListOfPeriod on List<Period> {
  ({
    Period? currentPeriod,
    Period? nextPeriod,
    Period? prevPeriod,
    int currentPeriodPos
  }) calculatePeriodsFromTimeOfDay(TimeOfDay tod) {
    List<Period> periods = this;

    Period? currentPeriod;
    Period? nextPeriod;
    Period? prevPeriod;

    late int currentPeriodPos;

    for (currentPeriodPos = 0;
        currentPeriodPos < periods.length;
        currentPeriodPos++) {
      var period = periods[currentPeriodPos];
      double percent = tod.deviation(
        from: period.timing.startTime.toTimeOfDay(),
        to: period.timing.endTime.toTimeOfDay(),
      );
      //print(percent);

      if (percent > 1) {
        prevPeriod = period;
      } else if (percent >= 0 && percent <= 1) {
        currentPeriod = period;
        if (period != periods.last) {
          nextPeriod = periods[currentPeriodPos + 1];
        }
        if (period != periods.first) {
          prevPeriod = periods[currentPeriodPos - 1];
        }
        break;
      } else {
        nextPeriod = period;
        if (period != periods.first) {
          prevPeriod = periods[currentPeriodPos - 1];
        }
        break;
      }
    }

    return (
      currentPeriod: currentPeriod,
      nextPeriod: nextPeriod,
      prevPeriod: prevPeriod,
      currentPeriodPos: currentPeriodPos,
    );
  }
}
