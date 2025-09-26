## Problems Faced

- **Navigation and Routing:**
	- Ensuring the BottomNavigationBar only appears after authentication required careful routing and state management.
	- Fixed issues where the app would get stuck on the splash screen or navigate to screens without the nav bar by updating navigation logic to use the correct routes (e.g., `/root`).

- **Asset Registration:**
	- Encountered asset bundling errors due to incorrect indentation in `pubspec.yaml` and missing/incorrect asset paths. Resolved by correcting YAML formatting and verifying asset files.

- **Authentication Flow Refactor:**
	- Migrated from separate login/signup screens to a unified login/signup page, updating all navigation and removing old files.
	- Fixed errors where routes like `/login` were missing after refactor by updating all logout and redirect logic to use `/login-signup`.

- **UI Consistency:**
	- Ensured the login/signup page matched the rest of the app's color scheme and design for a seamless user experience.

- **BloC Integration:**
	- Integrated BloC for all major workflows (auth, cart, order, search) and ensured error handling and loading states were surfaced in the UI.

- **Render Flex Overflows:**
	- Fixed layout issues (e.g., overflow in signup form) by adjusting scroll views and container heights.

- **Testing:**
	- Added unit tests for SearchBloc and ensured the project structure supports further testability.

# DelivrMart

A modern, full-featured food delivery app built with Flutter and BloC architecture.

## Features
- Clean onboarding and authentication flow (Splash, Get Started, Login/Signup)
- Restaurant browsing, search, and menu viewing
- Cart management and order placement
- Profile management and guest/Google sign-in
- State management using BloC pattern
- Modular, SOLID-compliant architecture
- Responsive, aesthetically pleasing UI
- Error handling throughout the workflow
- Unit tests for core business logic (e.g., SearchBloc)

## Project Structure
```
lib/
  blocs/           # BloC state management
  features/        # Feature-specific logic (e.g., search)
  models/          # Data models
  repositories/    # Data access and business logic
  screens/         # UI screens
  widgets/         # Reusable widgets
  main.dart        # App entry point
assets/            # Images and static assets
```

## Getting Started
1. **Install dependencies:**
	```
	flutter pub get
	```
2. **Run the app:**
	```
	flutter run
	```
3. **Run tests:**
	```
	flutter test
	```

## Architecture
- Uses the BloC pattern for all business logic and state management
- Follows SOLID principles for maintainable, scalable code
- Error handling and loading states are managed via BloC

## Customization
- Update assets in the `assets/` folder and register in `pubspec.yaml`
- Add new features by creating new BloCs, repositories, and screens

## License
This project is for educational/demo purposes.
