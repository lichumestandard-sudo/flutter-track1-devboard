import 'package:flutter/material.dart';

class DefenseDashboardScreen extends StatelessWidget {
  const DefenseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Defense Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // GridView.extent automatically calculates column count based on max width
      body: GridView.extent(
        maxCrossAxisExtent: 350, // No card will be wider than 350px before wrapping
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.5, // Controls the width-to-height ratio of the cards
        children: const [
          MetricCard(
            title: 'NetGuard Scans Completed',
            value: '142',
            icon: Icons.security,
            color: Colors.green,
            trend: '+12% this week',
          ),
          MetricCard(
            title: 'Active Server Nodes',
            value: '4 / 4',
            icon: Icons.router,
            color: Colors.blue,
            trend: 'All systems operational',
          ),
          MetricCard(
            title: 'DXANG Client Tasks',
            value: '7',
            icon: Icons.assignment,
            color: Colors.orange,
            trend: '3 due this week',
          ),
          MetricCard(
            title: 'System Uptime',
            value: '99.9%',
            icon: Icons.timer,
            color: Colors.purple,
            trend: 'Last reboot: 14 days ago',
          ),
        ],
      ),
    );
  }
}

// A reusable widget so you don't repeat layout code for every metric
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                ),
                Icon(icon, color: color, size: 28),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            Text(
              trend,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}