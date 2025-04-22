import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scango/services/api_client.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final ApiClient _apiClient = ApiClient();

  String studentName = "Loading...";
  String studentId = "";
  String studentEmail = "";
  String studentRollNumber = "";

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
    // print('init');
  }

  Future<void> fetchStudentProfile() async {
    try {
      // print('📡 Fetching Student Profile...');
      final response = await _apiClient.get('/mobile/student/profile');
      // print("🔹Student API Response: $response");
      if (response.containsKey('data')) {
        var data = response['data'];
        // print("✅ Extracted Data: $data"); // Debugging
        setState(() {
          studentName = data['name'] ?? "Unknown";
          studentId = data['userId'] ?? "N/A";
          studentEmail = data['email'] ?? "N/A";
          studentRollNumber = data['rollNumber'] ?? "N/A";
        });
        // print(
        //   "🎯 Name: $studentName, Roll: $studentId, Email: $studentEmail",
        // ); // Debugging
      } else {
        setState(() {
          studentName = "Data Not Found";
          studentId = "N/A";
          studentEmail = "N/A";
          studentRollNumber = "N/A";
        });
      }
    } catch (e) {
      // print("❌ Error: $e");
      setState(() {
        studentName = "Network Error";
        studentId = "N/A";
        studentEmail = "N/A";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'Name',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Student ID',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Roll Number',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentRollNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Email',
                      style: TextStyle(color: Colors.lightBlue, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studentEmail,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightBlue,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
