// lib/views/leaflet_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gps/providers/TileCacheManagerProvider.dart';
import 'package:flutter_gps/providers/cached_tile_provider.dart';
import 'package:flutter_gps/views/app_settings.dart';
import 'package:flutter_gps/views/map_support.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../providers/geo_location_cache_provider.dart';

class LeafletView extends StatelessWidget {
  const LeafletView({super.key});

  // if used here, we are no longer stateless
  // final Logger _logger = Logger('LeafletView');

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;
    final cacheManager = Provider.of<TileCacheManagerProvider>(context).cacheManager;
    final geoLocationCache = Provider.of<GeoLocationCacheProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaflet Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: geoLocationCache.getCurrentAsLatLgn(),
          initialZoom: (settings.zoomOnAccuracy) ? zoomForCurrent(geoLocationCache.latest) : 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            // subdomains: ['a', 'b', 'c'],
            tileProvider: CachedTileProvider(cacheManager: cacheManager),
            errorTileCallback: (tile, error, stackTrace) => Center(child: Text('Failed to load map tiles ${error}.'))
          ),
          MarkerLayer(
            markers: buildMarkers(geoLocationCache),
          ),
        ],
      ),
    );
  }
}
