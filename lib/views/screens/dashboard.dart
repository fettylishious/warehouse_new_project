import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_project/views/screens/signin.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference _weightRef = FirebaseDatabase.instance.ref('measurements');
  List<Map<String, dynamic>> _measurements = [];
  double _totalWeight = 0.0;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _fetchMeasurements();
  }

  void _checkAuthentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => const SigninScreen());
      }
    });
  }

  void _fetchMeasurements() {
    _weightRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      final List<Map<String, dynamic>> loadedMeasurements = [];
      double totalWeight = 0.0;

      if (data != null) {
        data.forEach((key, value) {
          double weight = (value['weight'] as num).toDouble();
          loadedMeasurements.add({
            'id': key,
            'weight': weight,
            'time': value['time'],
          });
          totalWeight += weight; // Accumulate the total weight
        });
      }

      setState(() {
        _measurements = loadedMeasurements.reversed.toList(); // Reverse for latest first
        _totalWeight = totalWeight;
      });
    });
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // If the date string is not in ISO format, try to parse it as a custom format
      try {
        return DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateString);
      } catch (e) {
        // If all parsing fails, return a default date
        return DateTime.now();
      }
    }
  }

  String _formatTime(String usTime) {
    final DateTime usDateTime = _parseDate(usTime);
    final DateTime tzDateTime = usDateTime.add(const Duration(hours: 8)); // Tanzania is +8 hours ahead of US time (UTC)
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(tzDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total amount of crop in kg',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${_totalWeight.toStringAsFixed(2)} kg', // Display the total weight with two decimal places
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.scale,
                        color: Colors.green,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crop measurements',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _measurements.isEmpty
                            ? const Center(child: Text('No measurements yet'))
                            : ListView.builder(
                          itemCount: _measurements.length,
                          itemBuilder: (ctx, index) {
                            final measurement = _measurements[index];
                            final formattedDate = _formatTime(measurement['time']);
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15.0),
                                title: Text(
                                  'ID: ${measurement['id']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Weight: ${measurement['weight']} kg',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Date & Time: $formattedDate',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








