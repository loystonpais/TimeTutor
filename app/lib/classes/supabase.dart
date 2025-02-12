abstract class Id<T> {
  final T data;

  Id(this.data);
}

abstract class SupabaseObject<T> {
  final Id id;

  SupabaseObject(this.id);
}

abstract class User extends SupabaseObject {
  final String firstName;
  final String lastName;

  User(super.id, this.firstName, this.lastName);

  List<Class> getGuidingClasses();
}

abstract class Class {
  final String name;

  User getGuide();

  List<User> getStudents();

  Class(this.name);
}

abstract class Institution {
  final String name;
  final bool verified;

  List<Class> getClasses();

  Institution(this.name, this.verified);
}
