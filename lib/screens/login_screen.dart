// This file has been removed. Use login_signup_page.dart instead.

// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/widgets.dart';
import 'signup_screen.dart';
// ...existing imports

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.isAuthenticated) {
                  Navigator.of(context).pushReplacementNamed('/root');
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 16),
                    TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                    const SizedBox(height: 8),
                    ErrorText(message: state.error),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: state.isLoading ? 'Signing in...' : 'Login',
                      onPressed: state.isLoading
                          ? null
                          : () {
                              BlocProvider.of<AuthBloc>(context).add(LoginRequested(_emailCtrl.text.trim(), _passCtrl.text));
                            },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: state.isLoading ? null : () => BlocProvider.of<AuthBloc>(context).add(const GuestSignInRequested()),
                      child: const Text('Continue as Guest'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: state.isLoading ? null : () => BlocProvider.of<AuthBloc>(context).add(const GoogleSignInRequested()),
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: const Size.fromHeight(44),
                        side: const BorderSide(color: Colors.black12),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, SignupScreen.routeName),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

