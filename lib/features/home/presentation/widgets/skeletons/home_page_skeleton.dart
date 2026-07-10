import 'package:flutter/material.dart';

import 'package:eco_wallet/features/home/presentation/widgets/skeletons/balance_card_skeleton.dart';
import 'package:eco_wallet/features/home/presentation/widgets/skeletons/eco_footprint_skeleton.dart';
import 'package:eco_wallet/features/home/presentation/widgets/skeletons/home_actions_buttons_skeleton.dart';
import 'package:eco_wallet/features/home/presentation/widgets/skeletons/home_header_skeleton.dart';
import 'package:eco_wallet/features/home/presentation/widgets/skeletons/transaction_section_skeleton.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeaderSkeleton(),
                    const SizedBox(height: 20),
                    BalanceCardSkeleton(),
                    const SizedBox(height: 8),
                    HomeActionsButtonsSkeleton(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EcoFootprintSkeleton(),
                  const SizedBox(height: 16),
                  TransactionSectionSkeleton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
