import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/location_provider.dart';

class TabContent extends ConsumerWidget {
  const TabContent({
    super.key,
    required this.tabName,
  });

  final String tabName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
