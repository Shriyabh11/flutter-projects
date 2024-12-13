
class BusRoute {
  final String busNumber;
  final String fromLocation;
  final String toLocation;
  final String  route;

  BusRoute({
    required this.busNumber,
    required this.fromLocation,
    required this.toLocation,
    required this.route,
  });

factory BusRoute.fromJson(Map<String, dynamic> json) {
  return BusRoute(
    busNumber: json['bus_number'] ?? 'Unknown',
    fromLocation: json['from_location'] ?? 'Unknown',
    toLocation: json['to_location'] ?? 'Unknown',
    route: json['route'] ?? 'Unknown',
  );
}
}


class PaginatedBusRoute {
  final List<BusRoute> routes;  // List of bus routes
  final int total; // Total number of bus routes
  final int page;  // Current page number
  final int size;  // Number of routes per page
  final int totalPages; // Total number of pages

  // Constructor to initialize the PaginatedBusRoute
  PaginatedBusRoute({
    required this.routes,
    required this.total,
    required this.page,
    required this.size,
    required this.totalPages,
  });

  // Factory constructor to parse JSON for paginated responses
  factory PaginatedBusRoute.fromJson(Map<String, dynamic> json) {
    var list = json['routes'] as List;
    List<BusRoute> busRoutesList = list.map((i) => BusRoute.fromJson(i)).toList();

    return PaginatedBusRoute(
      routes: busRoutesList,
      total: json['total'],
      page: json['page'],
      size: json['size'],
      totalPages: json['total_pages'],
    );
  }
}

