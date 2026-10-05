import 'dart:async';

import 'package:flutter/material.dart';

import 'models/pet_model.dart';

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  const DigitalPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const DigitalPetScreen(),
    );
  }
}

class DigitalPetScreen extends StatefulWidget {
  const DigitalPetScreen({super.key});

  @override
  State<DigitalPetScreen> createState() => _DigitalPetScreenState();
}

class _DigitalPetScreenState extends State<DigitalPetScreen> {
  final PetModel _pet = PetModel();
  final TextEditingController _nameController = TextEditingController();

  Timer? _hungerTimer;
  Timer? _highMoodTimer;
  Timer? _bounceTimer;

  bool _isBouncing = false;
  int _bounceId = 0;

  Color get _moodColor {
    if (_pet.happiness > 70) {
      return Colors.green;
    }

    if (_pet.happiness >= 30) {
      return Colors.yellow;
    }

    return Colors.red;
  }

  bool get _reduceMotion {
    return MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  Duration get _motionDuration {
    if (_reduceMotion) {
      return Duration.zero;
    }

    return const Duration(milliseconds: 250);
  }

  void _startHungerTimer() {
    _hungerTimer?.cancel();

    _hungerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (!mounted || _pet.gameOver || _pet.hasWon) {
          timer.cancel();
          return;
        }

        setState(() {
          _pet.increaseHunger();
        });

        _updateOutcome();
      },
    );
  }

  void _updateOutcome() {
    if (_pet.gameOver || _pet.hasWon) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      _hungerTimer?.cancel();
      return;
    }

    if (_pet.happiness <= 80) {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      return;
    }

    _highMoodTimer ??= Timer(
      const Duration(minutes: 3),
      () {
        _highMoodTimer = null;

        if (!mounted ||
            _pet.gameOver ||
            _pet.hasWon ||
            _pet.happiness <= 80) {
          return;
        }

        setState(() {
          _pet.markWon();
        });

        _hungerTimer?.cancel();
      },
    );
  }

  void _triggerBounce() {
    _bounceTimer?.cancel();
    _bounceId++;
    final currentBounceId = _bounceId;

    if (_reduceMotion) {
      if (_isBouncing) {
        setState(() {
          _isBouncing = false;
        });
      }
      return;
    }

    setState(() {
      _isBouncing = true;
    });

    _bounceTimer = Timer(
      const Duration(milliseconds: 180),
      () {
        if (!mounted || currentBounceId != _bounceId) {
          return;
        }

        setState(() {
          _isBouncing = false;
        });
      },
    );
  }

  void _updatePetName() {
    setState(() {
      _pet.setName(_nameController.text);
      _nameController.text = _pet.name;
    });
  }

  void _feedPet() {
    setState(() {
      _pet.feed();
    });

    _triggerBounce();
    _updateOutcome();
  }

  void _playWithPet() {
    setState(() {
      _pet.play();
    });

    _triggerBounce();
    _updateOutcome();
  }

  void _runWithPet() {
    setState(() {
      _pet.run();
    });

    _triggerBounce();
    _updateOutcome();
  }

  void _letPetSleep() {
    setState(() {
      _pet.sleep();
    });

    _triggerBounce();
    _updateOutcome();
  }

  void _resetPet() {
    _highMoodTimer?.cancel();
    _highMoodTimer = null;

    _bounceTimer?.cancel();
    _bounceTimer = null;
    _bounceId++;

    setState(() {
      _isBouncing = false;
      _pet.reset();
    });

    _startHungerTimer();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = _pet.name;
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _bounceTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionsDisabled = _pet.gameOver || _pet.hasWon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _pet.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Center(
                child: AnimatedScale(
                  scale: _isBouncing ? 1.08 : 1.0,
                  duration: _motionDuration,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _moodColor,
                      BlendMode.modulate,
                    ),
                    child: Image.asset(
                      'assets/images/pet.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      semanticLabel: 'Digital pet',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Mood: ${_pet.mood}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _updatePetName(),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _updatePetName,
                child: const Text('Confirm Name'),
              ),
              const SizedBox(height: 24),
              _PetMeter(
                label: 'Happiness',
                value: _pet.happiness,
                reduceMotion: _reduceMotion,
              ),
              const SizedBox(height: 16),
              _PetMeter(
                label: 'Hunger',
                value: _pet.hunger,
                reduceMotion: _reduceMotion,
              ),
              const SizedBox(height: 16),
              _PetMeter(
                label: 'Energy',
                value: _pet.energy,
                reduceMotion: _reduceMotion,
              ),
              const SizedBox(height: 24),
              Text(
                'Care',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: actionsDisabled ? null : _feedPet,
                    child: const Text('Feed'),
                  ),
                  FilledButton(
                    onPressed: actionsDisabled ? null : _playWithPet,
                    child: const Text('Play'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Activities',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: actionsDisabled ? null : _runWithPet,
                    child: const Text('Run'),
                  ),
                  FilledButton(
                    onPressed: actionsDisabled ? null : _letPetSleep,
                    child: const Text('Sleep'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_pet.gameOver)
                const Text(
                  'Game Over',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_pet.hasWon)
                const Text(
                  'You Win!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _resetPet,
                child: const Text('Reset Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetMeter extends StatelessWidget {
  final String label;
  final int value;
  final bool reduceMotion;

  const _PetMeter({
    required this.label,
    required this.value,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value out of 100',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              end: value / 100,
            ),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 300),
            builder: (context, animatedValue, child) {
              return LinearProgressIndicator(
                value: animatedValue,
                minHeight: 12,
              );
            },
          ),
        ],
      ),
    );
  }
}