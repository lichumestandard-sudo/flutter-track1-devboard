import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detects if the screen is wide enough for a desktop layout
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: isDesktop ? null : AppBar(title: const Text('PreFlight')),
      drawer: isDesktop ? null : const AppSidebar(),
      body: Row(
        children: [
          if (isDesktop) const AppSidebar(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Defense Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  const Text('Ready to prep for your code review?'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'PREFLIGHT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.folder_special, color: Colors.grey),
              title: const Text('Active Projects'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.rule, color: Colors.grey),
              title: const Text('Edge Cases'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.grey),
              title: const Text('Architecture Flashcards'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
