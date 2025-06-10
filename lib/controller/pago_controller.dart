import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:get/get.dart';

class PagoController extends GetxController {
  final db = LocalDBService();
  RxList<Reserva> reservasPendientes = <Reserva>[].obs;
  Rx<Reserva?> reservaSeleccionada = Rx<Reserva?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarReservasPendientes();
  }

  Future<void> cargarReservasPendientes() async {
    final data = await db.getAll("reservas.json");
    final reservas = data.map((json) => Reserva.fromJson(json)).toList();
    reservasPendientes.value =
        reservas.where((r) => r.estadoReserva == "PENDIENTE").toList();
  }

  Future<bool> realizarPago(Reserva reserva) async {
    try {
      // Crear nuevo pago
      final nuevoPago = Pago(
        codigoPago: "PAG-${DateTime.now().millisecondsSinceEpoch}",
        codigoReservaAsociada: reserva.codigoReserva,
        montoPagado: reserva.monto,
        fechaPago: DateTime.now(),
      );

      // Guardar el pago
      final pagos = await db.getAll("pagos.json");
      pagos.add(nuevoPago.toJson());
      await db.saveAll("pagos.json", pagos);

      // Actualizar estado de la reserva
      final reservas = await db.getAll("reservas.json");
      final index = reservas
          .indexWhere((r) => r['codigoReserva'] == reserva.codigoReserva);
      if (index != -1) {
        reservas[index]['estadoReserva'] = "PAGADO";
        await db.saveAll("reservas.json", reservas);
      }

      // Actualizar lista de reservas pendientes
      await cargarReservasPendientes();

      // Actualizar el HomeController
      final homeController = Get.find<HomeController>();
      await homeController.cargarReservasActivas();
      await homeController.cargarPagosPrevios();

      return true;
    } catch (e) {
      print("Error al realizar el pago: $e");
      return false;
    }
  }

  Future<void> eliminarReserva(Reserva reserva) async {
    try {
      // Eliminar la reserva de la base de datos
      final reservas = await db.getAll("reservas.json");
      reservas.removeWhere((r) => r['codigoReserva'] == reserva.codigoReserva);
      await db.saveAll("reservas.json", reservas);

      // Liberar SOLO el lugar asociado a la reserva
      final lugares = await db.getAll("lugares.json");
      for (var lugar in lugares) {
        if (lugar['codigoLugar'] == reserva.codigoLugar) {
          lugar['estado'] = 'DISPONIBLE';
          break;
        }
      }
      await db.saveAll("lugares.json", lugares);

      // Actualizar la lista local
      await cargarReservasPendientes();

      // Actualizar el HomeController
      final homeController = Get.find<HomeController>();
      await homeController.cargarReservasActivas();
    } catch (e) {
      print("Error al eliminar reserva: $e");
    }
  }
}
