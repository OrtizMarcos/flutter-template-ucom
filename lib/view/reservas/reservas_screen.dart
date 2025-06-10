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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Reservar lugar"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            // Sección de Auto
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: _buildSelectionCard(
                context,
                icon: Icons.directions_car,
                title: "Seleccionar Auto",
                child: DropdownButtonFormField<Auto>(
                  isExpanded: true,
                  value: controller.autoSeleccionado.value,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text("Seleccionar auto"),
                  onChanged: (auto) {
                    controller.autoSeleccionado.value = auto;
                  },
                  items: controller.autosCliente.map((a) {
                    final nombre = "${a.chapa} - ${a.marca} ${a.modelo}";
                    return DropdownMenuItem(value: a, child: Text(nombre));
                  }).toList(),
                ),
              ),
            ),

            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Sección de Horarios
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.access_time,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Seleccionar Horario",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
                                // Botones principales
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (time == null) return;
                                          
                                          final now = DateTime.now();
                                          controller.horarioInicio.value = DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                            time.hour,
                                            time.minute,
                                          );
                                        },
                                        icon: const Icon(Icons.access_time),
                                        label: const Text("Hora Hoy"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(const Duration(days: 30)),
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
                                        icon: const Icon(Icons.calendar_today),
                                        label: const Text("Fecha y Hora"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                if (controller.horarioInicio.value != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Inicio",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioInicio.value!)} ${TimeOfDay.fromDateTime(controller.horarioInicio.value!).format(context)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Seleccionar duración"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: List.generate(9, (index) {
                                                    final horas = index + 1;
                                                    return ListTile(
                                                      title: Text("$horas ${horas == 1 ? 'hora' : 'horas'}"),
                                                      onTap: () {
                                                        controller.duracionSeleccionada.value = horas;
                                                        controller.horarioSalida.value = controller.horarioInicio.value!.add(
                                                          Duration(hours: horas)
                                                        );
                                                        Get.back();
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.schedule),
                                          label: const Text("Seleccionar duración"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sección de Piso y Lugares
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.layers,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Seleccionar Piso y Lugar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSelectionCard(
                            context,
                            icon: Icons.layers,
                            title: "Piso",
                            child: Obx(() => DropdownButtonFormField<Piso>(
                              isExpanded: true,
                              value: controller.pisoSeleccionado.value,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              hint: const Text("Seleccionar piso"),
                              onChanged: (p) {
                                if (p != null) {
                                  controller.seleccionarPiso(p);
                                }
                              },
                              items: controller.pisos.map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.descripcion),
                              )).toList(),
                            )),
                          ),
                          const SizedBox(height: 16),
                          Obx(() {
                            final lugaresDelPiso = controller.lugaresDisponibles
                                .where((l) => l.codigoPiso == controller.pisoSeleccionado.value?.codigo)
                                .toList();
                            
                            if (lugaresDelPiso.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("Selecciona un piso para ver los lugares disponibles"),
                                ),
                              );
                            }

                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 5,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: lugaresDelPiso.map((lugar) {
                                final seleccionado = lugar == controller.lugarSeleccionado.value;
                                final isReservado = lugar.estado == "RESERVADO";

                                return GestureDetector(
                                  onTap: lugar.estado == "DISPONIBLE"
                                      ? () => controller.lugarSeleccionado.value = lugar
                                      : null,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isReservado
                                          ? Colors.red.shade100
                                          : seleccionado
                                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                                              : Colors.white,
                                      border: Border.all(
                                        color: isReservado
                                            ? Colors.red.shade300
                                            : seleccionado
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey.shade300,
                                        width: seleccionado ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isReservado
                                                  ? Colors.red
                                                  : seleccionado
                                                      ? Theme.of(context).primaryColor
                                                      : Colors.grey)
                                              .withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          lugar.codigoLugar,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isReservado
                                                ? Colors.red.shade700
                                                : seleccionado
                                                    ? Theme.of(context).primaryColor
                                                    : Colors.black87,
                                          ),
                                        ),
                                        if (isReservado) ...[
                                          const SizedBox(height: 4),
                                          Icon(
                                            Icons.lock,
                                            size: 14,
                                            color: Colors.red.shade400
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Botón de Reservar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() {
                    final inicio = controller.horarioInicio.value;
                    final salida = controller.horarioSalida.value;
                    final piso = controller.pisoSeleccionado.value;
                    final lugar = controller.lugarSeleccionado.value;
                    final auto = controller.autoSeleccionado.value;

                    final todosLosCamposCompletos = inicio != null && 
                        salida != null && 
                        piso != null && 
                        lugar != null && 
                        auto != null;

                    return Column(
                      children: [
                        if (todosLosCamposCompletos) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Monto a pagar",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₲${UtilesApp.formatearGuaranies((salida.difference(inicio).inMinutes / 60 * 10000).round())}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${(salida.difference(inicio).inMinutes / 60).toStringAsFixed(1)} horas",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.grey[800],
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  controller.resetearCampos();
                                  Get.snackbar(
                                    "Cancelado",
                                    "Se han limpiado todos los datos",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.grey[200],
                                    colorText: Colors.grey[800],
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 12,
                                  );
                                },
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: todosLosCamposCompletos ? () async {
                                  final confirmada = await controller.confirmarReserva();
                                  if (confirmada) {
                                    Get.snackbar(
                                      "Reserva",
                                      "Reserva realizada con éxito",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.shade100,
                                      colorText: Colors.green.shade900,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
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
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                    );
                                  }
                                } : null,
                                child: const Text(
                                  "Reservar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSelectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildTimeInput(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value != null
                  ? "${UtilesApp.formatearFechaDdMMAaaa(value)} ${TimeOfDay.fromDateTime(value).format(context)}"
                  : "Seleccionar",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value != null ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
