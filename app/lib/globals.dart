import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timetutor/classes/classes.dart';
import 'package:timetutor/classes/supabase.dart';

var logger = Logger();
var isWeb = kIsWeb;

final client = Supabase.instance.client;

late User authUser;

late UserProfile? userProfile;
late Class? userJoinedClass;
late StandardTimetable? joinedClassTimetable;
late Institution userJoinedInstitution;
