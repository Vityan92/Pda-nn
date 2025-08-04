import 'package:flutter/material.dart';
import 'app_bar_content.dart';
import 'device_list.dart';
import '../add_device/add_device_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  SortOption _sortOption = SortOption.dateReceivedDesc;
  String _searchQuery = '';
  final _listKey = GlobalKey<DeviceListState>();

  void _onSortSelected(SortOption s) => setState(() => _sortOption = s);
  void _onSearchChanged(String q) => setState(() => _searchQuery = q);

  Future _add() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddDeviceScreen()),
    );
    if (ok == true) _listKey.currentState?.refreshDevices();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        toolbarHeight: 80,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: AppBarContent(
          currentSort: _sortOption,
          onSortSelected: _onSortSelected,
          onSearchChanged: _onSearchChanged,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: Colors.redAccent),
        ),
      ),
      body: DeviceList(key: _listKey, sortOption: _sortOption, searchQuery: _searchQuery),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }
}
