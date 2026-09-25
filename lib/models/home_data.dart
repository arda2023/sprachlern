import 'package:flutter/widgets.dart';

enum DayStatus { done, empty, today }

class WeekDay {
  const WeekDay({required this.label, required this.status});

  final String label;
  final DayStatus status;
}

class DailyGoal {
  const DailyGoal({
    required this.current,
    required this.target,
    required this.week,
  });

  final int current;
  final int target;
  final List<WeekDay> week;
}

class PromoContent {
  const PromoContent({required this.title, required this.description});

  final String title;
  final String description;
}

class ProgressStats {
  const ProgressStats({
    required this.knownPercent,
    required this.wordsBase,
    required this.totalWords,
    required this.availableReviews,
  });

  final int knownPercent;
  final int wordsBase;
  final int totalWords;
  final int availableReviews;
}

class ActivityEntry {
  const ActivityEntry({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

class HomeData {
  const HomeData({
    required this.goal,
    required this.promos,
    required this.stats,
    required this.activities,
  });

  final DailyGoal goal;
  final List<PromoContent> promos;
  final ProgressStats stats;
  final List<ActivityEntry> activities;
}
