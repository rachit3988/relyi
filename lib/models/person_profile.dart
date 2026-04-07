class PersonProfile {
  String name;
  String personality;
  String relationship;
  String notes;

  PersonProfile({
    required this.name,
    required this.personality,
    required this.relationship,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'personality': personality,
    'relationship': relationship,
    'notes': notes,
  };

  factory PersonProfile.fromJson(Map<String, dynamic> json) {
    return PersonProfile(
      name: json['name'],
      personality: json['personality'],
      relationship: json['relationship'],
      notes: json['notes'],
    );
  }
}
