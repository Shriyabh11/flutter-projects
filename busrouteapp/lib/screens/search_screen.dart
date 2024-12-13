import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:busrouteapp/blocs/search_bloc.dart';
import 'package:busrouteapp/screens/detailed_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController startLocationController = TextEditingController();
  final TextEditingController endLocationController = TextEditingController();
  final TextEditingController busNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Location Input
            TextFormField(
              controller: startLocationController,
              cursorColor: Colors.blue[900],
              maxLength: 20,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                labelText: 'Start Location',
                hintText: 'Enter Start Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // End Location Input
            TextFormField(
              controller: endLocationController,
              cursorColor: Colors.blue[900],
              maxLength: 20,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                labelText: 'End Location',
                hintText: 'Enter End Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // OR Separator
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'OR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Bus Number Input
            TextFormField(
              controller: busNumberController,
              cursorColor: Colors.blue[900],
              maxLength: 10,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.directions_bus),
                labelText: 'Search by Bus Number',
                hintText: 'Enter Bus Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String startLocation = startLocationController.text;
                  final String endLocation = endLocationController.text;
                  final String busNumber = busNumberController.text;

                  if (busNumber.isNotEmpty && startLocation.isEmpty && endLocation.isEmpty) {
                    context.read<SearchBloc>().add(SearchByBusNumberEvent(busNumber));
                  } else if (startLocation.isNotEmpty || endLocation.isNotEmpty) {
                    context.read<SearchBloc>().add(
                      SearchByLocationEvent(
                        fromLocation: startLocation,
                        toLocation: endLocation,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid search criteria')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text('Search', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            // Search Results
            BlocListener<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchErrorState && state.message == 'No buses found') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('No Buses Found'),
                      content: const Text('There are no buses matching your search criteria.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchSuccessState) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.busRoutes.length,
                        itemBuilder: (context, index) {
                          final route = state.busRoutes[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedScreen(
                                      busNumber: route['bus_number'],
                                      fromLocation: route['from_location'],
                                      toLocation: route['to_location'],
                                      route: route['route'],
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                '${route['from_location']} → ${route['to_location']}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Bus Number: ${route['bus_number']}'),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is SearchErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
