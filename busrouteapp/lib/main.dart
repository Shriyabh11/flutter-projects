import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/blocs/favorites_bloc.dart';
import 'package:busrouteapp/blocs/search_bloc.dart';
import 'package:busrouteapp/services/search_service.dart';
import 'package:busrouteapp/screens/home_screen.dart';
import 'package:busrouteapp/screens/favourite_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter(); // Simplifies setup for all platforms
  Box hiveBox;
  try {
  hiveBox = await Hive.openBox('favourites');
  print('Hive box opened: ${hiveBox.toMap()}'); // Print the box's contents
} catch (e) {
  print('Failed to open Hive box: $e');
  return; // Exit the app if the box cannot be opened
}
  runApp(MyApp(favourites: hiveBox));
}

class MyApp extends StatelessWidget {
  final Box favourites;
  final BusService busService = BusService();

  MyApp({Key? key, required this.favourites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(favourites)
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(busService: busService),
        ),
      ],
      child: MaterialApp(
        title: 'Bus Route App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ),
        home: HomeScreen(), // Default home screen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
