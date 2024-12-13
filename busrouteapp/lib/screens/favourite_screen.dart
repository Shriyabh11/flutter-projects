import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:busrouteapp/blocs/favorites_bloc.dart';
import 'detailed_screen.dart'; 

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: BlocListener<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is RouteLiked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Route ${state.busNumber} added to favorites"),
              ),
            );
          } else if (state is RouteUnliked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Route ${state.busNumber} removed from favorites"),
              ),
            );
          }
        },
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesLoaded) {
              return state.favourites.isEmpty
                  ? const Center(
                      child: Text(
                        "No favorites yet!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: state.favourites.length,
                      itemBuilder: (context, index) {
                        final favorite = state.favourites[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Icon(
                                Icons.directions_bus,
                                color: Colors.blue[800],
                              ),
                            ),
                            title: Text(
                              favorite['bus_number'] ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  "${favorite['from_location']} → ${favorite['to_location']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                context.read<FavoriteBloc>().add(
                                  UnLikedButtonClicked(
                                    busNumber: favorite['bus_number'] ?? '',
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedScreen(
                                    busNumber: favorite['bus_number'] ?? 'Unknown',
                                    fromLocation: favorite['from_location'] ?? 'Unknown',
                                    toLocation: favorite['to_location'] ?? 'Unknown',
                                    route: favorite['route'] ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
            } else {
              return const Center(
                child: Text(
                  "Something went wrong. Please try again.",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
