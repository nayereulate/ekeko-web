import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../home/home_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0;
  bool _wantsBusinessProfile = false;
  String? _selectedCategory;
  final _nameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _finish() {
    final appState = context.read<AppState>();
    if (_wantsBusinessProfile && _businessNameCtrl.text.trim().isNotEmpty) {
      appState.registerBusiness(
        name: _businessNameCtrl.text.trim(),
        category: _selectedCategory ?? kCategories.first,
        serviceType: (_selectedCategory == 'Servicios') ? kServiceTypes.first : null,
        department: kDepartments.first,
        city: kDepartments.first,
        zone: 'Centro',
        description: 'Nuevo negocio en EKEKO. ¡Pronto más detalles!',
        links: const BusinessLinks(whatsappPhone: '59170000000'),
      );
    } else {
      appState.login();
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepIndicator(step: _step),
              const SizedBox(height: 24),
              Expanded(child: _buildStep()),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue() ? _next : null,
                  child: Text(_step == 2 ? 'Finalizar y publicar perfil' : 'Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canContinue() {
    if (_step == 0) return _nameCtrl.text.trim().isNotEmpty;
    if (_step == 2 && _wantsBusinessProfile) {
      return _businessNameCtrl.text.trim().isNotEmpty && _selectedCategory != null;
    }
    return true;
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _NameStep(controller: _nameCtrl, onChanged: () => setState(() {}));
      case 1:
        return _RoleStep(
          value: _wantsBusinessProfile,
          onChanged: (v) => setState(() => _wantsBusinessProfile = v),
        );
      default:
        return _wantsBusinessProfile
            ? _BusinessStep(
                nameCtrl: _businessNameCtrl,
                category: _selectedCategory,
                onCategory: (c) => setState(() => _selectedCategory = c),
                onChanged: () => setState(() {}),
              )
            : const _SummaryStep();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final active = i <= step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : EkekoColors.of(context).border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _NameStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  const _NameStep({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Cómo te llamas?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Usaremos tu nombre para personalizar tu cuenta.', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(hintText: 'Nombre completo'),
        ),
      ],
    );
  }
}

class _RoleStep extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _RoleStep({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Tienes un emprendimiento?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Puedes usar EKEKO solo para descubrir negocios, o crear tu propio perfil de vendedor.',
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 20),
        _OptionCard(
          title: 'Solo quiero comprar/explorar',
          subtitle: 'Descubre catálogos de emprendedores cerca tuyo.',
          icon: Icons.explore_rounded,
          selected: !value,
          onTap: () => onChanged(false),
        ),
        const SizedBox(height: 12),
        _OptionCard(
          title: 'Quiero publicar mi negocio',
          subtitle: 'Crea tu vitrina con catálogo, enlaces y contacto WhatsApp.',
          icon: Icons.storefront_rounded,
          selected: value,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.10) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : ek.border, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: selected ? AppColors.primary : ek.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: ek.muted, fontSize: 12.5)),
                ],
              ),
            ),
            Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, color: selected ? AppColors.primary : ek.muted),
          ],
        ),
      ),
    );
  }
}

class _BusinessStep extends StatelessWidget {
  final TextEditingController nameCtrl;
  final String? category;
  final ValueChanged<String> onCategory;
  final VoidCallback onChanged;

  const _BusinessStep({
    required this.nameCtrl,
    required this.category,
    required this.onCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cuéntanos de tu negocio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Podrás completar el resto (enlaces, catálogo) luego desde tu panel.',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 20),
          const Text('Nombre del negocio', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: nameCtrl,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(hintText: 'Ej. Tejidos Wara'),
          ),
          const SizedBox(height: 16),
          const Text('Rubro', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kCategories.map((c) {
              final sel = c == category;
              return ChoiceChip(
                label: Text(c),
                selected: sel,
                onSelected: (_) => onCategory(c),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SummaryStep extends StatelessWidget {
  const _SummaryStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¡Todo listo!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
          'Tu cuenta está lista para explorar los catálogos de emprendedores bolivianos.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),
        const Center(child: Icon(Icons.celebration_rounded, size: 64, color: AppColors.accent)),
      ],
    );
  }
}
