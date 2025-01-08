import 'dart:convert';

class Task {
  String id;
  String task;
  DateTime dateCreated;
  DateTime dateModified;
  int priority;
  List<String> contextTags;
  List<String> projectTags;
  DateTime? due;
  bool done;

  Task({
    required this.id,
    required this.task,
    required this.dateCreated,
    required this.dateModified,
    required this.priority,
    required this.contextTags,
    required this.projectTags,
    this.due,
    required this.done,
  });

  Task copyWith({
    String? id,
    String? task,
    DateTime? dateCreated,
    DateTime? dateModified,
    int? priority,
    List<String>? contextTags,
    List<String>? projectTags,
    DateTime? due,
    bool? done,
  }) =>
      Task(
        id: id ?? this.id,
        task: task ?? this.task,
        dateCreated: dateCreated ?? this.dateCreated,
        dateModified: dateModified ?? this.dateModified,
        priority: priority ?? this.priority,
        contextTags: contextTags ?? this.contextTags,
        projectTags: projectTags ?? this.projectTags,
        due: due ?? this.due,
        done: done ?? this.done,
      );

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        task: json["task"],
        dateCreated: DateTime.parse(json["dateCreated"]),
        dateModified: DateTime.parse(json["dateModified"]),
        priority: json["priority"],
        contextTags: json["contextTags"] != null
            ? (json["contextTags"] as String).isEmpty
                ? (json["contextTags"] as String)
                    .split(",")
                    .map((e) => e)
                    .toList()
                : <String>[]
            : <String>[],
        projectTags: json["projectTags"] != null
            ? (json["projectTags"] as String).isEmpty
                ? (json["projectTags"] as String)
                    .split(",")
                    .map((e) => e)
                    .toList()
                : <String>[]
            : <String>[],
        due: json["due"] != null ? DateTime.tryParse(json["due"]) : null,
        done: json["done"] == 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
        "dateCreated": dateCreated.toIso8601String(),
        "dateModified": dateModified.toIso8601String(),
        "priority": priority,
        "contextTags": contextTags.join(","),
        "projectTags": projectTags.join(","),
        "due": due?.toIso8601String(),
        "done": done ? 1 : 0,
      };
}
