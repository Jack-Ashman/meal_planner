import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  List<DateTime> _getDaysForCalendar() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    int firstWeekday = firstDayOfMonth.weekday % 7; // 0=Sunday, 6=Saturday
    final firstDayToShow = firstDayOfMonth.subtract(Duration(days: firstWeekday));
    return List.generate(42, (i) => firstDayToShow.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysForCalendar();
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Month/year and navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black),
                    onPressed: _previousMonth,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${_getMonthName(_currentDate.month)} ${_currentDate.year}',
                        style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
            // Weekday headers
            Container(
              height: 36,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                children: List.generate(7, (index) =>
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        weekdays[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Calendar grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cellWidth = constraints.maxWidth / 7;
                  final cellHeight = constraints.maxHeight / 6;
                  return Column(
                    children: List.generate(6, (row) {
                      return Row(
                        children: List.generate(7, (col) {
                          final index = row * 7 + col;
                          final day = days[index];
                          final isCurrentMonth = day.month == _currentDate.month;
                          final isToday = day.year == today.year && day.month == today.month && day.day == today.day;
                          final isOtherMonth = !isCurrentMonth;
                          return Container(
                            width: cellWidth,
                            height: cellHeight,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(width: col == 6 ? 0 : 1, color: const Color(0xFFE0E0E0)),
                                bottom: BorderSide(width: row == 5 ? 0 : 1, color: const Color(0xFFE0E0E0)),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: isToday
                                    ? Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: theme.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: isOtherMonth ? Colors.grey.withAlpha(120) : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}
