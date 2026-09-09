import 'package:flutter/material.dart';

class NetGuardLogsScreen extends StatefulWidget {
  final List<Map<String, String>> logs;

  const NetGuardLogsScreen({super.key, required this.logs});

  @override
  State<NetGuardLogsScreen> createState() => _NetGuardLogsScreenState();
}

class _NetGuardLogsScreenState extends State<NetGuardLogsScreen> {
  int? _sortColumnIndex;
  bool _isAscending = true;
  String _searchQuery = '';

  List<Map<String, String>> get _filteredLogs {
    if (_searchQuery.isEmpty) return widget.logs;

    return widget.logs.where((log) {
      final ipMatch = log['ip']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final statusMatch = log['status']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return ipMatch || statusMatch;
    }).toList();
  }

  void _sort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;

      widget.logs.sort((a, b) {
        String valA = '';
        String valB = '';

        switch (columnIndex) {
          case 0: valA = a['time']!; valB = b['time']!; break;
          case 1: valA = a['ip']!; valB = b['ip']!; break;
          case 2: valA = a['port']!; valB = b['port']!; break;
          case 3: valA = a['service']!; valB = b['service']!; break;
          case 4: valA = a['status']!; valB = b['status']!; break;
        }

        return ascending ? valA.compareTo(valB) : valB.compareTo(valA);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetGuard Port Scanner Logs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search by IP or Status (e.g., "10.0.0.5" or "OPEN")',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _isAscending,
                columns: [
                  DataColumn(label: const Text('Timestamp'), onSort: _sort),
                  DataColumn(label: const Text('Target IP'), onSort: _sort),
                  DataColumn(label: const Text('Port'), onSort: _sort),
                  DataColumn(label: const Text('Service'), onSort: _sort),
                  DataColumn(label: const Text('Status'), onSort: _sort),
                ],
                rows: _buildLogRows(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildLogRows() {
    return _filteredLogs.map((log) {
      final isOpen = log['status'] == 'OPEN';
      final isClosed = log['status'] == 'CLOSED';

      return DataRow(
        cells: [
          DataCell(Text(log['time']!)),
          DataCell(Text(log['ip']!)),
          DataCell(Text(log['port']!)),
          DataCell(Text(log['service']!)),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen
                    ? Colors.green.withOpacity(0.2)
                    : (isClosed ? Colors.red.withOpacity(0.2) : Colors.orange.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log['status']!,
                style: TextStyle(
                  color: isOpen
                      ? Colors.green
                      : (isClosed ? Colors.red : Colors.orange),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
