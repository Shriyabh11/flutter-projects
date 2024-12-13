import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/services/search_service.dart';

// Events
abstract class SearchEvent {}

class SearchByLocationEvent extends SearchEvent {
  final String? fromLocation;
  final String? toLocation;

  SearchByLocationEvent({this.fromLocation, this.toLocation});
}

class SearchByBusNumberEvent extends SearchEvent {
  final String busNumber;

  SearchByBusNumberEvent(this.busNumber);
}

// States
abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<dynamic> busRoutes;

  SearchSuccessState(this.busRoutes);
}

class SearchErrorState extends SearchState {
  final String message;

  SearchErrorState(this.message);
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BusService busService;

  SearchBloc({required this.busService}) : super(SearchInitialState()) {
    on<SearchByLocationEvent>(_onSearchByLocationEvent);
    on<SearchByBusNumberEvent>(_onSearchByBusNumberEvent);
  }

  Future<void> _onSearchByLocationEvent(
      SearchByLocationEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());

    try {
      final busRoutes = await busService.searchByLocation(event.fromLocation, event.toLocation);
      if (busRoutes.isEmpty) {
        emit(SearchErrorState('No buses found for the given locations.'));
      } else {
        emit(SearchSuccessState(busRoutes));
      }
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode == 404) {
          emit(SearchErrorState('No matching routes found (404 Not Found).'));
        } else if (e.statusCode == 500) {
          emit(SearchErrorState('Server error, please try again later (500 Internal Server Error).'));
        } else {
          emit(SearchErrorState('Failed to load routes.'));
        }
      } else {
        emit(SearchErrorState('Failed to load routes.'));
      }
    }
  }

  Future<void> _onSearchByBusNumberEvent(
      SearchByBusNumberEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());

    try {
      final busRoute = await busService.getRouteByBusNumber(event.busNumber);
      emit(SearchSuccessState([busRoute]));  // Wrap the route in a list
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode == 404) {
          emit(SearchErrorState('No bus route found for the given bus number (404 Not Found).'));
        } else if (e.statusCode == 500) {
          emit(SearchErrorState('Server error, please try again later (500 Internal Server Error).'));
        } else {
          emit(SearchErrorState('Failed to load bus route.'));
        }
      } else {
        emit(SearchErrorState('Failed to load bus route.'));
      }
    }
  }
}
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});
}
