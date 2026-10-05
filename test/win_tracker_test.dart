import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/models/win_tracker.dart';

void main() {
  group('WinTracker', () {
    test('does not win before three continuous minutes', () {
      final tracker = WinTracker();

      final won = tracker.update(
        happiness: 81,
        elapsed: const Duration(minutes: 2, seconds: 59),
      );

      expect(won, false);
      expect(
        tracker.highHappinessDuration,
        const Duration(minutes: 2, seconds: 59),
      );
    });

    test('wins at three continuous minutes above 80', () {
      final tracker = WinTracker();

      tracker.update(
        happiness: 81,
        elapsed: const Duration(minutes: 2),
      );

      final won = tracker.update(
        happiness: 81,
        elapsed: const Duration(minutes: 1),
      );

      expect(won, true);
      expect(
        tracker.highHappinessDuration,
        const Duration(minutes: 3),
      );
    });

    test('exactly 80 does not qualify', () {
      final tracker = WinTracker();

      final won = tracker.update(
        happiness: 80,
        elapsed: const Duration(minutes: 3),
      );

      expect(won, false);
      expect(
        tracker.highHappinessDuration,
        Duration.zero,
      );
    });

    test('dropping to 80 resets continuous progress', () {
      final tracker = WinTracker();

      tracker.update(
        happiness: 90,
        elapsed: const Duration(minutes: 2, seconds: 59),
      );

      final won = tracker.update(
        happiness: 80,
        elapsed: const Duration(seconds: 1),
      );

      expect(won, false);
      expect(
        tracker.highHappinessDuration,
        Duration.zero,
      );
    });

    test('a new period starts after happiness rises above 80 again', () {
      final tracker = WinTracker();

      tracker.update(
        happiness: 90,
        elapsed: const Duration(minutes: 2, seconds: 59),
      );

      tracker.update(
        happiness: 80,
        elapsed: const Duration(seconds: 1),
      );

      final firstNewPeriod = tracker.update(
        happiness: 90,
        elapsed: const Duration(minutes: 2),
      );

      final completedNewPeriod = tracker.update(
        happiness: 90,
        elapsed: const Duration(minutes: 1),
      );

      expect(firstNewPeriod, false);
      expect(completedNewPeriod, true);
    });

    test('reset clears accumulated high happiness time', () {
      final tracker = WinTracker();

      tracker.update(
        happiness: 90,
        elapsed: const Duration(minutes: 2),
      );

      tracker.reset();

      expect(
        tracker.highHappinessDuration,
        Duration.zero,
      );
    });
  });
}