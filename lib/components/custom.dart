import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scango/services/api_client.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key}) : super(key: key);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final ApiClient _apiClient = ApiClient();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, String> attendanceData = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentAttendance();
  }

  Future<void> fetchStudentAttendance() async {
    try {
      final response = await _apiClient.get(
        '/mobile/student/attendance?startDate=2025-04-01&endDate=2025-04-30',
      );
      print("🔹 Attendance API Response: $response");

      Map<String, String> freshAttendanceData = {};

      if (response != null &&
          response.containsKey('data') &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0].containsKey('attendanceLogs')) {
        List<dynamic> logs = response['data'][0]['attendanceLogs'];

        for (var log in logs) {
          if (log.containsKey('date') && log.containsKey('status')) {
            String date = log['date'].split("T")[0];
            String status = log['status'];
            freshAttendanceData[date] = status;
          }
        }
      }

      print("✅ Final Attendance Map: $freshAttendanceData");

      if (mounted) {
        setState(() {
          attendanceData = freshAttendanceData;
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching attendance: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildDayCell(
    DateTime day,
    DateTime focusedDay, {
    bool isToday = false,
  }) {
    final today = DateTime.now();
    final String dateKey = day.toIso8601String().split("T")[0];
    final bool isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    final bool isPast = day.isBefore(
      DateTime(today.year, today.month, today.day),
    );
    final String? status = attendanceData[dateKey];

    Color bgColor = Colors.grey;

    if (status == 'present') {
      bgColor = Colors.green;
    } else if (status == 'absent') {
      bgColor = Colors.red;
    } else if (isPast && !isWeekend) {
      // If date has passed and it's not a weekend but no data => Absent
      bgColor = Colors.red;
    } else if (isWeekend) {
      bgColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: Colors.black, width: 2) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, focusedDay, isToday: false);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, focusedDay, isToday: true);
                },
              ),
            ),
          ),
        );
  }
}
