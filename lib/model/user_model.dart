
class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final d = json['data'];
    return UserProfile(
      id: d['id'],
      firstName: d['first_name'],
      lastName: d['last_name'],
      email: d['email'],
      avatar: d['avatar'],
    );
  }
}