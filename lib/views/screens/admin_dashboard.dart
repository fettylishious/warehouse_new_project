import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'Users.dart'; // Import the Users screen
import 'warehouseId.dart'; // Import your warehouse screen

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final DatabaseReference _measurementsRef = FirebaseDatabase.instance.ref('measurements');

  int _totalUsers = 0;
  int _verifiedUsers = 0;
  int _unverifiedUsers = 0;
  List<FlSpot> _monthlyDataPoints = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchMeasurementsData();
  }

  Future<void> _fetchUserData() async {
    DataSnapshot snapshot = await _usersRef.get();
    if (snapshot.exists) {
      int total = 0;
      int verified = 0;
      int unverified = 0;
      Map data = snapshot.value as Map;
      data.forEach((key, value) {
        total++;
        if (value['verificationstatus'] == 'verified') {
          verified++;
        } else {
          unverified++;
        }
      });
      setState(() {
        _totalUsers = total;
        _verifiedUsers = verified;
        _unverifiedUsers = unverified;
      });
    }
  }

  Future<void> _fetchMeasurementsData() async {
    DataSnapshot snapshot = await _measurementsRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      List<Map<String, dynamic>> measurements = [];

      data.forEach((key, value) {
        double weight = double.parse(value['weight'].toString());
        DateTime dateTime = DateTime.parse(value['time']);
        measurements.add({
          'weight': weight,
          'time': dateTime,
        });
      });

      // Aggregate data by month
      Map<int, double> monthlyWeights = {};
      Map<int, int> monthlyCounts = {};

      for (var measurement in measurements) {
        int month = measurement['time'].month;
        double weight = measurement['weight'];

        if (monthlyWeights.containsKey(month)) {
          monthlyWeights[month] = monthlyWeights[month]! + weight;
          monthlyCounts[month] = monthlyCounts[month]! + 1;
        } else {
          monthlyWeights[month] = weight;
          monthlyCounts[month] = 1;
        }
      }

      List<FlSpot> monthlyDataPoints = [];
      monthlyWeights.forEach((month, totalWeight) {
        double averageWeight = totalWeight / monthlyCounts[month]!;
        monthlyDataPoints.add(FlSpot(month.toDouble(), averageWeight));
      });

      setState(() {
        _monthlyDataPoints = monthlyDataPoints;
      });
    }
  }

  String _getMonthName(int monthNumber) {
    DateTime date = DateTime(0, monthNumber);
    return DateFormat.MMM().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            )),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const UsersScreen()); // Navigate to Users screen
                    },
                    child: _buildInfoCard('Users', 'Total: $_totalUsers\nVerified: $_verifiedUsers\nUnverified: $_unverifiedUsers'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const WarehouseId()); // Navigate to Warehouses screen
                    },
                    child: _buildInfoCard('Warehouses', 'Click to view'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Measurements Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildLineChart(_monthlyDataPoints, 'Monthly Analysis', 'Weight over Months'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<FlSpot> dataPoints, String period, String title) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(_getMonthName(value.toInt())),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.3)),
                  ),
                ],
                minX: 1, // Start at January (month 1)
                maxX: 12, // End at December (month 12)
                minY: dataPoints.isNotEmpty ? dataPoints.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0,
                maxY: dataPoints.isNotEmpty ? dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
