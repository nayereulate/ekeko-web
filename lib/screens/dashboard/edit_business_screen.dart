import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class EditBusinessScreen extends StatefulWidget {
  final Business business;
  const EditBusinessScreen({super.key, required this.business});

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  late final _nameCtrl = TextEditingController(text: widget.business.name);
  late final _taglineCtrl = TextEditingController(text: widget.business.tagline ?? '');
  late final _descCtrl = TextEditingController(text: widget.business.description);
  late final _cityCtrl = TextEditingController(text: widget.business.city);
  late final _zoneCtrl = TextEditingController(text: widget.business.zone);
  late final _igCtrl = TextEditingController(text: widget.business.links.instagram ?? '');
  late final _fbCtrl = TextEditingController(text: widget.business.links.facebook ?? '');
  late final _ttCtrl = TextEditingController(text: widget.business.links.tiktok ?? '');
  late final _webCtrl = TextEditingController(text: widget.business.links.website ?? '');
  late final _waCtrl = TextEditingController(text: widget.business.links.whatsappPhone);
  late final _mapsCtrl = TextEditingController(text: widget.business.links.mapsQuery ?? '');
  late String _category = widget.business.category;
  late String? _serviceType = widget.business.serviceType;
  late String _department = widget.business.department;
  late bool _ships = widget.business.shipsNationwide;
  late bool _fast = widget.business.respondsFast;

  String? _n(String s) => s.trim().isEmpty ? null : s.trim();

  void _save() {
    final messenger = ScaffoldMessenger.of(context);
    context.read<AppState>().updateMyBusinessProfile(
          name: _nameCtrl.text.trim(),
          category: _category,
          serviceType: _category == 'Servicios' ? (_serviceType ?? kServiceTypes.first) : null,
          department: _department,
          city: _cityCtrl.text.trim(),
          zone: _zoneCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          tagline: _n(_taglineCtrl.text),
          shipsNationwide: _ships,
          respondsFast: _fast,
          links: BusinessLinks(
            instagram: _n(_igCtrl.text), facebook: _n(_fbCtrl.text), tiktok: _n(_ttCtrl.text),
            whatsappPhone: _waCtrl.text.trim(), website: _n(_webCtrl.text), mapsQuery: _n(_mapsCtrl.text),
          ),
        );
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text('Vitrina actualizada.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar vitrina'), actions: [TextButton(onPressed: _save, child: const Text('Guardar'))]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Label('Nombre del negocio'),
          TextField(controller: _nameCtrl),
          const SizedBox(height: 14),
          _Label('Frase de venta (tagline)'),
          TextField(controller: _taglineCtrl, decoration: const InputDecoration(hintText: 'Ej. Tejidos de alpaca hechos a mano')),
          const SizedBox(height: 14),
          _Label('Categoría'),
          Wrap(spacing: 8, runSpacing: 8, children: kCategories.map((c) => ChoiceChip(label: Text(c), selected: c == _category, onSelected: (_) => setState(() => _category = c))).toList()),
          if (_category == 'Servicios') ...[
            const SizedBox(height: 14),
            _Label('Tipo de servicio'),
            DropdownButtonFormField<String>(
              initialValue: _serviceType ?? kServiceTypes.first,
              items: kServiceTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _serviceType = v),
            ),
          ],
          const SizedBox(height: 14),
          _Label('Descripción'),
          TextField(controller: _descCtrl, maxLines: 3),
          const SizedBox(height: 14),
          _Label('Departamento'),
          DropdownButtonFormField<String>(
            initialValue: _department,
            items: kDepartments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => _department = v ?? _department),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: TextField(controller: _cityCtrl, decoration: const InputDecoration(labelText: 'Ciudad'))),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _zoneCtrl, decoration: const InputDecoration(labelText: 'Zona'))),
          ]),
          const SizedBox(height: 8),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _ships, onChanged: (v) => setState(() => _ships = v), title: const Text('Hago envíos a toda Bolivia', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600))),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _fast, onChanged: (v) => setState(() => _fast = v), title: const Text('Respondo en menos de 1 hora', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600))),
          const Divider(height: 28),
          const Text('Redes y contacto', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 4),
          Text('Se muestran como botones en tu vitrina.', style: TextStyle(fontSize: 12, color: EkekoColors.of(context).muted)),
          const SizedBox(height: 14),
          _Label('WhatsApp (con código de país, sin +)'),
          TextField(controller: _waCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '59170000000')),
          const SizedBox(height: 14),
          _Label('Instagram'),
          TextField(controller: _igCtrl, decoration: const InputDecoration(hintText: '@tunegocio')),
          const SizedBox(height: 14),
          _Label('TikTok'),
          TextField(controller: _ttCtrl, decoration: const InputDecoration(hintText: '@tunegocio')),
          const SizedBox(height: 14),
          _Label('Facebook'),
          TextField(controller: _fbCtrl, decoration: const InputDecoration(hintText: 'NombreDePagina')),
          const SizedBox(height: 14),
          _Label('Sitio web'),
          TextField(controller: _webCtrl, decoration: const InputDecoration(hintText: 'tunegocio.com')),
          const SizedBox(height: 14),
          _Label('Ubicación para el mapa'),
          TextField(controller: _mapsCtrl, decoration: const InputDecoration(hintText: 'Ej. Av. América, Cochabamba')),
          const SizedBox(height: 28),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _save, child: const Text('Guardar cambios'))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      );
}
