import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:finpay/controller/home_controller.dart';

class ReservaScreen extends StatelessWidget {
  final controller = Get.put(ReservaController());

  ReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservar lugar"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          return Column(
            children: [
              // Sección de Auto y Piso en una fila
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Auto
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions_car, 
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text("Auto",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return DropdownButtonFormField<Auto>(
                              isExpanded: true,
                              value: controller.autoSeleccionado.value,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                              hint: const Text("Seleccionar"),
                              onChanged: (auto) {
                                controller.autoSeleccionado.value = auto;
                              },
                              items: controller.autosCliente.map((a) {
                                final nombre = "${a.chapa} - ${a.marca} ${a.modelo}";
                                return DropdownMenuItem(value: a, child: Text(nombre));
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Piso
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.layers, 
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text("Piso",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Piso>(
                            isExpanded: true,
                            value: controller.pisoSeleccionado.value,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            hint: const Text("Seleccionar"),
                            onChanged: (p) => controller.seleccionarPiso(p!),
                            items: controller.pisos
                                .map((p) => DropdownMenuItem(
                                    value: p, child: Text(p.descripcion)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sección de Lugares
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_parking, 
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text("Lugares disponibles",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 5,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          children: controller.lugaresDisponibles
                              .where((l) =>
                                  l.codigoPiso ==
                                  controller.pisoSeleccionado.value?.codigo)
                              .map((lugar) {
                            final seleccionado =
                                lugar == controller.lugarSeleccionado.value;
                            final color = lugar.estado == "RESERVADO"
                                ? Colors.red.shade400
                                : seleccionado
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade200;

                            return GestureDetector(
                              onTap: lugar.estado == "DISPONIBLE"
                                  ? () => controller.lugarSeleccionado.value = lugar
                                  : null,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: color,
                                  border: Border.all(
                                      color: seleccionado
                                          ? Theme.of(context).primaryColor
                                          : Colors.black12,
                                      width: seleccionado ? 2 : 1),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: seleccionado ? [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ] : null,
                                ),
                                child: Text(
                                  lugar.codigoLugar,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lugar.estado == "RESERVADO"
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sección de Horarios y Duración
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, 
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text("Horarios",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(const Duration(days: 30)),
                              );
                              if (date == null) return;
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time == null) return;
                              controller.horarioInicio.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            },
                            icon: const Icon(Icons.access_time, size: 18),
                            label: Obx(() => Text(
                                  controller.horarioInicio.value == null
                                      ? "Inicio"
                                      : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioInicio.value!)} ${TimeOfDay.fromDateTime(controller.horarioInicio.value!).format(context)}",
                                )),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: controller.horarioInicio.value ??
                                    DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(const Duration(days: 30)),
                              );
                              if (date == null) return;
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time == null) return;
                              controller.horarioSalida.value = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            },
                            icon: const Icon(Icons.timer_off, size: 18),
                            label: Obx(() => Text(
                                  controller.horarioSalida.value == null
                                      ? "Salida"
                                      : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioSalida.value!)} ${TimeOfDay.fromDateTime(controller.horarioSalida.value!).format(context)}",
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Duración rápida",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        )),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: [1, 2, 4, 6, 8].map((horas) {
                        final seleccionada =
                            controller.duracionSeleccionada.value == horas;
                        return ChoiceChip(
                          label: Text("$horas h"),
                          selected: seleccionada,
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: seleccionada ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            controller.duracionSeleccionada.value = horas;
                            final inicio =
                                controller.horarioInicio.value ?? DateTime.now();
                            controller.horarioInicio.value = inicio;
                            controller.horarioSalida.value =
                                inicio.add(Duration(hours: horas));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Sección de Monto y Botón Confirmar
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final inicio = controller.horarioInicio.value;
                      final salida = controller.horarioSalida.value;

                      if (inicio == null || salida == null) return const SizedBox();

                      final minutos = salida.difference(inicio).inMinutes;
                      final horas = minutos / 60;
                      final monto = (horas * 10000).round();

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Monto:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              "₲${UtilesApp.formatearGuaranies(monto)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        final confirmada = await controller.confirmarReserva();

                        if (confirmada) {
                          Get.snackbar(
                            "Reserva",
                            "Reserva realizada con éxito",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.green.shade900,
                          );

                          await Future.delayed(const Duration(milliseconds: 2000));
                          
                          final homeController = Get.find<HomeController>();
                          await homeController.cargarReservasActivas();
                          Get.back();
                        } else {
                          Get.snackbar(
                            "Error",
                            "Verificá que todos los campos estén completos",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red.shade100,
                            colorText: Colors.red.shade900,
                          );
                        }
                      },
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
