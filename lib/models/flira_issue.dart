import 'package:atlassian_apis/jira_platform.dart';

class FliraIssue {
  const FliraIssue(
      {this.projectKey,
      this.name,
      this.description,
      this.issueType,
      this.status,
      this.project});
  final String? projectKey;
  final String? name;
  final String? description;
  final String? issueType;
  final String? status;
  final Project? project;

  FliraIssue copyWith({
    String? projectKey,
    String? name,
    String? description,
    String? issueType,
    String? status,
    Project? project,
  }) {
    return FliraIssue(
      projectKey: projectKey ?? this.projectKey,
      name: name ?? this.name,
      description: description ?? this.description,
      issueType: issueType ?? this.issueType,
      status: status ?? this.status,
      project: project ?? this.project,
    );
  }
}
