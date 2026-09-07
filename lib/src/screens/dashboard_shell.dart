import 'package:flutter/material.dart';
import 'defense_dashboard_screen.dart';
import 'netguard_logs_screen.dart';
import 'settings_screen.dart';

class DashboardShell extends StatefulWidget {
  // 1. Accept the properties from main.dart
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const DashboardShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  // 2. Change this from a static variable to a 'getter' so it can access 'widget.isDarkMode'
  List<Widget> get _pages => [
        const DefenseDashboardScreen(),
        const NetGuardLogsScreen(),
        SettingsScreen(
          // 3. Pass the properties down to the Settings screen
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  title: const Text('PreFlight'),
                ),
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
                          Navigator.pop(context);
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
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        selected: _selectedIndex == 2,
                        onTap: () {
                          setState(() => _selectedIndex = 2);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
          body: Row(
            children: [
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
              if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
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