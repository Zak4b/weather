import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/location_service.dart';
import '../state/location_provider.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/tab_content.dart';
import '../widgets/weather_bottom_bar.dart';

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key});

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  static const _tabs = ['Currently', 'Today', 'Weekly'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGpsLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchGpsLocation() async {
    try {
      final position = await fetchGpsPosition();
      if (!mounted) return;
      ref.read(locationProvider.notifier).state =
          formatGpsCoordinates(position);
    } on LocationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _onGeolocationPressed() => _fetchGpsLocation();

  void _onSearchSubmitted(String value) {
    ref.read(locationProvider.notifier).state = value.trim();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: SearchAppBar(
          searchController: _searchController,
          focusNode: _searchFocusNode,
          onSearchSubmitted: _onSearchSubmitted,
          onGeolocationPressed: _onGeolocationPressed,
        ),
        body: TabBarView(
          children: List.generate(_tabs.length, (index) {
            return TabContent(
              tabName: _tabs[index],
            );
          }),
        ),
        bottomNavigationBar: const WeatherBottomBar(),
      ),
    );
  }
}
