import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final result = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );
      await SessionService.instance.save(result);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (error) {
      setState(
        () => _errorText = error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Regístrate para desbloquear la búsqueda y entrar directo al flujo de demo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorText != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.danger.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppTheme.danger.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(_errorText!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      GlassTextField(
                        controller: _nameController,
                        label: 'Nombre completo',
                        hint: 'Ingresa tu nombre',
                        prefixIcon: Icons.person_outline,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Ingresa tu nombre.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'correo@ejemplo.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Ingresa tu email.';
                          }
                          if (!text.contains('@')) {
                            return 'Ingresa un email válido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _phoneController,
                        label: 'Teléfono',
                        hint: '7XXXXXXXX',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            (value == null || value.trim().length < 7)
                            ? 'Ingresa un teléfono válido.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        hint: 'Mínimo 6 caracteres',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) =>
                            (value == null || value.length < 6)
                            ? 'La contraseña debe tener al menos 6 caracteres.'
                            : null,
                      ),
                      const SizedBox(height: 22),
                      PrimaryCtaButton(
                        label: 'Crear cuenta',
                        icon: Icons.rocket_launch_outlined,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
