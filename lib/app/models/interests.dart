class Interests {
  Interests({this.interests, this.specificInterests});
  final List<String>? interests;
  final List<String>? specificInterests;

  factory Interests.fromMap(Map<String, dynamic> data, String documentId) {

    return Interests(
      interests: data['interests'],
      specificInterests: data['specificInterests'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'interests': interests,
      'specificInterests': specificInterests,
    };
  }
}