import 'package:flutter/material.dart';

class WeatherBottomBar extends StatelessWidget {
  const WeatherBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: TabBar(
        tabs: const [
          Tab(icon: Icon(Icons.wb_sunny), text: 'Currently'),
          Tab(icon: Icon(Icons.today), text: 'Today'),
          Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
        ],
      ),
    );
  }
}
