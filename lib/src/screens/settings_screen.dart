import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool isScanning;
  final ValueChanged<bool> onScanToggled;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.isScanning,
    required this.onScanToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _SectionHeader(title: 'Preferences'),
          SwitchListTile(
            title: const Text('Dark Theme'),
            subtitle: const Text('Toggle global application theme'),
            value: isDarkMode,
            onChanged: onThemeChanged,
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Real-time Scanning'),
            subtitle: Text(isScanning
                ? 'Actively monitoring — new results incoming'
                : 'Enable background port monitoring'),
            value: isScanning,
            onChanged: onScanToggled,
            secondary: const Icon(Icons.radar),
          ),
          const Divider(height: 32),
          const _SectionHeader(title: 'Account & Workspace'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Developer Profile'),
            subtitle: const Text('Manage credentials and SSH keys'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Cloud Sync'),
            subtitle: const Text('Last synced: 2 mins ago'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 32),
          const _SectionHeader(title: 'Danger Zone'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear Local Cache', style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
