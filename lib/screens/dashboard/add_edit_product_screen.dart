import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? existing;
  const AddEditProductScreen({super.key, this.existing});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  late final _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
  late final _priceCtrl = TextEditingController(text: widget.existing != null ? widget.existing!.price.toStringAsFixed(widget.existing!.price % 1 == 0 ? 0 : 2) : '');
  late final _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
  late bool _featured = widget.existing?.isFeatured ?? false;
  late bool _inStock = widget.existing?.inStock ?? true;
  late Uint8List? _image = widget.existing?.image;

  bool get _editing => widget.existing != null;
  bool get _canSave => _nameCtrl.text.trim().isNotEmpty && _priceCtrl.text.trim().isNotEmpty;

  Future<void> _pickImage() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 82, maxWidth: 1000);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() => _image = bytes);
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('No se pudo cargar la imagen.')));
    }
  }

  void _save() {
    final app = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    if (_editing) {
      app.updateMyProduct(Product(
        id: widget.existing!.id, businessId: widget.existing!.businessId,
        name: _nameCtrl.text.trim(), price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        description: _descCtrl.text.trim(), emoji: widget.existing!.emoji,
        inStock: _inStock, isFeatured: _featured, variants: widget.existing!.variants, image: _image,
      ));
    } else {
      app.addProductToMyBusiness(Product(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}', businessId: app.myBusiness.id,
        name: _nameCtrl.text.trim(), price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        description: _descCtrl.text.trim(), emoji: '📦', inStock: _inStock, isFeatured: _featured, image: _image,
      ));
    }
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(_editing ? 'Producto actualizado.' : 'Producto agregado a tu catálogo.')));
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final color = app.myBusiness.color;
    final category = app.myBusiness.category;
    final ek = EkekoColors.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Editar producto' : 'Agregar producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Foto del producto', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                gradient: _image == null ? AppColors.coverGradient(color) : null,
                image: _image != null ? DecorationImage(image: MemoryImage(_image!), fit: BoxFit.cover) : null,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: _image == null
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(AppIcons.forProduct(_nameCtrl.text, category), color: Colors.white, size: 46),
                      const SizedBox(height: 8),
                      const Text('Toca para subir una foto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const Text('Si no subes, usamos un icono', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ])
                  : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                          onPressed: () => setState(() => _image = null),
                        )),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Nombre del producto', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(controller: _nameCtrl, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Ej. Chompa de alpaca')),
          const SizedBox(height: 14),
          const Text('Precio (Bs)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(controller: _priceCtrl, onChanged: (_) => setState(() {}), keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(hintText: '0 = "Consultar"')),
          const SizedBox(height: 14),
          const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Detalles, materiales, tallas…')),
          const SizedBox(height: 6),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _inStock, onChanged: (v) => setState(() => _inStock = v), title: const Text('Disponible en stock', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5))),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _featured, onChanged: (v) => setState(() => _featured = v), title: const Text('Marcar como destacado', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)), subtitle: Text('Aparece primero en tu vitrina', style: TextStyle(fontSize: 11.5, color: ek.muted))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _canSave ? _save : null, child: Text(_editing ? 'Guardar cambios' : 'Publicar producto'))),
        ],
      ),
    );
  }
}
