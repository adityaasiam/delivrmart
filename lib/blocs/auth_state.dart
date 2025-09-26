part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState._({required this.isLoading, this.user, this.error});

  const AuthState.unauthenticated() : this._(isLoading: false);
  const AuthState.loading() : this._(isLoading: true);
  const AuthState.failure(String message) : this._(isLoading: false, error: message);
  const AuthState.authenticated(User user) : this._(isLoading: false, user: user);

  bool get isAuthenticated => user != null;

  @override
  List<Object?> get props => [isLoading, user, error];
}




