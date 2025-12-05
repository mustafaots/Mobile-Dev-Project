import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/logic/cubit/details_cubit.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/DetailsSectionWidgets/detail_card.dart';
import 'package:easy_vacation/screens/DetailsSectionWidgets/price_section.dart';
import 'package:easy_vacation/screens/DetailsSectionWidgets/empty_details_state.dart';

class DetailsSection extends StatelessWidget {
  final Post? post;
  final String? category;
  final Stay? stay;
  final Vehicle? vehicle;
  final Activity? activity;
  final bool isLoading;

  const DetailsSection({
    super.key,
    this.post,
    this.category,
    this.stay,
    this.vehicle,
    this.activity,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => DetailsCubit()
        ..loadDetails(
          post: post,
          category: category,
          stay: stay,
          vehicle: vehicle,
          activity: activity,
          loc: loc,
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details List
            BlocBuilder<DetailsCubit, DetailsState>(
              builder: (context, state) {
                if (isLoading) {
                  return const _LoadingState();
                }

                if (state is DetailsLoading) {
                  return const _LoadingState();
                }

                if (state is DetailsError) {
                  return _ErrorState(message: state.message);
                }

                if (state is DetailsLoaded) {
                  final details = state.allDetails;

                  if (details.isEmpty) {
                    return EmptyDetailsState(
                      onRetry: () {
                        context.read<DetailsCubit>().loadDetails(
                          post: post,
                          category: category,
                          stay: stay,
                          vehicle: vehicle,
                          activity: activity,
                          loc: loc,
                        );
                      },
                    );
                  }

                  return Column(
                    children: details
                        .map(
                          (detail) => DetailCard(
                            label: detail['label'] as String,
                            value: detail['value'] as String,
                            icon: detail['icon'] as String,
                          ),
                        )
                        .toList(),
                  );
                }

                return const SizedBox.shrink();
              },
            ),

            // Price Section
            const SizedBox(height: 12),
            PriceSection(
              price: post?.price,
              category: category ?? post?.category,
              isAvailable: post?.status == 'active',
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
