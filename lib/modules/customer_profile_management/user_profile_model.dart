class UserProfileModel {
  final String userId;
  final String username;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String? bio;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;

  UserProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    this.bio,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
  });

  UserProfileModel copyWith({
    String? userId,
    String? username,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    return UserProfileModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
