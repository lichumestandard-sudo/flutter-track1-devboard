import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'defense_dashboard_screen.dart';
import 'netguard_logs_screen.dart';
import 'settings_screen.dart';

class DashboardShell extends StatefulWidget {
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
  static const _logsKey = 'netguard_logs';
  static const _scanningKey = 'is_scanning';

  int _selectedIndex = 0;
  bool _isScanning = false;
  bool _isLoaded = false;
  Timer? _scanTimer;
  final Random _random = Random();

  List<Map<String, String>> _logs = [
    {'time': '10:45:01 AM', 'ip': '192.168.1.10', 'port': '22', 'service': 'SSH', 'status': 'OPEN'},
    {'time': '10:45:03 AM', 'ip': '192.168.1.10', 'port': '80', 'service': 'HTTP', 'status': 'OPEN'},
    {'time': '10:45:05 AM', 'ip': '192.168.1.10', 'port': '443', 'service': 'HTTPS', 'status': 'OPEN'},
    {'time': '10:46:12 AM', 'ip': '10.0.0.5', 'port': '21', 'service': 'FTP', 'status': 'CLOSED'},
    {'time': '10:46:15 AM', 'ip': '10.0.0.5', 'port': '3306', 'service': 'MySQL', 'status': 'FILTERED'},
  ];

  static const List<Map<String, String>> _fakePool = [
    {'ip': '192.168.1.14', 'port': '8080', 'service': 'HTTP-Alt'},
    {'ip': '192.168.1.22', 'port': '3389', 'service': 'RDP'},
    {'ip': '10.0.0.8', 'port': '5432', 'service': 'PostgreSQL'},
    {'ip': '10.0.0.12', 'port': '25', 'service': 'SMTP'},
    {'ip': '192.168.1.30', 'port': '53', 'service': 'DNS'},
  ];
  static const List<String> _statuses = ['OPEN', 'CLOSED', 'FILTERED'];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogs = prefs.getString(_logsKey);
    final savedScanning = prefs.getBool(_scanningKey) ?? false;

    if (savedLogs != null) {
      final decoded = jsonDecode(savedLogs) as List;
      _logs = decoded.map((e) => Map<String, String>.from(e as Map)).toList();
    }

    setState(() {
      _isScanning = savedScanning;
      _isLoaded = true;
    });

    if (_isScanning) {
      _startScanTimer();
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_logsKey, jsonEncode(_logs));
  }

  Future<void> _saveScanningState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scanningKey, _isScanning);
  }

  void _startScanTimer() {
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _addFakeLogEntry();
    });
  }

  void _toggleScanning(bool value) {
    setState(() {
      _isScanning = value;
    });
    _saveScanningState();

    if (value) {
      _startScanTimer();
    } else {
      _scanTimer?.cancel();
      _scanTimer = null;
    }
  }

  void _addFakeLogEntry() {
    final pick = _fakePool[_random.nextInt(_fakePool.length)];
    final status = _statuses[_random.nextInt(_statuses.length)];
    final now = TimeOfDay.now();
    final formattedTime = now.format(context);

    setState(() {
      _logs = [
        {
          'time': formattedTime,
          'ip': pick['ip']!,
          'port': pick['port']!,
          'service': pick['service']!,
          'status': status,
        },
        ..._logs,
      ];
    });
    _saveLogs();
  }

  void _clearLogs() {
    setState(() {
      _logs = [];
    });
    _saveLogs();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  List<Widget> get _pages => [
        const DefenseDashboardScreen(),
        NetGuardLogsScreen(logs: _logs),
        SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          isScanning: _isScanning,
          onScanToggled: _toggleScanning,
          onClearLogs: _clearLogs,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
