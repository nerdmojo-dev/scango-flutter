import 'package:flutter/material.dart';
import 'package:scango/lib.dart'; // Your custom library
import 'package:scango/pages/signin/student.dart'; // Import StudentPage
import 'package:scango/pages/signin/parent.dart'; // Import ParentPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    final apiClient = ApiClient();
    final response = await apiClient.getDummy();
    Utility.printLog(response.data);
  }

  void onStudentPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentPage()),
    );
  }

  void onParentPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentPage()),
    );
  }

  Widget buildGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF7451DF),
              Color(0xFF776AE6),
              Color(0xFF7971E9),
              Color(0xFF7B7FEC),
              Color(0xFF7B7FEC),
            ], // Updated colors
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 70, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGradientButton(
              icon: Icons.school_outlined,
              label: 'Student',
              onPressed: onStudentPressed,
            ),
            const SizedBox(height: 70),
            buildGradientButton(
              icon: Icons.person_2_outlined,
              label: 'Parent',
              onPressed: onParentPressed,
            ),
          ],
        ),
      ),
    );
  }
}
