import 'package:flutter/material.dart';
import 'package:timetutor/models/misc.dart';
import 'package:intl/intl.dart';

extension TimetutorExtensionsOnString on String {
  Subject toSubject() => Subject.fromString(this);

  Timing toTimingFromHumanReadable() => Timing.fromHumanReadableString(this);

  Period toPeriod() => Period.fromString(this);

  Timed<Period> toTimedPeriod(Timing timing) {
    return Timed<Period>(object: toPeriod(), timing: timing);
  }

  TimeOfDay toTimeOfDayFromHumanReadable() {
    return DateFormat("hh:mm a").parse(this).toTimeOfDay();
  }
}

extension TimetutorExtenionsOnTimeOfDay on TimeOfDay {
  double toDouble() {
    return hour + (minute / 60.0);
  }

  double deviation({required TimeOfDay from, required TimeOfDay to}) {
    return (toDouble() - from.toDouble()) / (to.toDouble() - from.toDouble());
  }

  String toHumanReadableString() {
    return "${hourOfPeriod.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${period == DayPeriod.am ? 'AM' : 'PM'}";
  }

  DateTime toDateTime() {
    return DateTime(0, 0, 0, hour, minute);
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
  List<Timed<PeriodWithSubject>> toTimedPeriods(List<Timing> timings) {
    final periods = this;
    final List<Timed<PeriodWithSubject>> timedPeriods = [];

    late Timing timing;
    for (int i = 0; i < periods.length; i++) {
      Period period = periods[i];
      if (period is PeriodNone) {
        continue;
      } else if (period is PeriodPreviousCombined) {
        if (i == 0) {
          throw Exception("~prev cannot be the first period");
        }
        final prevTimedPeriod = timedPeriods.removeLast();
        final prevTimingStart = prevTimedPeriod.timing.startTime;
        final timingEnd = timings[i].endTime;
        timing = Timing(startTime: prevTimingStart, endTime: timingEnd);
        period = (prevTimedPeriod.object);
      } else {
        timing = timings[i];
      }

      timedPeriods.add(Timed(object: period as PeriodWithSubject, timing: timing));
    }

    return timedPeriods;
  }
}

extension TimeTutorExtensionsOnListOfTimedT<T> on List<Timed<T>> {
  ({Timed<T>? currentPeriod, Timed<T>? nextPeriod, Timed<T>? prevPeriod, int currentPeriodPos}) calculatePeriodsFromTimeOfDay(
      TimeOfDay tod) {
    List<Timed<T>> periods = this;

    Timed<T>? currentPeriod;
    Timed<T>? nextPeriod;
    Timed<T>? prevPeriod;

    late int currentPeriodPos;

    for (currentPeriodPos = 0; currentPeriodPos < periods.length; currentPeriodPos++) {
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
