import 'dart:convert';
import 'package:busrouteapp/models/bus_route.dart';
import 'package:http/http.dart' as http;

class BusRouteService {
  static const String baseUrl = 'https://app-bootcamp.iris.nitk.ac.in';

  // Fetch bus routes with pagination
 Future<List<BusRoute>> getBusRoutes(int page) async {
  final url = Uri.parse('$baseUrl/bus_routes/?page=$page');
  final response = await http.get(url);
  
  // Log the raw response body

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
 

    
    // Safely access bus routes under the "routes" key
    final busRoutes = jsonResponse['routes'];
   
   

    if (busRoutes.isEmpty) {
      print('No bus routes available.');
      return [];
    }

    return (busRoutes as List)
        .map((route) => BusRoute.fromJson(route))
        .toList();
  } else {
    throw Exception('Failed to load bus routes. Status code: ${response.statusCode}');
  }
}
}
