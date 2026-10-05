import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/models/pet_model.dart';

void main() {
  group('PetModel initial state', () {
    test('starts with the correct default values', () {
      final pet = PetModel();

      expect(pet.name, 'Pip');
      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 70);
      expect(pet.gameOver, false);
      expect(pet.hasWon, false);
    });

    test('sets a valid pet name', () {
      final pet = PetModel();

      pet.setName('Buddy');

      expect(pet.name, 'Buddy');
    });

    test('does not replace the name with an empty value', () {
      final pet = PetModel();

      pet.setName('   ');

      expect(pet.name, 'Pip');
    });
  });

  group('PetModel feed behavior', () {
    test('feed lowers hunger and increases happiness', () {
      final pet = PetModel();

      pet.feed();

      expect(pet.hunger, 40);
      expect(pet.happiness, 60);
    });

    test('feed clamps hunger at zero', () {
      final pet = PetModel(
        happiness: 50,
        hunger: 5,
      );

      pet.feed();

      expect(pet.hunger, 0);
      expect(pet.happiness, 30);
    });

    test('feed at high hunger applies the resulting hunger rule', () {
      final pet = PetModel(
        happiness: 50,
        hunger: 95,
      );

      pet.feed();

      expect(pet.hunger, 85);
      expect(pet.happiness, 60);
    });

    test('happiness never exceeds 100 after feeding', () {
      final pet = PetModel(
        happiness: 95,
        hunger: 50,
      );

      pet.feed();

      expect(pet.happiness, 100);
      expect(pet.hunger, 40);
    });
  });

  group('PetModel play and energy behavior', () {
    test('play updates happiness hunger and energy', () {
      final pet = PetModel();

      pet.play();

      expect(pet.happiness, 60);
      expect(pet.hunger, 55);
      expect(pet.energy, 60);
    });

    test('play keeps happiness within 100', () {
      final pet = PetModel(
        happiness: 95,
      );

      pet.play();

      expect(pet.happiness, 100);
    });

    test('play keeps energy within zero to 100', () {
      final pet = PetModel(
        energy: 5,
      );

      pet.play();

      expect(pet.energy, 0);
    });
  });

  group('PetModel activity selection', () {
    test('run updates meters when enough energy is available', () {
      final pet = PetModel();

      pet.run();

      expect(pet.happiness, 65);
      expect(pet.hunger, 60);
      expect(pet.energy, 50);
    });

    test('run does nothing when energy is too low', () {
      final pet = PetModel(
        energy: 10,
      );

      pet.run();

      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 10);
    });

    test('sleep restores energy', () {
      final pet = PetModel(
        energy: 50,
      );

      pet.sleep();

      expect(pet.energy, 80);
      expect(pet.hunger, 60);
    });

    test('sleep does not allow energy above 100', () {
      final pet = PetModel(
        energy: 90,
      );

      pet.sleep();

      expect(pet.energy, 100);
      expect(pet.hunger, 60);
    });
  });

  group('PetModel hunger timer behavior', () {
    test('hunger tick increases hunger by 5', () {
      final pet = PetModel();

      pet.increaseHunger();

      expect(pet.hunger, 55);
    });

    test('first tick from 95 reaches 100 without happiness penalty', () {
      final pet = PetModel(
        happiness: 50,
        hunger: 95,
      );

      pet.increaseHunger();

      expect(pet.hunger, 100);
      expect(pet.happiness, 50);
    });

    test('tick beyond 100 lowers happiness by 20', () {
      final pet = PetModel(
        happiness: 50,
        hunger: 100,
      );

      pet.increaseHunger();

      expect(pet.hunger, 100);
      expect(pet.happiness, 30);
    });

    test('hunger penalty does not lower happiness below zero', () {
      final pet = PetModel(
        happiness: 15,
        hunger: 100,
      );

      pet.increaseHunger();

      expect(pet.hunger, 100);
      expect(pet.happiness, 0);
      expect(pet.gameOver, true);
    });
  });

  group('PetModel mood boundaries', () {
    test('29 happiness is unhappy', () {
      expect(PetModel(happiness: 29).mood, 'Unhappy');
    });

    test('30 happiness is neutral', () {
      expect(PetModel(happiness: 30).mood, 'Neutral');
    });

    test('70 happiness is neutral', () {
      expect(PetModel(happiness: 70).mood, 'Neutral');
    });

    test('71 happiness is happy', () {
      expect(PetModel(happiness: 71).mood, 'Happy');
    });
  });

  group('PetModel outcomes', () {
    test('loss occurs at 100 hunger and 10 happiness', () {
      final pet = PetModel(
        happiness: 10,
        hunger: 100,
      );

      pet.checkLoss();

      expect(pet.gameOver, true);
    });

    test('loss occurs below 10 happiness at 100 hunger', () {
      final pet = PetModel(
        happiness: 5,
        hunger: 100,
      );

      pet.checkLoss();

      expect(pet.gameOver, true);
    });

    test('loss does not occur when happiness is above 10', () {
      final pet = PetModel(
        happiness: 11,
        hunger: 100,
      );

      pet.checkLoss();

      expect(pet.gameOver, false);
    });

    test('loss does not occur when hunger is below 100', () {
      final pet = PetModel(
        happiness: 10,
        hunger: 99,
      );

      pet.checkLoss();

      expect(pet.gameOver, false);
    });

    test('markWon records a win when game is active', () {
      final pet = PetModel();

      pet.markWon();

      expect(pet.hasWon, true);
    });

    test('markWon cannot override game over', () {
      final pet = PetModel(
        gameOver: true,
      );

      pet.markWon();

      expect(pet.hasWon, false);
    });

    test('actions stop changing state after game over', () {
      final pet = PetModel(
        happiness: 10,
        hunger: 100,
        energy: 50,
        gameOver: true,
      );

      pet.feed();
      pet.play();
      pet.run();
      pet.sleep();
      pet.increaseHunger();

      expect(pet.happiness, 10);
      expect(pet.hunger, 100);
      expect(pet.energy, 50);
    });

    test('actions stop changing state after a win', () {
      final pet = PetModel(
        happiness: 90,
        hunger: 50,
        energy: 50,
        hasWon: true,
      );

      pet.feed();
      pet.play();
      pet.run();
      pet.sleep();
      pet.increaseHunger();

      expect(pet.happiness, 90);
      expect(pet.hunger, 50);
      expect(pet.energy, 50);
    });
  });

  group('PetModel reset behavior', () {
    test('reset restores meters and outcome flags', () {
      final pet = PetModel(
        name: 'Buddy',
        happiness: 10,
        hunger: 100,
        energy: 5,
        gameOver: true,
        hasWon: false,
      );

      pet.reset();

      expect(pet.name, 'Buddy');
      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 70);
      expect(pet.gameOver, false);
      expect(pet.hasWon, false);
    });

    test('reset clears a win', () {
      final pet = PetModel(
        happiness: 90,
        hunger: 40,
        energy: 80,
        hasWon: true,
      );

      pet.reset();

      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 70);
      expect(pet.gameOver, false);
      expect(pet.hasWon, false);
    });
  });
  group('PetModel derived messages', () {
  test('shows a neutral message for the initial state', () {
    final pet = PetModel();

    expect(pet.message, 'Pip is doing okay.');
  });

  test('shows a hungry message when hunger is high', () {
    final pet = PetModel(
      hunger: 80,
    );

    expect(pet.message, 'Pip is very hungry.');
  });

  test('shows a rest message when energy is low', () {
    final pet = PetModel(
      hunger: 50,
      energy: 20,
    );

    expect(pet.message, 'Pip needs some rest.');
  });

  test('shows a happy message when happiness is above 70', () {
    final pet = PetModel(
      happiness: 71,
    );

    expect(pet.message, 'Pip is feeling great!');
  });

  test('shows an attention message when happiness is below 30', () {
    final pet = PetModel(
      happiness: 29,
    );

    expect(pet.message, 'Pip needs some attention.');
  });

  test('game over message takes priority', () {
    final pet = PetModel(
      happiness: 5,
      hunger: 100,
      gameOver: true,
    );

    expect(pet.message, 'Pip needs a fresh start.');
  });

  test('win message takes priority when the pet has won', () {
    final pet = PetModel(
      happiness: 90,
      hasWon: true,
    );

    expect(pet.message, 'Pip is thriving!');
  });

  test('message uses the confirmed pet name', () {
    final pet = PetModel();

    pet.setName('Buddy');

    expect(pet.message, 'Buddy is doing okay.');
  });
});
}