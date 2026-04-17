import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/app/theme/app_spacing.dart';
import 'package:reportes_ai/core/services/location_service.dart';
import 'package:reportes_ai/shared/widgets/app_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();

  static const LatLng _initialPosition = LatLng(1.2136, -77.2811);

  bool _isLoadingLocation = false;
  bool _locationEnabled = false;

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('reporte_1'),
      position: LatLng(1.2145, -77.2788),
      infoWindow: InfoWindow(
        title: 'Fuga de agua',
        snippet: 'Enviado',
      ),
    ),
    const Marker(
      markerId: MarkerId('reporte_2'),
      position: LatLng(1.2117, -77.2830),
      infoWindow: InfoWindow(
        title: 'Bache en avenida',
        snippet: 'En revisión',
      ),
    ),
    const Marker(
      markerId: MarkerId('reporte_3'),
      position: LatLng(1.2160, -77.2805),
      infoWindow: InfoWindow(
        title: 'Luminaria dañada',
        snippet: 'Atendido',
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
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: Column(
              children: [
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mapa de reportes',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Vista web temporal',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: Center(
                    child: AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 56,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'El mapa interactivo estará activo en Android.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'En Chrome lo dejamos estable para que no rompa la app mientras cierras el proyecto.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  Icon(
                    Icons.location_on_rounded,
                    color: theme.colorScheme.primary,
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
                          style: theme.textTheme.bodySmall,
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
                        : const Icon(Icons.my_location_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}