import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  Task(
    this.id,
    this.title,
    this.description,
    this.completedAt,
  );

  String id;
  String title;
  String description;
  @JsonKey(name: 'completed_at')
  DateTime completedAt;

  bool get isNew {
    return id == null;
  }

  bool get isCompleted {
    return completedAt != null;
  }

  void toggleComplete() {
    if (isCompleted) {
      completedAt = null;
    } else {
      completedAt = DateTime.now();
    }
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['id'] ?? '',
      json['title'] ?? 'No title',
      json['description'] ?? 'No Description',
      json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed_at':
          completedAt != null ? completedAt.toIso8601String() : null,
    };
  }

  // factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$TaskToJson(this);
}
