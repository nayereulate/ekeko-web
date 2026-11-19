import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/business.dart';

/// Utilidades para abrir enlaces externos del perfil de un negocio.
/// EKEKO solo enlaza a estos canales — el contacto y la venta ocurren
/// directamente entre comprador y vendedor, fuera de la app.
class LinkActions {
  LinkActions._();

  static Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace en este dispositivo.')),
      );
    }
  }

  static Future<void> openWhatsApp(BuildContext context, String phone, {String? message}) {
    final text = Uri.encodeComponent(message ?? 'Hola, vi tu catálogo en EKEKO y quisiera más información.');
    return _open(context, Uri.parse('https://wa.me/$phone?text=$text'));
  }

  static Future<void> openInstagram(BuildContext context, String handle) {
    final clean = handle.replaceAll('@', '');
    return _open(context, Uri.parse('https://instagram.com/$clean'));
  }

  static Future<void> openFacebook(BuildContext context, String handle) {
    return _open(context, Uri.parse('https://facebook.com/$handle'));
  }

  static Future<void> openTiktok(BuildContext context, String handle) {
    final clean = handle.replaceAll('@', '');
    return _open(context, Uri.parse('https://tiktok.com/@$clean'));
  }

  static Future<void> openWebsite(BuildContext context, String url) {
    final normalized = url.startsWith('http') ? url : 'https://$url';
    return _open(context, Uri.parse(normalized));
  }

  static Future<void> openMaps(BuildContext context, String query) {
    return _open(context, Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}'));
  }

  static List<Widget> availableChips(BuildContext context, BusinessLinks links) {
    final chips = <Widget>[];
    if (links.instagram != null) {
      chips.add(_LinkChip(icon: Icons.camera_alt_rounded, label: 'Instagram', onTap: () => openInstagram(context, links.instagram!)));
    }
    if (links.facebook != null) {
      chips.add(_LinkChip(icon: Icons.facebook_rounded, label: 'Facebook', onTap: () => openFacebook(context, links.facebook!)));
    }
    if (links.tiktok != null) {
      chips.add(_LinkChip(icon: Icons.music_note_rounded, label: 'TikTok', onTap: () => openTiktok(context, links.tiktok!)));
    }
    if (links.website != null) {
      chips.add(_LinkChip(icon: Icons.language_rounded, label: 'Sitio web', onTap: () => openWebsite(context, links.website!)));
    }
    if (links.mapsQuery != null) {
      chips.add(_LinkChip(icon: Icons.place_rounded, label: 'Ubicación', onTap: () => openMaps(context, links.mapsQuery!)));
    }
    return chips;
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: const Color(0xFFB5471B)),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: const Color(0xFFFDF2E7),
      side: const BorderSide(color: Color(0xFFEADFCF)),
    );
  }
}
