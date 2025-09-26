import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  StreamSubscription<fb.User?>? _sub;

  AuthBloc({fb.FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        super(const AuthState.unauthenticated()) {
    on<LoginRequested>(_onLogin);
    on<SignupRequested>(_onSignup);
    on<LogoutRequested>(_onLogout);
    on<GuestSignInRequested>(_onGuest);
    on<GoogleSignInRequested>(_onGoogle);
    on<AuthStatusChanged>(_onStatusChanged);

    // Session persistence: emit current user and listen for changes
    _emitFromFirebaseUser(_auth.currentUser);
    _sub = _auth.authStateChanges().listen((u) => add(AuthStatusChanged(_toUser(u))));
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: event.email, password: event.password);
      _emitFromFirebaseUser(cred.user, emit: emit);
    } on fb.FirebaseAuthException catch (e) {
      emit(AuthState.failure(e.message ?? 'Login failed'));
    } catch (e) {
      emit(const AuthState.failure('Login failed'));
    }
  }

  Future<void> _onSignup(SignupRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: event.email, password: event.password);
      _emitFromFirebaseUser(cred.user, emit: emit);
    } on fb.FirebaseAuthException catch (e) {
      emit(AuthState.failure(e.message ?? 'Signup failed'));
    } catch (_) {
      emit(const AuthState.failure('Signup failed'));
    }
  }

  Future<void> _onGuest(GuestSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final cred = await _auth.signInAnonymously();
      _emitFromFirebaseUser(cred.user, emit: emit);
    } on fb.FirebaseAuthException catch (e) {
      emit(AuthState.failure(e.message ?? 'Guest sign-in failed'));
    } catch (_) {
      emit(const AuthState.failure('Guest sign-in failed'));
    }
  }

  Future<void> _onGoogle(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        emit(const AuthState.unauthenticated());
        return;
      }
      final auth = await account.authentication;
      final credential = fb.GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken);
      final cred = await _auth.signInWithCredential(credential);
      _emitFromFirebaseUser(cred.user, emit: emit);
    } on fb.FirebaseAuthException catch (e) {
      emit(AuthState.failure(e.message ?? 'Google sign-in failed'));
    } catch (_) {
      emit(const AuthState.failure('Google sign-in failed'));
    }
  }

  void _onStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.user == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(event.user!));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    emit(const AuthState.unauthenticated());
  }

  void _emitFromFirebaseUser(fb.User? user, {Emitter<AuthState>? emit}) {
    final converted = _toUser(user);
    if (emit != null) {
      if (converted == null) {
        emit(const AuthState.unauthenticated());
      } else {
        emit(AuthState.authenticated(converted));
      }
    } else {
      add(AuthStatusChanged(converted));
    }
  }

  User? _toUser(fb.User? u) {
    if (u == null) return null;
    final email = u.isAnonymous ? 'guest@local' : (u.email ?? '');
    return User(id: u.uid, email: email);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

