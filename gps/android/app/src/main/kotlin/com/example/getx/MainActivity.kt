package com.example.getx

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.location.Location
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices

class MainActivity: FlutterActivity() {
    // 1. El nombre del canal. DEBE SER IDÉNTICO al de tu maps_screen.dart.
    // Aunque tu paquete es 'com.example.getx', el canal puede tener cualquier nombre,
    // siempre que sea el mismo en ambos lados.
    private val CHANNEL = "com.example.mapa_ubicacion_app/location"
    
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Inicializa el cliente de ubicación de Google.
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // 2. Configura el MethodChannel para escuchar llamadas desde Flutter.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Revisa si el método llamado es 'getCurrentLocation'.
            if (call.method == "getCurrentLocation") {
                getCurrentLocation(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCurrentLocation(result: MethodChannel.Result) {
        // 3. Verifica si la app tiene los permisos de ubicación.
        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            
            // Si no tiene permisos, devuelve un error claro a Flutter.
            result.error("PERMISSION_DENIED", "Se denegaron los permisos de ubicación.", null)
            return
        }

        // 4. Intenta obtener la última ubicación conocida del dispositivo.
        fusedLocationClient.lastLocation
            .addOnSuccessListener { location: Location? ->
                if (location != null) {
                    // Si se encuentra la ubicación, se empaqueta en un mapa.
                    val locationMap = mapOf(
                        "latitude" to location.latitude,
                        "longitude" to location.longitude
                    )
                    // 5. ¡ÉXITO! Se envía la ubicación de vuelta a Flutter.
                    result.success(locationMap)
                } else {
                    // Si la ubicación es nula, se envía un error.
                    result.error("UNAVAILABLE", "La ubicación no está disponible. Asegúrate de que el GPS esté activado.", null)
                }
            }
            .addOnFailureListener { e ->
                // Si ocurre una excepción, se envía un error.
                result.error("ERROR", "Falló al obtener la ubicación: ${e.message}", null)
            }
    }
}
