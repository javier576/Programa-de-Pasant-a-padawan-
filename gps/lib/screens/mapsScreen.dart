import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  static const platform = MethodChannel(
    'com.example.mapa_ubicacion_app/location',
  );

  Key _mapKey = UniqueKey();

  LatLng? _currentPosition;

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoading && _currentPosition != null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod(
        'getCurrentLocation',
      );

      final double latitude = result['latitude'];
      final double longitude = result['longitude'];

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(latitude, longitude);
          _isLoading = false;
          _mapKey = UniqueKey();
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al obtener la ubicación: ${e.message}";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Ha ocurrido un error inesperado: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ubicación en el Mapa'),
        backgroundColor: Colors.lightBlue,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Refrescar Ubicación',
        backgroundColor: Colors.teal,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _currentPosition == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Obteniendo ubicación..."),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    final LatLng mapCenter =
        _currentPosition ?? const LatLng(13.8058, -89.1783);

    return FlutterMap(
      key: _mapKey,
      options: MapOptions(initialCenter: mapCenter, initialZoom: 15.0),
      children: [
        // La capa base del mapa
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        if (_currentPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _currentPosition!,
                child: const Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 40.0),
                    Text(
                      "Tú",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
