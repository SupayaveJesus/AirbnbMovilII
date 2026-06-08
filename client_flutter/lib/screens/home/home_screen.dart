import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/session_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../auth/login_screen.dart';
import '../places/search_places_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  final _guestsController = TextEditingController(text: '2');

  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  void dispose() {
    _cityController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final initialDate = isCheckIn
        ? (_checkIn ?? now)
        : (_checkOut ??
              _checkIn?.add(const Duration(days: 1)) ??
              now.add(const Duration(days: 1)));
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (date == null) {
      return;
    }

    setState(() {
      if (isCheckIn) {
        _checkIn = date;
        _checkInController.text = _formatDate(date);
        if (_checkOut != null && !_checkOut!.isAfter(date)) {
          _checkOut = date.add(const Duration(days: 1));
          _checkOutController.text = _formatDate(_checkOut!);
        }
      } else {
        _checkOut = date;
        _checkOutController.text = _formatDate(date);
      }
    });
  }

  Future<void> _logout() async {
    await SessionService.instance.clear();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _search() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchPlacesScreen(
          city: _cityController.text.trim(),
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          guests: int.parse(_guestsController.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.15,
            colors: [Color(0xFF182544), Color(0xFF09101D)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore premium stays',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Busca ciudad, fechas y huéspedes. Lo demás es ruido para mañana.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const GlassCard(
                  highlighted: true,
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.secondary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dark premium UI + flujo corto: login, búsqueda y resultados.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simple search',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 18),
                        GlassTextField(
                          controller: _cityController,
                          label: 'Ciudad',
                          hint: 'Santa Cruz, Cochabamba, La Paz...',
                          prefixIcon: Icons.location_city_outlined,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Ingresa una ciudad.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GlassTextField(
                                controller: _checkInController,
                                label: 'Check-in',
                                hint: 'Selecciona fecha',
                                prefixIcon: Icons.calendar_today_outlined,
                                readOnly: true,
                                onTap: () => _pickDate(isCheckIn: true),
                                validator: (_) => _checkIn == null
                                    ? 'Selecciona fecha.'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassTextField(
                                controller: _checkOutController,
                                label: 'Check-out',
                                hint: 'Selecciona fecha',
                                prefixIcon: Icons.event_available_outlined,
                                readOnly: true,
                                onTap: () => _pickDate(isCheckIn: false),
                                validator: (_) {
                                  if (_checkOut == null) {
                                    return 'Selecciona fecha.';
                                  }
                                  if (_checkIn != null &&
                                      !_checkOut!.isAfter(_checkIn!)) {
                                    return 'Debe ser posterior.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _guestsController,
                          label: 'Huéspedes',
                          hint: '2',
                          prefixIcon: Icons.group_outlined,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final guests = int.tryParse(value ?? '');
                            if (guests == null || guests <= 0) {
                              return 'Ingresa una cantidad válida.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        PrimaryCtaButton(
                          label: 'Buscar lugares',
                          icon: Icons.search_rounded,
                          onPressed: _search,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
