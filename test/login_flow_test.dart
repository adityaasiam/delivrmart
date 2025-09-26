import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:delivr_mart/blocs/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits authenticated on valid login',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(const LoginRequested('user@example.com', '1234')),
      wait: const Duration(milliseconds: 700),
      expect: () => [
        const AuthState.loading(),
        isA<AuthState>().having((s) => s.isAuthenticated, 'isAuthenticated', true),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits failure on invalid login',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(const LoginRequested('invalid', 'x')),
      wait: const Duration(milliseconds: 700),
      expect: () => [
        const AuthState.loading(),
        const AuthState.failure('Invalid email or password'),
      ],
    );
  });
}




