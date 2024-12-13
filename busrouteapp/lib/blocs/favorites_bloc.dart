import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// Abstract class for Favorite routes events
abstract class FavouriteRoutes {}

// Event for liking a route
class LikedButtonClicked extends FavouriteRoutes {
  final String busNumber;
  final String fromLocation;
  final String toLocation;
  final String routeDetails;

  LikedButtonClicked({
    required this.busNumber,
    required this.fromLocation,
    required this.toLocation,
    required this.routeDetails,
  });
}

// Event for unliking a route
class UnLikedButtonClicked extends FavouriteRoutes {
  final String busNumber;

  UnLikedButtonClicked({required this.busNumber});
}

// Event to load all favorite routes
class LoadFavorites extends FavouriteRoutes {}

// Abstract class for Favorite states
abstract class FavoriteState {}

// Initial state when no action has occurred
class FavoriteInitial extends FavoriteState {}

// State when a route is successfully liked
class RouteLiked extends FavoriteState {
  final String busNumber;

  RouteLiked(this.busNumber);
}

// State when a route is successfully unliked
class RouteUnliked extends FavoriteState {
  final String busNumber;

  RouteUnliked(this.busNumber);
}

// State when all favorites are loaded
class FavoritesLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favourites;

  FavoritesLoaded(this.favourites);
}

// Bloc to manage favorite routes
class FavoriteBloc extends Bloc<FavouriteRoutes, FavoriteState> {
  final Box favourites;

  FavoriteBloc(this.favourites) : super(FavoriteInitial()) {
    

    on<LoadFavorites>((event, emit) {
  try {
    final favorites = favourites.values
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList();
    emit(FavoritesLoaded(favorites));
  } catch (e) {
    print("Error loading favorites: $e");
    emit(FavoritesLoaded([])); // Emit an empty list if an error occurs
  }
});

on<LikedButtonClicked>((event, emit) async {
  try {
    favourites.put(
      event.busNumber,
      {
        'bus_number':event.busNumber,
        'from_location': event.fromLocation,
        'to_location': event.toLocation,
        'route': event.routeDetails,
      },
    );
    emit(RouteLiked(event.busNumber));
    add(LoadFavorites()); // Reload favorites
  } catch (e) {
    print("Error liking route: $e");
    emit(FavoritesLoaded(favourites.values
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList()));
  }
});

on<UnLikedButtonClicked>((event, emit) async {
  try {
    favourites.delete(event.busNumber);
    emit(RouteUnliked(event.busNumber));
    add(LoadFavorites()); // Reload favorites
  } catch (e) {
    print("Error unliking route: $e");
    emit(FavoritesLoaded(favourites.values
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList()));
  }
});
}}