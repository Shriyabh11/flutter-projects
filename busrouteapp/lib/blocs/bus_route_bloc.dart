import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/models/bus_route.dart';
import 'package:busrouteapp/services/bus_route_service.dart';


abstract class BusRouteEvent {}

class FetchBusRoutes extends BusRouteEvent {
  final int pageKey;
  int items;


  FetchBusRoutes({required this.pageKey,required this.items});
}

abstract class BusRouteState {}

class BusRouteInitial extends BusRouteState {}

class BusRouteLoaded extends BusRouteState {
  final List<BusRoute> busRoutes;
  final bool hasNextPage;

  BusRouteLoaded({required this.busRoutes, required this.hasNextPage});

  // Getter for routes
  List<BusRoute> get routes => busRoutes;
}

class BusRouteError extends BusRouteState {
  final String message;

  BusRouteError({required this.message});
}

class BusRouteBloc extends Bloc<BusRouteEvent, BusRouteState> {
  final BusRouteService busRouteService;
 

  // Constructor initializing BusRouteService
  BusRouteBloc({required this.busRouteService}) : super(BusRouteInitial()) {
    // Listen for FetchBusRoutes event
    on<FetchBusRoutes>(_onFetchBusRoutes);
  }

  // Method to handle FetchBusRoutes event
  Future<void> _onFetchBusRoutes(
      FetchBusRoutes event, Emitter<BusRouteState> emit) async {
    try {
      // Fetching the bus routes for the current page
      final newBusRoutes = await busRouteService.getBusRoutes(event.pageKey);

      // Determine if there are more pages to fetch (assuming 10 routes per page)
      final hasNextPage = newBusRoutes.length == event.items;

      // Handle when routes are already loaded (pagination)
      if (state is BusRouteLoaded) {
        
        final currentRoutes = (state as BusRouteLoaded).busRoutes;
        // Merge new routes with existing routes
        emit(BusRouteLoaded(
          busRoutes: newBusRoutes,
          hasNextPage: hasNextPage,
        ));
      } else {
        // Initial load (no existing routes)
        emit(BusRouteLoaded(busRoutes: newBusRoutes, hasNextPage: hasNextPage));
      }
    } catch (e) {
      // Emit error state if fetching routes fails
      emit(BusRouteError(message: 'Failed to load bus routes: $e'));
    }
  }
}
