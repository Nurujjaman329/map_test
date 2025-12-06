import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationSearchScreen extends StatelessWidget {
  final MapController controller = Get.find<MapController>();
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() {
          String title = controller.currentSearchType.value == 'origin'
              ? 'Select Starting Point'
              : 'Select Destination';
          return Text(title);
        }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade600),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                suffixIcon: searchQuery.value.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    searchQuery.value = '';
                    controller.clearSearchResults();
                  },
                  icon: Icon(Icons.clear),
                )
                    : null,
              ),
              onChanged: (value) {
                searchQuery.value = value;
                controller.searchPlaces(value);
              },
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.searchResults.isEmpty && searchQuery.value.isEmpty) {
                return _buildRecentPlaces();
              } else if (controller.searchResults.isEmpty && searchQuery.value.isNotEmpty) {
                return Center(
                  child: Text('No results found'),
                );
              } else {
                return _buildSearchResults();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPlaces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Recent Places',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.location_on_outlined, color: Colors.blue.shade600),
                title: Text('Current Location'),
                subtitle: Text('Use your current position'),
                onTap: () {
                  // In a real app, get actual current location
                  _selectLocation('Current Location', LatLng(23.8103, 90.4125));
                },
              ),
              Divider(height: 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        var place = controller.searchResults[index];

        return ListTile(
          leading: Icon(Icons.location_on_outlined, color: Colors.blue.shade600),
          title: Text(
            place['description'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: place['structured_formatting'] != null
              ? Text(
            place['structured_formatting']['secondary_text'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : null,
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );

            try {
              LatLng? latLng = await controller.getLatLng(place['description']);
              Get.back(); // Close loading dialog

              if (latLng != null) {
                _selectLocation(place['description'], latLng);
              }
            } catch (e) {
              Get.back(); // Close loading dialog
              Get.snackbar('Error', 'Failed to get location coordinates');
            }
          },
        );
      },
    );
  }

  void _selectLocation(String address, LatLng latLng) {
    if (controller.currentSearchType.value == 'origin') {
      controller.setOrigin(address, latLng);
    } else {
      controller.setDestination(address, latLng);
    }

    // Navigate back to map screen
    Get.back();
  }
}