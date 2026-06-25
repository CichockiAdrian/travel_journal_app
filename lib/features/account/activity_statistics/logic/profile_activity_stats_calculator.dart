import '../../../trip_diary/data/trip_diary_entry.dart';
import '../../../visited_countries/data/visited_country_model.dart';
import '../data/activity_day_stats.dart';
import '../data/profile_activity_stats.dart';

class ProfileActivityStatsCalculator {
  static const int defaultCalendarDays = 30;

  const ProfileActivityStatsCalculator();

  ProfileActivityStats calculate({
    required List<TripDiaryEntry> entries,
    required List<VisitedCountryModel> visitedCountries,
    DateTime? today,
    int calendarDays = defaultCalendarDays,
  }) {
    final normalizedToday = _normalizeDate(today ?? DateTime.now());
    final statsByDate = <DateTime, _MutableActivityDayStats>{};

    var photosCount = 0;
    var notesCount = 0;

    for (final entry in entries) {
      final entryPhotosCount = entry.photosCount.toInt();

      photosCount += entryPhotosCount;
      notesCount += 1;

      final entryDate = _entryActivityDate(entry);
      if (entryDate == null) continue;

      final date = _normalizeDate(entryDate);
      final dayStats = statsByDate.putIfAbsent(
        date,
        () => _MutableActivityDayStats(date),
      );

      dayStats.notesCount += 1;
      dayStats.photosCount += entryPhotosCount;
    }

    for (final visitedCountry in visitedCountries) {
      final visitedAt = visitedCountry.visitedAt;
      if (visitedAt == null) continue;

      final date = _normalizeDate(visitedAt);
      final dayStats = statsByDate.putIfAbsent(
        date,
        () => _MutableActivityDayStats(date),
      );

      dayStats.visitedCountriesCount += 1;
    }

    final activeDates = statsByDate.values
        .where((stats) => stats.isActive)
        .map((stats) => stats.date)
        .toSet();

    return ProfileActivityStats(
      currentStreak: _calculateCurrentStreak(
        activeDates: activeDates,
        today: normalizedToday,
      ),
      longestStreak: _calculateLongestStreak(activeDates),
      activeDaysCount: activeDates.length,
      photosCount: photosCount,
      notesCount: notesCount,
      visitedCountriesCount: visitedCountries.length,
      dailyStats: _buildMonthStats(
        statsByDate: statsByDate,
        monthDate: normalizedToday,
      ),
    );
  }

  DateTime? _entryActivityDate(TripDiaryEntry entry) {
    return entry.createdAt ?? entry.travelDate ?? entry.updatedAt;
  }

  List<ActivityDayStats> _buildMonthStats({
    required Map<DateTime, _MutableActivityDayStats> statsByDate,
    required DateTime monthDate,
  }) {
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month);
    final lastDayOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    return List.generate(daysInMonth, (index) {
      final date = firstDayOfMonth.add(Duration(days: index));
      final stats = statsByDate[date];

      return ActivityDayStats(
        date: date,
        photosCount: stats?.photosCount ?? 0,
        notesCount: stats?.notesCount ?? 0,
        visitedCountriesCount: stats?.visitedCountriesCount ?? 0,
      );
    });
  }

  int _calculateCurrentStreak({
    required Set<DateTime> activeDates,
    required DateTime today,
  }) {
    if (activeDates.isEmpty) return 0;

    var cursor = activeDates.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));

    var streak = 0;

    while (activeDates.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  int _calculateLongestStreak(Set<DateTime> activeDates) {
    if (activeDates.isEmpty) return 0;

    final sortedDates = activeDates.toList()..sort();

    var longestStreak = 1;
    var currentStreak = 1;

    for (var i = 1; i < sortedDates.length; i++) {
      final previousDate = sortedDates[i - 1];
      final currentDate = sortedDates[i];

      final differenceInDays = currentDate.difference(previousDate).inDays;

      if (differenceInDays == 1) {
        currentStreak += 1;
      } else if (differenceInDays > 1) {
        currentStreak = 1;
      }

      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
    }

    return longestStreak;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

class _MutableActivityDayStats {
  final DateTime date;

  int photosCount = 0;
  int notesCount = 0;
  int visitedCountriesCount = 0;

  _MutableActivityDayStats(this.date);

  bool get isActive {
    return photosCount > 0 || notesCount > 0 || visitedCountriesCount > 0;
  }
}
