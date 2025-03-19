import 'package:flutter/material.dart';
import 'package:timetutor/models/misc.dart';
import 'package:timetutor/extensions/extensions.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';

class TimetablePeriodCountdown extends StatefulWidget {
  final DateTime Function() time;
  final Timetable timetable;
  final Duration updateDuration;

  TimetablePeriodCountdown({
    super.key,
    DateTime Function()? time,
    required this.timetable,
    Duration? updateDuration,
  })  : updateDuration = updateDuration ?? Duration(seconds: 1),
        time = time ?? (() => DateTime.now());

  @override
  State<TimetablePeriodCountdown> createState() => _TimetablePeriodCountdownState();
}

class _TimetablePeriodCountdownState extends State<TimetablePeriodCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.updateDuration, (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = widget.time();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    final TimeOfDay tod = TimeOfDay(hour: now.hour, minute: now.minute);

    final Timetable timetable = widget.timetable;

    final dayWithPeriods = timetable.dayWithPeriods;
    //print(dayWithPeriods);

    final List<Timed<PeriodWithSubject>> currentDayPeriod = dayWithPeriods.getDayFromDateInt(now.weekday);
    //print("current day is ${now.weekday}");
    final List<Timed<PeriodWithSubject>> periods = currentDayPeriod;
    periods.sort((a, b) => a.timing.startTime.toTimeOfDay().compareTo(b.timing.endTime.toTimeOfDay()));
    //print("Length of the periods is ${periods.length}");

    final (
      :currentPeriod,
      :nextPeriod,
      :prevPeriod,
      :currentPeriodPos,
    ) = periods.calculatePeriodsFromTimeOfDay(tod);

    //print("before return");

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPeriod != null) Text("${currentPeriodPos + 1}/${periods.length}"),
          SizedBox(
            width: 350,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                currentPeriod != null ? currentPeriod.object.subject.name : "You're Free",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  shadows: [
                    // if (currentSettings.enablePeriodNameShadow)
                    if (false) Shadow(color: Theme.of(context).primaryColor, blurRadius: 0, offset: const Offset(2.0, 0))
                  ],
                ),
              ),
            ),
          ),
          Text(
            currentPeriod != null ? currentPeriod.timing.toString() : "Yup, you heard it right",
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          const SizedBox(height: 10),
          if (currentPeriod != null)
            LinearPercentIndicator(
              alignment: MainAxisAlignment.center,
              linearGradient: /*currentSettings.mainBarGradient*/ true
                  ? LinearGradient(colors: [
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColor,
                    ])
                  : null,
              progressColor: /*(!currentSettings.mainBarGradient)*/
                  true ? Theme.of(context).toggleButtonsTheme.color : null,
              backgroundColor: Colors.grey.withOpacity(0.3),
              barRadius: const Radius.circular(5),
              width: 120.0,
              lineHeight: 3.0,
              percent: tod.deviation(from: currentPeriod.timing.startTime.toTimeOfDay(), to: currentPeriod.timing.endTime.toTimeOfDay()),
              animation: true,
              animateFromLastPercent: true,
              animationDuration: 1000,
            ),
          const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (periods.isEmpty)
                const Text(
                  "You don't have any periods for today!",
                )
              else if (currentPeriod == periods.last)
                const Text(
                  "This is your last period for today!",
                )
              else if (nextPeriod != null)
                Text(
                  "${nextPeriod.object.subject.name}"
                  " ${Jiffy.parseFromDateTime(DateTime(now.year, now.month, now.day, nextPeriod.timing.startTime.hour, nextPeriod.timing.startTime.minute)).fromNow()}",
                )
              else
                const Text(
                  "No more periods for today!",
                ),
              const SizedBox(height: 10),
              if (/*currentSettings.displayPrevPeriod*/ true && prevPeriod != null)
                Text(
                  "${prevPeriod.object.subject.name} was ${Jiffy.parseFromDateTime(DateTime(now.year, now.month, now.day, prevPeriod.timing.startTime.hour, prevPeriod.timing.startTime.minute)).fromNow()}",
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          )
        ],
      ),
    );
  }
}
