import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/home_data.dart';

const _mockHomeData = HomeData(
  goal: DailyGoal(
    current: 24,
    target: 50,
    week: [
      WeekDay(label: 'Mo', status: DayStatus.done),
      WeekDay(label: 'Di', status: DayStatus.done),
      WeekDay(label: 'Mi', status: DayStatus.empty),
      WeekDay(label: 'Do', status: DayStatus.done),
      WeekDay(label: 'Fr', status: DayStatus.today),
      WeekDay(label: 'Sa', status: DayStatus.empty),
      WeekDay(label: 'So', status: DayStatus.empty),
    ],
  ),
  promos: [
    PromoContent(
      title: 'Stapel-Revue',
      description: 'Wiederhole deine gelernten Stapel, ohne neue Wörter zu sehen.',
    ),
  ],
  stats: ProgressStats(
    knownPercent: 93,
    wordsBase: 1433,
    totalWords: 1456,
    availableReviews: 0,
  ),
  activities: [
    ActivityEntry(icon: Icons.style_outlined, title: 'Alltagswortschatz'),
    ActivityEntry(icon: Icons.flight_outlined, title: 'Reise und Unterwegs'),
  ],
);

final homeProvider = Provider<HomeData>((ref) => _mockHomeData);
