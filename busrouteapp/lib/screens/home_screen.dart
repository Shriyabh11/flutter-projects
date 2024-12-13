import 'package:busrouteapp/widgets/paginated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/screens/favourite_screen.dart';
import 'package:busrouteapp/screens/search_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:busrouteapp/blocs/bus_route_bloc.dart';
import 'package:busrouteapp/services/bus_route_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of pages for BottomNavigationBar
  static final List<Widget> _pages = <Widget>[
    PaginatedBusRoutesList(), // Paginated list of bus routes
    FavouriteScreen(),
  
    SearchScreen(),
  ];

  // Handle BottomNavigationBar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide the BusRouteBloc with BusRouteService
      create: (context) => BusRouteBloc(busRouteService: BusRouteService())
        ..add(FetchBusRoutes(pageKey: 1,items: 10)), // Trigger initial load
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bus Route App',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Colors.blue[900], // Same as BottomNavigationBar
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.blue[900], // Same blue color as AppBar
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Material(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.blue[900], // Match the AppBar's color
              elevation: 0.0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Liked',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.white, // White for selected icon
              unselectedItemColor: Colors.white, // White for unselected icon
            ),
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
