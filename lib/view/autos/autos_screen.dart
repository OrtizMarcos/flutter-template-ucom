import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/autos_controller.dart';
import '../../model/sitema_reservas.dart';

class AutosScreen extends StatelessWidget {
  final controller = Get.put(AutosController());

  AutosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Autos'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.autosCliente.isEmpty) {
          return const Center(child: Text('No tienes autos registrados.'));
        }
        return ListView.builder(
          itemCount: controller.autosCliente.length,
          itemBuilder: (context, index) {
            final auto = controller.autosCliente[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.directions_car, size: 32),
                title: Text('${auto.marca} ${auto.modelo}'),
                subtitle: Text('Chapa: ${auto.chapa}\nChasis: ${auto.chasis}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => controller.mostrarDialogoAuto(context, auto: auto),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.eliminarAuto(auto),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.mostrarDialogoAuto(context),
        child: const Icon(Icons.add),
        tooltip: 'Agregar auto',
      ),
    );
  }
} 