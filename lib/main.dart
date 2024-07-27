import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zad/sections/sections_screen.dart';
import 'package:zad/shared/app/app.dart';
import 'package:zad/shared/core/services/services_locator.dart';
import 'package:zad/shared/core/state_manager/app_state_manager.dart';
import 'package:zad/shared/data/database/zad_database.dart';
import 'package:zad/shared/presentation/controller/lectures_bloc.dart';
import 'package:zad/shared/presentation/side_drawer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServicesLocator().setup();

  await ZadDatabase().setup();
  await AppStateManager.instance.setup();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateManager.instance,
      child: Consumer<AppStateManager>(
        builder: (context, languageProvider, child) {
          final languageManager = Provider.of<AppStateManager>(context);
          return _app(languageManager);
        },
      ),
    );
  }

  Widget _app(AppStateManager appStateManager) {
    return BlocProvider(
        create: (BuildContext context) => locator<LecturesBloc>(),
        child: MaterialApp(
          title: '',
          theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                shadowColor: Colors.transparent,
              ),
            ),
            fontFamily: appStateManager.fontFamily,
          ),
          navigatorKey: App.navigatorKey,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'),
          ],
        ));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      drawer: const SideDrawer(),
      body: const SectionsScreen(),
    );
  }
}




