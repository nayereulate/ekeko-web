import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import 'hover_lift.dart';
import 'plan_badge.dart';
import 'rating_stars.dart';
import 'trust_badges.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const BusinessCard({super.key, required this.business, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isFav = appState.isFavorite(business.id);
    final ek = EkekoColors.of(context);
    final dist = appState.distanceKm(business);

    return HoverLift(
      child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de color de marca
            Container(
              height: 46,
              decoration: BoxDecoration(gradient: AppColors.coverGradient(business.color)),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: PlanBadge(plan: business.plan),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 6, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _IconAvatar(business: business, size: 50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(children: [
                          Flexible(child: Text(business.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), overflow: TextOverflow.ellipsis)),
                          if (business.isVerified) ...[const SizedBox(width: 4), const Icon(Icons.verified_rounded, color: AppColors.success, size: 16)],
                        ]),
                        const SizedBox(height: 2),
                        Text('${business.category}${business.serviceType != null ? ' · ${business.serviceType}' : ''}',
                            style: TextStyle(color: ek.muted, fontSize: 12.5), overflow: TextOverflow.ellipsis),
                        Row(children: [
                          Icon(Icons.place_rounded, size: 13, color: ek.muted),
                          const SizedBox(width: 2),
                          Flexible(child: Text('${business.zone}, ${business.city}', style: TextStyle(color: ek.muted, fontSize: 12), overflow: TextOverflow.ellipsis)),
                          if (dist != null) ...[
                            const SizedBox(width: 6),
                            Text('· ${dist.toStringAsFixed(dist < 10 ? 1 : 0)} km', style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700)),
                          ],
                        ]),
                        const SizedBox(height: 6),
                        RatingStars(rating: business.rating, reviewCount: business.reviewCount),
                        const SizedBox(height: 8),
                        TrustBadges(business: business, compact: true),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => appState.toggleFavorite(business.id),
                    icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.danger : ek.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     ),
    );
  }
}

class _IconAvatar extends StatelessWidget {
  final Business business;
  final double size;
  const _IconAvatar({required this.business, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.coverGradient(business.color),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(AppIcons.forBusiness(business.category, serviceType: business.serviceType),
          color: Colors.white, size: size * 0.5),
    );
  }
}
