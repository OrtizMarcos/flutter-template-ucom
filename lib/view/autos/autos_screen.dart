import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/autos_controller.dart';
import '../../model/sitema_reservas.dart';
import '../../theme/app_theme.dart';
import '../../utils/hex_color.dart';

class AutosScreen extends StatelessWidget {
  final controller = Get.put(AutosController());

  AutosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.isLightTheme == false
          ? const Color(0xff211F32)
          : const Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppTheme.isLightTheme == false
            ? const Color(0xff211F32)
            : const Color(0xffFFFFFF),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.isLightTheme == false
                  ? const Color(0xff211F32)
                  : const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.isLightTheme == false
                  ? Colors.white
                  : const Color(0xff000000),
            ),
          ),
        ),
        title: Text(
          "Mis Autos",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: HexColor(AppTheme.primaryColorString!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(() => Text(
                  "Total: ${controller.totalAutos.value}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: HexColor(AppTheme.primaryColorString!),
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ),
            ),
          ),
        ],
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