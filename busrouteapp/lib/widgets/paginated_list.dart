import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/blocs/bus_route_bloc.dart';
import 'package:busrouteapp/screens/detailed_screen.dart';
import 'package:busrouteapp/widgets/bus_route_list.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginatedBusRoutesList extends StatefulWidget {
  @override
  _PaginatedBusRoutesListState createState() => _PaginatedBusRoutesListState();
}

class _PaginatedBusRoutesListState extends State<PaginatedBusRoutesList> {
  int _currentPage = 1; 
  static const int _itemsPerPage = 10; 

  void _fetchRoutes() {
    context
        .read<BusRouteBloc>()
        .add(FetchBusRoutes(pageKey: _currentPage, items: _itemsPerPage));
  }

  @override
  void initState() {
    super.initState();
    _fetchRoutes(); 
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchRoutes();
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchRoutes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BusRouteBloc, BusRouteState>(
        builder: (context, state) {
          if (state is! BusRouteError && state is! BusRouteLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BusRouteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchRoutes,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is BusRouteLoaded) {
            final routes = state.routes;

            if (routes.isEmpty) {
              return const Center(child: Text('No bus routes available.'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final route = routes[index];
                      return BusRouteTile(
                        busRoute: route,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedScreen(
                                busNumber: route.busNumber,
                                fromLocation: route.fromLocation,
                                toLocation: route.toLocation,
                                route: route.route,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentPage > 1 ? _loadPreviousPage : null,
                        child: const Icon(Icons.arrow_back_ios_outlined),
                      ),
                      Text(
                        'Page $_currentPage',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, 
                          fontSize: 18, 
                          color: Colors.black, 
                          letterSpacing:
                              1.2, 
                        ),
                      ),
                      ElevatedButton(
                        onPressed: state.hasNextPage ? _loadNextPage : null,
                        child: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
