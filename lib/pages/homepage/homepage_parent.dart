import 'package:flutter/material.dart';
import 'package:scango/components/custom.dart';
import 'package:scango/components/parent_profile.dart';
import 'package:scango/components/notification.dart'; // Make sure this import exists
import 'package:scango/services/api_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiClient _apiClient = ApiClient();

  int _selectedIndex = 0;
  String studentName = "Loading...";
  Map<String, String> attendanceData = {};
  bool isLoading = true;
  int totalDaysInMonth = 0;
  int presentDays = 0;
  int absentDays = 0;
  int holidayDays = 0;

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
    fetchStudentAttendance();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchStudentProfile() async {
    try {
      final response = await _apiClient.get('/mobile/parent');
      print(response);
      if (response.containsKey('data')) {
        var data = response['data'];
        setState(() {
          studentName = data['name'] ?? "Unknown";
        });
      } else {
        setState(() {
          studentName = "Data Not Found";
        });
      }
    } catch (e) {
      setState(() {
        studentName = "Network Error";
      });
    }
  }

  Future<void> fetchStudentAttendance() async {
    try {
      final response = await _apiClient.get(
        '/mobile/student/attendance?startDate=2025-04-01&endDate=2025-04-30',
      );

      if (response != null && response.containsKey('data')) {
        List<dynamic> logs = response['data'][0]['attendanceLogs'];
        Map<String, String> newAttendanceData = {};

        for (var log in logs) {
          if (log.containsKey('date') && log.containsKey('status')) {
            String date = log['date'].split("T")[0];
            String status = log['status'];
            newAttendanceData[date] = status;
          }
        }

        int totalDays = DateTime(2025, 5, 0).day;
        int present = 0;
        int absent = 0;
        int weekendHolidays = 0;

        DateTime today = DateTime.now();
        today = DateTime(today.year, today.month, today.day); // Strip time

        for (int i = 1; i <= totalDays; i++) {
          DateTime date = DateTime(2025, 4, i);
          String dateStr = date.toIso8601String().split("T")[0];
          bool isWeekend =
              date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday;

          if (newAttendanceData.containsKey(dateStr)) {
            if (newAttendanceData[dateStr] == 'present') {
              present++;
            } else if (newAttendanceData[dateStr] == 'absent') {
              absent++;
            }
          } else if (isWeekend) {
            weekendHolidays++;
          } else if (date.isBefore(today)) {
            absent++; // ✅ only count as absent if it's a past weekday and unmarked
          }
        }

        if (mounted) {
          setState(() {
            attendanceData = newAttendanceData;
            totalDaysInMonth = totalDays;
            presentDays = present;
            absentDays = absent;
            holidayDays = weekendHolidays;
            isLoading = false;
          });
        }
      } else {
        throw Exception("API returned null or unexpected format.");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching attendance: $e");
    }
  }

  Widget _buildStatBox(String label, int value, Color numberColor) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: numberColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 400,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 10),
                // Use Expanded to make NotificationList take remaining scrollable space
                const Expanded(
                  child: SingleChildScrollView(child: NotificationList()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          studentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Parent',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Settings + Notification Icons
                Row(
                  children: [
                    GestureDetector(
                      onTap: _showNotificationsPopup,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Total',
                    totalDaysInMonth,
                    Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatBox('Holiday', holidayDays, Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatBox('Present', presentDays, Colors.green),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatBox('Absent', absentDays, Colors.pinkAccent),
                ),
              ],
            ),

            const SizedBox(height: 20),
            if (_selectedIndex == 0)
              ParentProfile()
            else if (_selectedIndex == 1)
              const CustomCalendar()
            else
              Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Attendance',
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
