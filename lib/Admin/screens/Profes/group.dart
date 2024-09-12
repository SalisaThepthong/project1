class Group {
  final String id;
  final String name;
  final List<Member> members;

  Group({
    required this.id,
    required this.name,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      members: List<Member>.from(
        json['members'].map((memberJson) => Member.fromJson(memberJson)),
      ),
    );
  }
}

class Member {
  final String id;
  final String prefix;
  final String name;
  final String lastName;
  final String email;
  final String facebook;

  Member({
    required this.id,
    required this.prefix,
    required this.name,
    required this.lastName,
    required this.email,
    required this.facebook,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      prefix: json['prefix'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      facebook: json['facebook'],
    );
  }
}