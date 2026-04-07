import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onGeolocationPressed() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
      }
      return;
    }

    try {
      await Geolocator.getCurrentPosition();
      ref.read(locationProvider.notifier).state = 'Geolocation';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    }
  }

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
