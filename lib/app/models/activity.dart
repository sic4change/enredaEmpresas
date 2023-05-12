class Activity {
  Activity({this.id, required this.name, this.competencies = const {},  this.activities,
  });

  factory Activity.fromMap(Map<String, dynamic> data, String documentId) {
    final String id = data['id'];
    final String name = data['name'];

    Map<String, int> competencies = {};
    if (data['competencies'] != null) {
      data['competencies'].forEach((competency) {
        competencies[competency['competencyId']] = competency['points'];
      });
    }

    List<String> activities = [];
    if (data['activities'] != null) {
      data['activities'].forEach((participant) {activities.add(participant.toString());});
    }

    return Activity(
      id: id,
      name: name,
      competencies: competencies,
      activities: activities,
    );
  }

  final String? id;
  final String name;
  final Map<String, int> competencies;
  final List<String>? activities;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activities': activities,
    };
  }
}