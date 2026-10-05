class WinTracker {
  static const Duration requiredDuration = Duration(minutes: 3);

  Duration _highHappinessDuration = Duration.zero;

  Duration get highHappinessDuration => _highHappinessDuration;

  bool update({
    required int happiness,
    required Duration elapsed,
  }) {
    if (happiness <= 80) {
      reset();
      return false;
    }

    _highHappinessDuration += elapsed;

    return _highHappinessDuration >= requiredDuration;
  }

  void reset() {
    _highHappinessDuration = Duration.zero;
  }
}