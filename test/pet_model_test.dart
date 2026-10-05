import 'package:flutter_test/flutter_test.dart';
import 'package:digital_pet/models/pet_model.dart';

void main() {
  group('PetModel', () {
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

    test('feed lowers hunger and increases happiness', () {
      final pet = PetModel();

      pet.feed();

      expect(pet.hunger, 40);
      expect(pet.happiness, 60);
    });

    test('feed keeps values inside their boundaries', () {
      final pet = PetModel(
        happiness: 95,
        hunger: 5,
      );

      pet.feed();

      expect(pet.hunger, 0);
      expect(pet.happiness, 75);
    });

    test('play updates happiness hunger and energy', () {
      final pet = PetModel();

      pet.play();

      expect(pet.happiness, 60);
      expect(pet.hunger, 55);
      expect(pet.energy, 60);
    });

    test('run updates meters when enough energy is available', () {
      final pet = PetModel();

      pet.run();

      expect(pet.happiness, 65);
      expect(pet.hunger, 60);
      expect(pet.energy, 50);
    });

    test('run does nothing when energy is too low', () {
      final pet = PetModel(energy: 10);

      pet.run();

      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 10);
    });

    test('sleep restores energy without exceeding 100', () {
      final pet = PetModel(energy: 90);

      pet.sleep();

      expect(pet.energy, 100);
      expect(pet.hunger, 60);
    });

    test('hunger tick increases hunger by 5', () {
      final pet = PetModel();

      pet.increaseHunger();

      expect(pet.hunger, 55);
    });

    test('hunger overflow lowers happiness', () {
      final pet = PetModel(
        happiness: 50,
        hunger: 100,
      );

      pet.increaseHunger();

      expect(pet.hunger, 100);
      expect(pet.happiness, 30);
    });

    test('loss occurs at 100 hunger and 10 happiness', () {
      final pet = PetModel(
        happiness: 10,
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

    test('markWon records a win when game is active', () {
      final pet = PetModel();

      pet.markWon();

      expect(pet.hasWon, true);
    });

    test('reset restores initial state', () {
      final pet = PetModel(
        name: 'Buddy',
        happiness: 10,
        hunger: 100,
        energy: 5,
        gameOver: true,
      );

      pet.reset();

      expect(pet.name, 'Buddy');
      expect(pet.happiness, 50);
      expect(pet.hunger, 50);
      expect(pet.energy, 70);
      expect(pet.gameOver, false);
      expect(pet.hasWon, false);
    });

    test('mood follows happiness boundaries', () {
      expect(PetModel(happiness: 29).mood, 'Unhappy');
      expect(PetModel(happiness: 30).mood, 'Neutral');
      expect(PetModel(happiness: 70).mood, 'Neutral');
      expect(PetModel(happiness: 71).mood, 'Happy');
    });
  });
}