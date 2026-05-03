# StepQuest Fitness RPG

StepQuest is a Flutter and Firebase mobile app that turns daily fitness activity into an RPG-style adventure. Users can sign in, track progress, complete quests, battle enemies, earn XP, level up, unlock achievements, and build streaks over time.

## Team Members
- Darin Ward — Frontend, UI/UX, RPG game logic, battle system, quests, animations
- Sanaul Haque — Firebase backend, authentication, Firestore user profiles, persistent login

## Project Goal
The goal of StepQuest is to make fitness more engaging by connecting real activity goals to game progression. Instead of only counting steps, the app rewards users with XP, levels, achievements, and RPG battle progress.

## Core Features
- Intro video screen with game-style music
- Login and sign-up flow
- Google Sign-In support through Firebase
- Persistent user profile using Firestore
- Home dashboard with XP, level, streaks, and step progress
- Selectable quest system with XP rewards
- Random quest generation after completion
- RPG battle system with enemies, HP, damage, and rewards
- Enemy difficulty scaling every 5 player levels
- Profile screen with player stats, achievements, avatar/logo selection, and logout
- Background music system for intro, dashboard, and battle screens
- Animated progress bars and victory feedback

## Technology Stack
- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Core
- Google Sign-In
- video_player
- just_audio

## App Screens
- Intro Video Screen
- Login / Sign-Up Screen
- Home Dashboard
- Quest Screen
- Battle Arena
- Profile Screen
- Edit Profile Screen
- Avatar Selection Screen

## Frontend Responsibilities Completed
Darin completed the main frontend and RPG gameplay structure:
- Built the main Flutter UI screens
- Added navigation between screens
- Created the XP and leveling system
- Built the quest selection and reward system
- Added random quest generation
- Created the battle system
- Added enemy difficulty scaling by player level
- Added profile editing and avatar selection UI
- Added logout UI placeholder/support
- Added intro video screen
- Added music transitions for intro, dashboard, and battle
- Added reusable UI widgets
- Added animations and visual polish
- Prepared frontend state for Firebase integration

## Backend Responsibilities Completed / In Progress
Sanaul worked on Firebase integration:
- Firebase project configuration
- Google services setup
- Firebase initialization
- Authentication service
- Google Sign-In and logout
- Persistent login auth gate
- Firestore user profile creation for new users

## Firebase Data Goals
The app is designed to store and retrieve:
- User profile information
- Selected avatar/logo
- XP and level
- Step progress
- Completed quests
- Claimed quest rewards
- Achievements
- Battle wins
- Login and activity streaks

## Future Improvements
- Real device step tracking using a pedometer or health package
- Firebase Cloud Messaging notifications
- Email notifications for sign-up and achievements
- More enemy types and boss battles
- More avatar customization
- More detailed achievement history
- Advanced quest categories and weekly challenges

## How to Run
Clone the repository:
```bash
git clone https://github.com/DareeInn/stepquest-fitness-rpg.git
cd stepquest-fitness-rpg
```
Install dependencies:
```bash
flutter pub get
```
Run the app:
```bash
flutter run
```
Run analysis and tests:
```bash
flutter analyze
flutter test
```

## Current Status
The project currently includes a completed frontend gameplay experience with Firebase backend integration started. The app demonstrates the core StepQuest concept: users progress through an RPG-style fitness journey by completing quests, earning XP, leveling up, and battling enemies.
