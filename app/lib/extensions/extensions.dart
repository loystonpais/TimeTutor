import 'package:timetutor/classes/classes.dart';

export 'datetime.dart';

extension Timetutor on String {
  Subject toSubject() {
    return Subject(name: this);
  }
}
