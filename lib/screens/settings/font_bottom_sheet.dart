import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad/main.dart';
import 'package:zad/shared/localization/localizations.dart';

import '../../shared/core/font/font_manager.dart';

class FontBottomSheet extends StatefulWidget {
  final Function(String fontFamily)? onSelect;

  const FontBottomSheet({super.key, this.onSelect});

  @override
  State<FontBottomSheet> createState() => _FontBottomSheetState();
}

class _FontBottomSheetState extends State<FontBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _sheetView(context);
  }

  Widget _sheetView(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showSheet();
      },
      child: Text(
        localizations.font_type,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16.0),
        child: _fontListView(),
      ),
    );
  }

  FontItem? _selectedFont;

  final List<FontItem> _fontOptions = [
    FontItem(name: localizations.basmalah, family: 'Cairo'),
    FontItem(name: localizations.basmalah, family: 'Roboto'),
    FontItem(name: localizations.basmalah, family: 'Courier New')
  ];

  Widget _fontListView() {
    return ListView.builder(
      itemCount: _fontOptions.length,
      itemBuilder: (context, index) {
        final font = _fontOptions[index];
        return ListTile(
          title: Text(
            font.name,
            style: TextStyle(
              fontFamily: font.family,
              fontSize: 18.0,
            ),
          ),
          trailing: _selectedFont == font
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () {
            _saveFont(font);
          },
        );
      },
    );
  }

  Future<void> _saveFont(FontItem font) async {
    setState(() {
      _selectedFont = font;
    });
    await FontManager.instance.save(_selectedFont!.family);
    Navigator.pop(context);
    widget.onSelect!(_selectedFont!.family);
  }
}

class FontItem {
  final String name;
  final String family;

  FontItem({
    required this.name,
    required this.family,
  });
}
