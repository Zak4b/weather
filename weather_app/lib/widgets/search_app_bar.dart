import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.onSearchSubmitted,
    required this.onGeolocationPressed,
  });

  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onGeolocationPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: TextField(
          controller: searchController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Search location...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          onSubmitted: onSearchSubmitted,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: onGeolocationPressed,
          tooltip: 'Geolocation',
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
