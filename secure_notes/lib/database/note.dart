class Note {
  int id;
  String title;
  String description;
  String notedate;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.notedate
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notedate': notedate
    };
  }
}