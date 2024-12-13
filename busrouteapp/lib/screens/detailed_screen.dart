import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:busrouteapp/blocs/favorites_bloc.dart';

class DetailedScreen extends StatelessWidget {
  final String busNumber;
  final String fromLocation;
  final String toLocation;
  final String route;

  const DetailedScreen({
    required this.busNumber,
    required this.fromLocation,
    required this.toLocation,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    // Helper function to clean the route string
    String cleanRoute(String route) {
      return route
          .replaceAll('â€“', '-') // Fix incorrect en dash encoding
          .replaceAll('â€™', "'") // Fix incorrect apostrophe encoding
          .trim(); // Remove unwanted spaces
    }

    // Split the route into a list of stops
    List<String> stops = cleanRoute(route)
        .split(RegExp(r'[^a-zA-Z0-9\s]')) // Match anything that's not a letter, number, or space
        .where((stop) => stop.isNotEmpty) // Remove empty strings
        .map((stop) => stop.trim()) // Trim each stop
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bus Route $busNumber',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is RouteLiked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Route ${state.busNumber} added to favorites")),
            );
          } else if (state is RouteUnliked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Route ${state.busNumber} removed from favorites")),
            );
          }
        },
        builder: (context, state) {
          final favourites = Hive.box('favourites');
          bool isLiked = favourites.containsKey(busNumber);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Start Location
                Card(
                  color: Colors.green[50],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.green, width: 2),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.directions_bus, color: Colors.green),
                    title: Text(
                      fromLocation,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    subtitle: Text('Start Location'),
                  ),
                ),
                const SizedBox(height: 16),
                // Route Stops
                Expanded(
  child: ListView.separated(
    itemCount: stops.length - 1, // Includes all intermediate stops and end location
    separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
    itemBuilder: (context, index) {
      if (index == stops.length - 2) {
        // End location as the last item
        return Card(
          color: Colors.red[50],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.red, width: 2),
          ),
          child: ListTile(
            leading: Icon(Icons.location_on, color: Colors.red),
            title: Text(
              toLocation,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            subtitle: Text('End Location'),
          ),
        );
      } else {
        // Regular stop
        final stop = stops[index + 1]; // Skipping the start location
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          title: Text(
            stop,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        );
      }
    },
  ),
),

                
                
             
                // Favorite Button
                ElevatedButton.icon(
                  onPressed: () {
                    if (isLiked) {
                      context.read<FavoriteBloc>().add(
                            UnLikedButtonClicked(busNumber: busNumber),
                          );
                    } else {
                      context.read<FavoriteBloc>().add(
                            LikedButtonClicked(
                              busNumber: busNumber,
                              fromLocation: fromLocation,
                              toLocation: toLocation,
                              routeDetails: route,
                            ),
                          );
                    }
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    isLiked ? "Remove from Favorites" : "Add to Favorites",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLiked ? Colors.red : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

