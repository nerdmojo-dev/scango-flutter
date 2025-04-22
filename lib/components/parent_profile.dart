import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scango/services/api_client.dart';

class ParentProfile extends StatefulWidget {
  const ParentProfile({Key? key}) : super(key: key);

  @override
  _ParentProfileState createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  final ApiClient _apiClient = ApiClient();

  String parentProfile = "Loading...";
  String parentId = "";
  String parentEmail = "";
  String childName = "";
  String relationship = "";
  String studentId = "";

  int totalDays = 0;
  int presentDays = 0;
  int absentDays = 0;

  @override
  void initState() {
    super.initState();
    fetchParentProfile();
  }

  Future<void> fetchParentProfile() async {
    try {
      final response = await _apiClient.get('/mobile/parent');
      print("👨‍👩‍👧 Parent Response: $response");

      if (response.containsKey('data')) {
        var data = response['data'];
        var user = data['userId'];
        var children = data['children'] as List<dynamic>;

        if (children.isNotEmpty) {
          var child = children[0];
          studentId = child['id'];

          await fetchStudentAttendance(studentId);

          setState(() {
            parentProfile = user['name'] ?? "Unknown";
            parentId = user['id'] ?? "N/A";
            parentEmail = user['email'] ?? "N/A";
            relationship = data['relationship'] ?? "N/A";
            childName = child['name'] ?? "N/A";
          });
        }
      }
    } catch (e) {
      print("❌ Error fetching parent profile: $e");
      setState(() {
        parentProfile = "Network Error";
        parentId = "N/A";
        parentEmail = "N/A";
        relationship = "N/A";
        childName = "N/A";
      });
    }
  }

  Future<void> fetchStudentAttendance(String studentId) async {
    try {
      final now = DateTime.now();
      final String startDate = DateFormat("yyyy-MM-01").format(now);
      final String endDate = DateFormat(
        "yyyy-MM-${DateTime(now.year, now.month + 1, 0).day}",
      ).format(now);

      final response = await _apiClient.get(
        '/mobile/student/attendance?startDate=$startDate&endDate=$endDate&studentId=$studentId',
      );
      print("📊 Attendance Response: $response");

      if (response.containsKey('data')) {
        List<dynamic> attendanceList = response['data'];

        setState(() {
          totalDays = attendanceList.length;
          presentDays =
              attendanceList.where((e) => e['status'] == 'present').length;
          absentDays =
              attendanceList.where((e) => e['status'] == 'absent').length;
        });
      }
    } catch (e) {
      print("❌ Failed to fetch attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final String monthName = DateFormat('MMMM yyyy').format(DateTime.now());

    return SingleChildScrollView(
      child: Column(
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
                      buildInfoLabel("Name", parentProfile),
                      buildInfoLabel("Parent ID", parentId),
                      buildInfoLabel("Child Name", childName),
                      buildInfoLabel("Relationship", relationship),
                      buildInfoLabel("Email", parentEmail),

                      const SizedBox(height: 6),
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
                      child: const CircleAvatar(
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
      ),
    );
  }

  Widget buildInfoLabel(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.lightBlue, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
      ],
    );
  }
}
