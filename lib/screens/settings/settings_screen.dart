import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad/shared/localization/localizations.dart';
import 'package:zad/shared/presentation/navigator_pop.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Example',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
// basmalah
class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setInt('fontColor', _fontColor.value);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? _fontSize;
      _fontColor = Color(prefs.getInt('fontColor') ?? _fontColor.value);
    });
  }

  void changeColor(Color color) {
    setState(() => _fontColor = color);
  }

  showColorPickerDialog() {
    showDialog(
      builder: (context) => AlertDialog(
        title: Text(
          localizations.pick_color,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _fontColor,
            onColorChanged: changeColor,
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: true,
            displayThumbColor: true,
            showLabel: true,
            paletteType: PaletteType.hsl,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              localizations.done,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.teal,
              ),
            ),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ), context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(localizations.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.font_size,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _fontSize,
              min: 10.0,
              max: 30.0,
              divisions: 30,
              label: _fontSize.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: showColorPickerDialog,
                  child: Text(
                    localizations.font_color,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
        child: FloatingActionButton(
          onPressed: () async {
            await _saveSettings();
            pop();
          },
          child: Text(localizations.save),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}