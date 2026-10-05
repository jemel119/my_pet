class PetModel {
  String name;
  int happiness;
  int hunger;
  int energy;
  bool gameOver;
  bool hasWon;

  PetModel({
    this.name = 'Pip',
    this.happiness = 50,
    this.hunger = 50,
    this.energy = 70,
    this.gameOver = false,
    this.hasWon = false,
  });

  int clampMeter(int value) {
    return value.clamp(0, 100).toInt();
  }

  String get mood {
    if (happiness > 70) {
      return 'Happy';
    }

    if (happiness >= 30) {
      return 'Neutral';
    }

    return 'Unhappy';
  }

  void setName(String newName) {
    final trimmedName = newName.trim();

    if (trimmedName.isNotEmpty) {
      name = trimmedName;
    }
  }

  void feed() {
    if (gameOver || hasWon) {
      return;
    }

    final nextHunger = clampMeter(hunger - 10);
    final happinessChange = nextHunger < 30 ? -20 : 10;

    hunger = nextHunger;
    happiness = clampMeter(happiness + happinessChange);

    checkLoss();
  }

  void play() {
    if (gameOver || hasWon) {
      return;
    }

    happiness = clampMeter(happiness + 10);
    hunger = clampMeter(hunger + 5);
    energy = clampMeter(energy - 10);

    checkLoss();
  }

  void increaseHunger() {
    if (gameOver || hasWon) {
      return;
    }

    if (hunger + 5 > 100) {
      hunger = 100;
      happiness = clampMeter(happiness - 20);
    } else {
      hunger += 5;
    }

    checkLoss();
  }

  void checkLoss() {
    if (hunger == 100 && happiness <= 10) {
      gameOver = true;
    }
  }

  void markWon() {
    if (!gameOver) {
      hasWon = true;
    }
  }

  void reset() {
    happiness = 50;
    hunger = 50;
    energy = 70;
    gameOver = false;
    hasWon = false;
  }
}