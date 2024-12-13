import 'dart:convert';
import 'package:http/http.dart' as http;

class BusService {
  // Base URL for the bus routes search API
  final String baseUrl = 'https://app-bootcamp.iris.nitk.ac.in/bus_routes/search/';

  // Search bus routes by location
  Future<List<Map<String, dynamic>>> searchByLocation(String? fromLocation, String? toLocation) async {
    if ((fromLocation == null || fromLocation.isEmpty) &&
        (toLocation == null || toLocation.isEmpty)) {
      throw ArgumentError('At least one of "fromLocation" or "toLocation" must be provided.');
    }

    final queryParameters = <String, String>{};
    if (fromLocation != null && fromLocation.isNotEmpty) {
      queryParameters['from_location'] = fromLocation;
    }
    if (toLocation != null && toLocation.isNotEmpty) {
      queryParameters['to_location'] = toLocation;
    }

    final Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } catch (e) {
        throw Exception('Failed to decode response: ${response.body}');
      }
    } else if (response.statusCode == 404) {
      throw Exception('No matching routes found.');
    } else {
      throw Exception('Failed to fetch routes. Status code: ${response.statusCode}');
    }
  }

  // Get bus route by bus number
  Future<Map<String, dynamic>> getRouteByBusNumber(String busNumber) async {
    final url = Uri.parse('$baseUrl?bus_number=$busNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          return data[0];  // Assuming the response contains a list, we return the first item
        } else {
          throw Exception('No route found for bus number: $busNumber');
        }
      } catch (e) {
        throw Exception('Failed to decode response: ${response.body}');
      }
    } else if (response.statusCode == 404) {
      throw Exception('No route found for bus number: $busNumber');
    } else {
      throw Exception('Failed to fetch route. Status code: ${response.statusCode}');
    }
  }
}
