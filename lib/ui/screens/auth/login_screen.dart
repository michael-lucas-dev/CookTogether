import 'package:cooktogether/providers/firebase_providers.dart';
import 'package:cooktogether/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooktogether/core/logger.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        AppLogger.info('Tentative de connexion avec email: ${_emailController.text}');
        final authService = ref.read(authServiceProvider);
        await authService.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        AppLogger.info('Connexion réussie');
        if (mounted) {
          context.go(Locations.recipes);
        }
      } catch (e, stackTrace) {
        AppLogger.error('Erreur lors de la connexion', e, stackTrace);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: const Text('Se connecter')),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  AppLogger.info('Redirection vers l\'écran d\'inscription');
                  context.go(Locations.register);
                },
                child: const Text('Créer un compte'),
              ),
              TextButton(
                onPressed: () {
                  AppLogger.info(
                    'Tentative de réinitialisation de mot de passe pour: ${_emailController.text}',
                  );
                  final authService = ref.read(authServiceProvider);
                  authService.sendPasswordResetEmail(_emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Un email de réinitialisation a été envoyé')),
                  );
                },
                child: const Text('Mot de passe oublié ?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
