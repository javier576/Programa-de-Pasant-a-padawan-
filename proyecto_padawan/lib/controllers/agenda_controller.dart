import 'package:get/get.dart';
import 'package:proyecto_padawan/models/actividad_model.dart';

class AgendaController extends GetxController {
  var listaDeActividades = <ActividadModel>[].obs;

  var fechaSeleccionada = DateTime.now().obs;

  List<ActividadModel> get actividadesDelDia {
    var listaFiltrada = listaDeActividades.where((act) {
      return act.fechaHora.year == fechaSeleccionada.value.year &&
          act.fechaHora.month == fechaSeleccionada.value.month &&
          act.fechaHora.day == fechaSeleccionada.value.day;
    }).toList();

    listaFiltrada.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
    return listaFiltrada;
  }

  void agregarActividad(ActividadModel nuevaActividad) {
    listaDeActividades.add(nuevaActividad);
  }

  void cambiarDia(int dias) {
    fechaSeleccionada.value = fechaSeleccionada.value.add(Duration(days: dias));
  }
}
