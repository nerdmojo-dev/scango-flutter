class StudentProfileModel {
  final String name;
  final String id;
  final String phone;
  final String email;

  StudentProfileModel({
    required this.name,
    required this.id,
    required this.phone,
    required this.email,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      name: json['name'] ?? '',
      id: json['studentId'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
