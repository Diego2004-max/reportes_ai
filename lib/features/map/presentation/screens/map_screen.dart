import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:reportes_ai/app/theme/app_colors.dart';
import 'package:reportes_ai/core/services/location_service.dart';
import 'package:reportes_ai/shared/widgets/empty_state.dart';
import 'package:reportes_ai/state/report_provider.dart';
import 'package:reportes_ai/data/models/report_model.dart';
import 'package:reportes_ai/features/reports/presentation/screens/create_report_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();

  static const LatLng _initialPosition = LatLng(1.2136, -77.2811);

  bool _isLoadingLocation = false;
  bool _locationEnabled = false;
  String _searchQuery = '';

  ReportModel? _selectedReport;

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return 'Hace ${diff.inDays} días';
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final position = await _locationService.getCurrentLocation();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 16),
        ),
      );

      setState(() => _locationEnabled = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo obtener la ubicación: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  Color _getCategoryColor(String status) {
    // Basic mapping, can be expanded
    if (status.toLowerCase().contains('obra')) return const Color(0xFFEF4444); // Error
    if (status.toLowerCase().contains('accidente')) return const Color(0xFFEF9F27); // Warning
    return const Color(0xFF1D9E75); // Success/Green
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(allReportsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (reports) {
          final filtered = _searchQuery.isEmpty
              ? reports
              : reports.where((r) {
                  final q = _searchQuery;
                  return r.title.toLowerCase().contains(q) ||
                      r.category.toLowerCase().contains(q) ||
                      (r.locationLabel ?? '').toLowerCase().contains(q);
                }).toList();

          final Set<Marker> markers = filtered
              .where((r) => r.latitude != null && r.longitude != null)
              .map(
                (report) => Marker(
                  markerId: MarkerId(report.id),
                  position: LatLng(report.latitude!, report.longitude!),
                  onTap: () {
                    setState(() {
                      _selectedReport = report;
                    });
                  },
                ),
              )
              .toSet();

          return Stack(
            children: [
              // 1. Map Layer
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (_selectedReport != null) {
                       setState(() => _selectedReport = null);
                    }
                  },
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: _initialPosition,
                      zoom: 14,
                    ),
                    markers: markers,
                    zoomControlsEnabled: false,
                    myLocationEnabled: _locationEnabled,
                    myLocationButtonEnabled: false,
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
              
              // 2. Top Search Bar & Filters Area
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest.withAlpha(230),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow, // shadow-[0_8px_30px_rgba(0,0,0,0.04)]
                                  blurRadius: 40,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (v) => setState(
                                        () => _searchQuery = v.toLowerCase()),
                                    decoration: InputDecoration(
                                      hintText: 'Buscar por título, categoría...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textSecondary.withAlpha(180),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Material(
                          color: AppColors.surfaceContainerLowest.withAlpha(230),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: _goToCurrentLocation,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 40,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: _isLoadingLocation
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.tune_rounded, // or my_location_rounded
                                      color: AppColors.textSecondary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. FAB (Floating Action Button)
              Positioned(
                 bottom: _selectedReport != null ? 160 : 32,
                 right: 24,
                 child: FloatingActionButton(
                   onPressed: () => Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (_) => const CreateReportScreen()),
                   ),
                   backgroundColor: AppColors.primary,
                   foregroundColor: AppColors.onPrimary,
                   elevation: 4,
                   shape: const CircleBorder(),
                   child: const Icon(Icons.add, size: 28),
                 ),
              ),

              // 4. Bottom Sheet (Peek State for selected report)
              if (_selectedReport != null)
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest.withAlpha(240),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow, // shadow-[0_-8px_30px_rgba(0,0,0,0.06)]
                              blurRadius: 40,
                              offset: const Offset(0, -10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Handle
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedReport!.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedReport!.locationLabel ?? 'Buscando dirección...',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorLight.withAlpha(150),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                                      const SizedBox(width: 4),
                                      Text(
                                        _selectedReport!.category,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBETF0YKPNKaMuHSg03JLMLhSwpiOYaiUyxBsdROUBcQMTThaNFxDAJ-QgHQxTGe4wPh9yRZL3_FqiI8nE48wybqXyPmWa1KmOyLleV1g59x5ZpzUjahUKTKkMBIs8wbXmiI4Deys0vt0JtkadwG2_9pmNWFr0CgheBM4Rf3T_PFetLD5wThNk2TUPNF0tt7X7O3Gjlw0LvFZfltr3Amla8N9KhZVGj09ePH1umytg5brOTRStEktWFBRihwU3AIoQ22CHb4nXzgkw'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Usuario ${_selectedReport!.userId.substring(0, 8)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      _timeAgo(_selectedReport!.createdAt),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}