# Digital Pet State Lab

## Student

Jeremy Henry-Atohengbe

## Pathway

Graduate

## Project Overview

Digital Pet is a Flutter application that demonstrates state management with `StatefulWidget` and `setState()`. The user can name and care for a digital pet while its happiness, hunger, and energy change over time and through user interactions.

The application includes automatic hunger updates, mood changes, win and loss conditions, activity selection, an energy system, accessible animations, reset behavior, and automated tests.

## Core Features

- Editable pet name
- Happiness meter from 0 to 100
- Hunger meter from 0 to 100
- Mood derived from happiness
- Mood-tinted pet image
- Feed interaction
- Play interaction
- Automatic hunger increase every 30 seconds
- Loss condition when hunger reaches 100 and happiness is 10 or lower
- Win condition when happiness remains above 80 continuously for 3 minutes
- Reset functionality
- Derived pet status messages

## Graduate Advanced Features

### 1. Energy System

The pet has an energy meter from 0 to 100.

Play decreases energy by 10.

Run requires at least 20 energy and changes the state as follows:

- Happiness +15
- Hunger +10
- Energy -20

Sleep changes the state as follows:

- Energy +30
- Hunger +10

All meter values are clamped between 0 and 100.

### 2. Activity Selection

The application provides Run and Sleep activities in addition to the core Feed and Play actions.

Run provides a larger happiness increase but consumes energy and increases hunger.

Sleep restores energy while also increasing hunger.

### 3. Visual Polish and Accessible Motion

The application includes multiple visual effects:

- The pet briefly scales after an interaction.
- Progress meters animate smoothly when their values change.
- The pet image changes tint based on mood.

The application checks the device's reduced-motion preference using `MediaQuery.disableAnimations`. When reduced motion is requested, animation durations are reduced to zero.

Mood is also displayed as text so color is not the only way the pet's state is communicated.

## State Rules

### Mood

- Happiness above 70: Happy
- Happiness from 30 through 70: Neutral
- Happiness below 30: Unhappy

### Hunger

Hunger increases by 5 every 30 seconds.

When hunger reaches 100, it remains at 100. A later hunger tick that would exceed 100 reduces happiness by 20.

### Win

The player wins when happiness remains strictly above 80 continuously for 3 minutes.

If happiness reaches 80 or below before the 3 minutes are complete, the continuous win progress is reset.

### Loss

The game ends when:

- Hunger = 100
- Happiness <= 10

Actions stop changing the pet after a terminal win or loss state.

## Architecture

The project separates game rules from Flutter rendering.

`PetModel` contains the main pet state and state-transition rules, including happiness, hunger, energy, mood, activities, loss behavior, reset behavior, and derived messages.

`WinTracker` contains the rule for tracking the continuous high-happiness period required for a win.

`DigitalPetScreen` owns Flutter-specific responsibilities such as rendering widgets, calling `setState()`, managing timers, handling animations, and disposing resources.

This separation makes the game rules easier to test without depending on the widget tree.

### Architecture Trade-off

The project keeps Flutter timer ownership inside the stateful screen instead of moving all timer behavior into the model. This means the screen still coordinates some game timing, but it also keeps Flutter lifecycle responsibilities close to the widget that owns them. The win-duration rule itself is separated into `WinTracker`, allowing the important continuous-time behavior to be tested independently.

## Project Structure

```text
lib/
├── main.dart
└── models/
    ├── pet_model.dart
    └── win_tracker.dart

test/
├── pet_model_test.dart
├── widget_test.dart
└── win_tracker_test.dart

assets/
└── images/
    └── pet.png