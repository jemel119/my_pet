import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:digital_pet/main.dart';

void main() {
  testWidgets('digital pet screen shows initial state', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    expect(find.text('Digital Pet'), findsOneWidget);
    expect(find.text('Pip'), findsNWidgets(2));
    expect(find.text('Mood: Neutral'), findsOneWidget);

    expect(find.text('Happiness: 50'), findsOneWidget);
    expect(find.text('Hunger: 50'), findsOneWidget);
    expect(find.text('Energy: 70'), findsOneWidget);

    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Reset Pet'), findsOneWidget);
  });

  testWidgets('user can change the pet name', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    await tester.enterText(
      find.byType(TextField),
      'Buddy',
    );

    await tester.tap(
      find.text('Confirm Name'),
    );

    await tester.pump();

    expect(find.text('Buddy'), findsNWidgets(2));
  });

  testWidgets('feed updates the visible pet meters', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    final feedButton = find.text('Feed');

    await tester.ensureVisible(feedButton);
    await tester.tap(feedButton);
    await tester.pump();

    expect(find.text('Happiness: 60'), findsOneWidget);
    expect(find.text('Hunger: 40'), findsOneWidget);
  });

  testWidgets('play updates happiness hunger and energy', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    final playButton = find.text('Play');

    await tester.ensureVisible(playButton);
    await tester.tap(playButton);
    await tester.pump();

    expect(find.text('Happiness: 60'), findsOneWidget);
    expect(find.text('Hunger: 55'), findsOneWidget);
    expect(find.text('Energy: 60'), findsOneWidget);
  });

  testWidgets('run activity updates the visible meters', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    final runButton = find.text('Run');

    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pump();

    expect(find.text('Happiness: 65'), findsOneWidget);
    expect(find.text('Hunger: 60'), findsOneWidget);
    expect(find.text('Energy: 50'), findsOneWidget);
  });

  testWidgets('sleep activity restores energy', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    final sleepButton = find.text('Sleep');

    await tester.ensureVisible(sleepButton);
    await tester.tap(sleepButton);
    await tester.pump();

    expect(find.text('Hunger: 60'), findsOneWidget);
    expect(find.text('Energy: 100'), findsOneWidget);
  });

  testWidgets('reset restores the initial meter values', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    final playButton = find.text('Play');

    await tester.ensureVisible(playButton);
    await tester.tap(playButton);
    await tester.pump();

    expect(find.text('Happiness: 60'), findsOneWidget);

    final resetButton = find.text('Reset Pet');

    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pump();

    expect(find.text('Happiness: 50'), findsOneWidget);
    expect(find.text('Hunger: 50'), findsOneWidget);
    expect(find.text('Energy: 70'), findsOneWidget);
  });

  testWidgets('pet image has an accessibility label', (tester) async {
    await tester.pumpWidget(const DigitalPetApp());

    expect(
      find.bySemanticsLabel('Digital pet'),
      findsOneWidget,
    );
  });
}