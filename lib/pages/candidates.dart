class Candidate {
  final int id;
  final String name;
  final String surname;
  final String party;
  final String bio;
  final String imageUrl;

  Candidate({
    required this.id,
    required this.name,
    required this.surname,
    required this.party,
    required this.bio,
    required this.imageUrl,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      party: json['party'] ?? '',
      bio: json['bio'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'party': party,
      'bio': bio,
      'imageUrl': imageUrl,
    };
  }
}
