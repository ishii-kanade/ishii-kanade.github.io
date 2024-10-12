import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_view_model.dart'; // ViewModelをインポート

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar App'),
        ),
        body: Column(
          children: [
            // カレンダー部分
            Consumer<CalendarViewModel>(
              builder: (context, viewModel, child) {
                return TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: viewModel.focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(viewModel.selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    viewModel.selectDay(selectedDay, focusedDay);
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // 選択された日付の表示
            Consumer<CalendarViewModel>(
              builder: (context, viewModel, child) {
                return viewModel.selectedDay != null
                    ? Text(
                        '選択された日付: ${viewModel.selectedDay!.year}-${viewModel.selectedDay!.month}-${viewModel.selectedDay!.day}',
                        style: const TextStyle(fontSize: 20),
                      )
                    : const Text('日付が選択されていません。');
              },
            ),
          ],
        ),
      ),
    );
  }
}
