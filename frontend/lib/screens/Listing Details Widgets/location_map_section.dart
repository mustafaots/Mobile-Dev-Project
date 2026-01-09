import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapSection extends StatelessWidget {
  final Location? location;

  const LocationMapSection({
    super.key,
    required this.location,
  });

  void _showFullScreenMap(BuildContext context) {
    final mapCenter = LatLng(location!.latitude, location!.longitude);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.field_location),
            backgroundColor: AppTheme.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.easyvacation.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: mapCenter,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final loc = AppLocalizations.of(context)!;

    // Don't show map if no location or invalid coordinates
    if (location == null ||
        (location!.latitude == 0 && location!.longitude == 0)) {
      return const SizedBox.shrink();
    }

    final mapCenter = LatLng(location!.latitude, location!.longitude);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.field_location,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          // Address text
          if (location!.address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: textColor.withOpacity(0.7)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${location!.address}, ${location!.city}, ${location!.wilaya}',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Map container - tappable
          GestureDetector(
            onTap: () => _showFullScreenMap(context),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: IgnorePointer(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: mapCenter,
                          initialZoom: 14.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                            userAgentPackageName: 'com.easyvacation.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: mapCenter,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Tap hint overlay
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.zoom_out_map, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          loc.select_location,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
