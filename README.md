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

## ScreenShots
<img width="1080" height="2400" alt="Screenshot_20250926_192223" src="https://github.com/user-attachments/assets/40670074-bb19-4d03-ba35-84416629612d" />
<img width="1080" height="2400" alt="Screenshot_20250926_192216" src="https://github.com/user-attachments/assets/32e1201b-c758-44a6-9fab-b28fd5a94f70" />
<img width="1080" height="2400" alt="Screenshot_20250926_192205" src="https://github.com/user-attachments/assets/5563f5cb-0fac-4806-b483-ee0dc75a1b31" />
<img width="1080" height="2400" alt="Screenshot_20250926_192127" src="https://github.com/user-attachments/assets/b88eb8f6-a846-4396-b34b-d66571dcbd81" />
<img width="1080" height="2400" alt="Screenshot_20250926_192109" src="https://github.com/user-attachments/assets/580207db-65c5-4c54-b173-07c92a7d4d16" />
<img width="1080" height="2400" alt="Screenshot_20250926_192059" src="https://github.com/user-attachments/assets/7cbd6f2b-b349-4844-91af-971ccbe5f967" />
<img width="1080" height="2400" alt="Screenshot_20250926_192050" src="https://github.com/user-attachments/assets/b9efe3bb-a3f9-4165-a239-3ac72b4cfac9" />
<img width="1080" height="2400" alt="Screenshot_20250926_192042" src="https://github.com/user-attachments/assets/20b441da-57a7-4301-bc74-b850334de970" />
<img width="1080" height="2400" alt="Screenshot_20250926_192033" src="https://github.com/user-attachments/assets/7dcf1205-9abf-4377-8349-fbae08f51175" />
<img width="1080" height="2400" alt="Screenshot_20250926_192018" src="https://github.com/user-attachments/assets/fd1b2c60-bf58-4e4b-9cc3-53b56fb296f9" />
<img width="1080" height="2400" alt="Screenshot_20250926_192006" src="https://github.com/user-attachments/assets/ee6b9fe4-eed4-4665-a1d6-3191727b2d19" />
<img width="1080" height="2400" alt="Screenshot_20250925_182738" src="https://github.com/user-attachments/assets/b5805ed4-e9ad-4639-999c-153ad9ec4a56" />
<img width="1080" height="2400" alt="Screenshot_20250925_182723" src="https://github.com/user-attachments/assets/4e7b4def-b612-4c2c-8a65-7faf55861628" />
<img width="1080" height="2400" alt="Screenshot_20250925_182706" src="https://github.com/user-attachments/assets/51cf4bbd-b2d4-404b-ba9c-2e5f8f7ea58d" />


