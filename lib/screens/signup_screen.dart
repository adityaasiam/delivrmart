// This file has been removed. Use login_signup_page.dart instead.

// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/widgets.dart';
import 'login_screen.dart';
// ...existing imports

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/root');
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                ErrorText(message: state.error),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: state.isLoading ? 'Creating...' : 'Create Account',
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(SignupRequested(_emailCtrl.text.trim(), _passCtrl.text));
                        },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                  child: const Text('Already have an account? Log In'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}



