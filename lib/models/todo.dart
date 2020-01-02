class Todo {
  final String id;
  final String description;
  bool isDone = false;
  final DateTime dateCreated;

  Todo({this.id, this.description, this.isDone, this.dateCreated});

  static const String FIRESTORE_COLLECTION = "Todos";
  static const String COLUMN_ID = "id";
  static const String COLUMN_USER_ID = "user";
  static const String COLUMN_DESCRIPTION = "text";
  static const String COLUMN_IS_DONE = "isDone";
  static const String COLUMN_DATE_CREATED = "created";
}
