# Game Dev Tycoon

A mobile game development tycoon simulator built with Flutter, inspired by [Game Dev Tycoon](https://www.greenheartgames.com/app/game-dev-tycoon/). Develop games, earn money, and build your gaming empire!

## Features

### Core Gameplay
- **Multiple Game Types**: Choose between Sci-Fi, Fight, and Thriller games
- **Development Mechanics**: Watch animated particles fill progress bars for Design, Technology, and Bugs
- **Money System**: Earn money from completed games with persistent storage
- **Dynamic Timing**: Different game types have different development times and payouts

### Game Types

| Game Type | Development Time | Money Earned | $ per Second |
|-----------|-----------------|--------------|--------------|
| Sci-Fi Game | 10 seconds | $50 | $5.0/s |
| Fight Game | 5 seconds | $20 | $4.0/s |
| Thriller Game | 2 seconds | $3 | $1.5/s |

### Technical Features
- **Entity Component System (ECS)**: Data-driven game type configuration
- **State Management**: Provider-based state management
- **Persistent Storage**: SharedPreferences for saving money across sessions
- **Animated Particles**: Dynamic dot particles that move to progress bars at different speeds
- **Responsive UI**: Clean, modern interface optimized for mobile

## Screenshots

*Coming soon*

## Architecture

### Project Structure
```
lib/
├── config/
│   ├── game_constants.dart       # Gameplay constants (speeds, durations)
│   └── game_type_config.dart     # ECS-style game type configurations
├── models/
│   ├── game_type.dart            # Game type enum
│   ├── game_project.dart         # Completed project model
│   └── progress_bar_data.dart    # Progress bar data model
├── controllers/
│   └── game_controller.dart      # Main game state controller
├── screens/
│   ├── menu_screen.dart          # Main menu with game selection
│   └── development_screen.dart   # Development screen with mechanics
├── components/
│   ├── progress_bar_widget.dart  # Progress bar UI component
│   └── dot_particle.dart         # Animated particle component
└── main.dart                     # App entry point
```

### Design Patterns
- **ECS (Entity Component System)**: Game types are configured as data entities
- **Provider Pattern**: State management using ChangeNotifier
- **Component-Based UI**: Reusable widget components
- **Repository Pattern**: GameTypeRegistry for centralized configuration

## Getting Started

### Prerequisites
- Flutter SDK (^3.10.3)
- Dart SDK
- Android Studio / Xcode (for Android development)

### Installation

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/game_dev_tycoon.git
cd game_dev_tycoon
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Building for Android
```bash
flutter build apk --release
```

## Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  flame: ^1.22.0              # Game engine (prepared for future use)
  provider: ^6.1.2            # State management
  shared_preferences: ^2.2.3  # Persistent storage
```

## How to Play

1. **Start Screen**: View your current money balance at the top
2. **Select Game Type**: Choose from Sci-Fi, Fight, or Thriller games
3. **Watch Development**: Observe the progress bars fill with animated particles
4. **Complete Game**: After the timer completes, see your earnings
5. **Repeat**: Build more games to accumulate wealth!

## Adding New Game Types

Thanks to the ECS architecture, adding new game types is simple:

1. Add enum value in `lib/models/game_type.dart`:
```dart
enum GameType { sciFi, fight, thriller, yourNewType }
```

2. Add configuration in `lib/config/game_type_config.dart`:
```dart
GameType.yourNewType: GameTypeConfig(
  type: GameType.yourNewType,
  displayName: 'YOUR GAME',
  developmentTime: 15.0,
  moneyEarned: 100.0,
  colorCode: 0xFFff9900,
  iconName: 'icon_name',
)
```

3. Update icon mapping in `lib/screens/menu_screen.dart` if needed.

That's it! The UI automatically adapts.

## Roadmap

- [ ] Character animations during development
- [ ] Multiple difficulty levels
- [ ] Upgrade system for faster development
- [ ] Research tree for unlocking new game types
- [ ] Statistics and analytics screen
- [ ] Sound effects and music
- [ ] Save game slots
- [ ] Achievements system

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Inspiration

Inspired by [Game Dev Tycoon](https://www.greenheartgames.com/app/game-dev-tycoon/) by Greenheart Games.

## Contact

Created as a learning project for Flutter game development.

---

**Built with Flutter and ❤️**
