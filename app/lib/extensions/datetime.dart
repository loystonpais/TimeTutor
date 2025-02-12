extension DateTimeHM on DateTime {
  static DateTime fromHM({required int hour, required int minute}) {
    return DateTime(0, 0, 0, hour, minute);
  }
}
