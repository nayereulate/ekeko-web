import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/business_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final favorites = appState.favoriteBusinesses;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos'), automaticallyImplyLeading: false),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 84, height: 84,
                      decoration: const BoxDecoration(color: Color(0x1AD9534F), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border_rounded, size: 40, color: Color(0xFFD9534F)),
                    ),
                    const SizedBox(height: 14),
                    const Text('Aún no tienes favoritos', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      'Toca el corazón en un negocio para guardarlo aquí.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => BusinessCard(
                    business: favorites[i],
                    onTap: () => Navigator.of(context).pushNamed('/tienda/${favorites[i].slug}'),
                  ),
                ),
              ),
            ),
    );
  }
}
