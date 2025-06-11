import 'package:finpay/controller/pago_controller.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagoScreen extends StatelessWidget {
  final controller = Get.put(PagoController());

  PagoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagar Reservas"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.reservasPendientes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No hay reservas pendientes",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.reservasPendientes.length,
            itemBuilder: (context, index) {
              final reserva = controller.reservasPendientes[index];
              return Dismissible(
                key: Key(reserva.codigoReserva),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Icon(Icons.payment, color: Colors.white, size: 32),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Icon(Icons.delete, color: Colors.white, size: 32),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Eliminar
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Eliminar reserva"),
                        content: const Text("¿Estás seguro de que deseas eliminar esta reserva?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Aceptar"),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      // Eliminar la reserva
                      await controller.eliminarReserva(reserva);
                      return true;
                    }
                    return false;
                  } else if (direction == DismissDirection.startToEnd) {
                    // Pagar
                    final confirmado = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text("Confirmar pago"),
                        content: Text(
                          "¿Desea confirmar el pago de ₲${UtilesApp.formatearGuaranies(reserva.monto)}?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text("Confirmar"),
                          ),
                        ],
                      ),
                    );
                    if (confirmado == true) {
                      final exitoso = await controller.realizarPago(reserva);
                      if (exitoso) {
                        Get.snackbar(
                          "Éxito",
                          "Pago realizado correctamente",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.green.shade900,
                        );
                        return true;
                      } else {
                        Get.snackbar(
                          "Error",
                          "No se pudo realizar el pago",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade100,
                          colorText: Colors.red.shade900,
                        );
                        return false;
                      }
                    }
                    return false;
                  }
                  return false;
                },
                child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reserva #${reserva.codigoReserva}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "PENDIENTE",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "Auto: ${reserva.chapaAuto}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "Inicio: ${UtilesApp.formatearFechaDdMMAaaa(reserva.horarioInicio)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer_off, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "Fin: ${UtilesApp.formatearFechaDdMMAaaa(reserva.horarioSalida)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Monto a pagar:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            "₲${UtilesApp.formatearGuaranies(reserva.monto)}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                                  ),
                                ],
                              ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
