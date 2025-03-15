import 'package:json_annotation/json_annotation.dart';

class Id<T> {
  final T data;

  Id(this.data);
}

class SupabaseObject {
  final Id<String> id;

  SupabaseObject({required this.id});
}

class UserProfile extends SupabaseObject {
  final String name;

  UserProfile({required super.id, required this.name});

  // List<Class> getGuidingClasses();
}

class Class extends SupabaseObject {
  final String name;

  // User getGuide();

  // List<User> getStudents();

  Class({required super.id, required this.name});
}

class Institution extends SupabaseObject {
  final String name;
  final bool verified;

  // List<Class> getClasses();

  Institution({required super.id, required this.name, required this.verified});
}
