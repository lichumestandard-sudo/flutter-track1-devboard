import 'package:flutter/material.dart';
import 'defense_dashboard_screen.dart';
import 'netguard_logs_screen.dart';
import 'settings_screen.dart'; 

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  // The different views for your dashboard
  final List<Widget> _pages = [
    const DefenseDashboardScreen(), 
    const NetGuardLogsScreen(), // <-- Updated to load the new NetGuard table
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Set the breakpoint for desktop vs mobile view (800 pixels is standard)
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          // Only show the AppBar with a hamburger menu on narrow screens
          appBar: isDesktop
              ? null
              : AppBar(
                  title: const Text('PreFlight'),
                ),
          
          // Only attach the Drawer on narrow screens
          drawer: isDesktop
              ? null
              : Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.deepPurple),
                        child: Text(
                          'PreFlight Menu',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.shield),
                        title: const Text('Defense Dashboard'),
                        selected: _selectedIndex == 0,
                        onTap: () {
                          setState(() => _selectedIndex = 0);
                          Navigator.pop(context); // Close drawer after selection
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.network_check),
                        title: const Text('NetGuard Tools'),
                        selected: _selectedIndex == 1,
                        onTap: () {
                          setState(() => _selectedIndex = 1);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
          
          // The main layout for the screen
          body: Row(
            children: [
              // Only show the NavigationRail on wide screens
              if (isDesktop)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.shield_outlined),
                      selectedIcon: Icon(Icons.shield),
                      label: Text('Defense'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.network_check_outlined),
                      selectedIcon: Icon(Icons.network_check),
                      label: Text('NetGuard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                
              // A subtle divider to separate the rail from the main content
              if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
              
              // The Expanded widget ensures the main content takes up all remaining screen space
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}