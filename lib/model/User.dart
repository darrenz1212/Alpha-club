class User {
  int id;
  String username;
  String password;
  String role;
  DateTime? membershipEnd; 

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.membershipEnd, 
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      membershipEnd: json['membership_end'] != null
          ? DateTime.parse(json['membership_end'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'membership_end': membershipEnd?.toIso8601String(),
    };
  }
}
