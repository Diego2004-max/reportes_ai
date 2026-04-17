import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/location_service.dart';
import '../../../../theme/colors.dart';
import '../../../../shared/widgets/app_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();

  static const LatLng _initialPosition = LatLng(1.2136, -77.2811); // Pasto

  bool _isLoadingLocation = false;
  bool _locationEnabled = false;

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('reporte_1'),
      position: LatLng(1.2145, -77.2788),
      infoWindow: InfoWindow(
        title: 'Fuga de agua',
        snippet: 'Pendiente',
      ),
    ),
    const Marker(
      markerId: MarkerId('reporte_2'),
      position: LatLng(1.2117, -77.2830),
      infoWindow: InfoWindow(
        title: 'Bache en avenida',
        snippet: 'En Proceso',
      ),
    ),
    const Marker(
      markerId: MarkerId('reporte_3'),
      position: LatLng(1.2160, -77.2805),
      infoWindow: InfoWindow(
        title: 'Luminaria dañada',
        snippet: 'Resuelto',
      ),
    ),
  };

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _goToCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();

      final currentLatLng = LatLng(position.latitude, position.longitude);

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLatLng,
            zoom: 16,
          ),
        ),
      );

      setState(() {
        _locationEnabled = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo obtener la ubicación: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              myLocationEnabled: _locationEnabled,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),

          Positioned(
            top: topInset + AppSpacing.md,
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mapa de reportes',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Mostrando incidentes cercanos',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
                    icon: _isLoadingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.my_location_rounded,
                            color: AppColors.textSecondary,
                          ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: AppSpacing.screenH,
            right: AppSpacing.screenH,
            bottom: 110,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      'Reportes cerca de ti',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  _NearbyReportItem(
                    title: 'Fuga de agua en Calle 5',
                    distance: 'A 200m',
                    status: 'Pendiente',
                    statusColor: AppColors.warning,
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          const LatLng(1.2145, -77.2788),
                          17,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _NearbyReportItem(
                    title: 'Bache en Avenida Principal',
                    distance: 'A 450m',
                    status: 'En Proceso',
                    statusColor: AppColors.primary,
                    onTap: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          const LatLng(1.2117, -77.2830),
                          17,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyReportItem extends StatelessWidget {
  const _NearbyReportItem({
    required this.title,
    required this.distance,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  final String title;
  final String distance;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    distance,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}