import 'package:get/get.dart';
import '../model/sitema_reservas.dart';
import '../api/local.db.service.dart';
import 'package:flutter/material.dart';

class AutosController extends GetxController {
  final db = LocalDBService();
  RxList<Auto> autosCliente = <Auto>[].obs;
  String codigoClienteActual = 'cliente_1'; // Simulación de cliente actual

  @override
  void onInit() {
    super.onInit();
    cargarAutosDelCliente();
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();
    autosCliente.value = autos.where((a) => a.clienteId == codigoClienteActual).toList();
  }

  Future<void> agregarOEditarAuto(Auto auto, {Auto? anterior}) async {
    final rawAutos = await db.getAll("autos.json");
    if (anterior != null) {
      // Editar
      final idx = rawAutos.indexWhere((a) => a['chapa'] == anterior.chapa);
      if (idx != -1) rawAutos[idx] = auto.toJson();
    } else {
      // Agregar
      rawAutos.add(auto.toJson());
    }
    await db.saveAll("autos.json", rawAutos);
    await cargarAutosDelCliente();
    Get.back();
  }

  Future<void> eliminarAuto(Auto auto) async {
    final rawAutos = await db.getAll("autos.json");
    rawAutos.removeWhere((a) => a['chapa'] == auto.chapa);
    await db.saveAll("autos.json", rawAutos);
    await cargarAutosDelCliente();
  }

  void mostrarDialogoAuto(BuildContext context, {Auto? auto}) {
    final _chapa = TextEditingController(text: auto?.chapa ?? '');
    final _marca = TextEditingController(text: auto?.marca ?? '');
    final _modelo = TextEditingController(text: auto?.modelo ?? '');
    final _chasis = TextEditingController(text: auto?.chasis ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(auto == null ? 'Agregar Auto' : 'Editar Auto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _chapa,
                decoration: const InputDecoration(labelText: 'Chapa'),
              ),
              TextField(
                controller: _marca,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: _modelo,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              TextField(
                controller: _chasis,
                decoration: const InputDecoration(labelText: 'Chasis'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_chapa.text.isEmpty || _marca.text.isEmpty || _modelo.text.isEmpty || _chasis.text.isEmpty) return;
              final nuevoAuto = Auto(
                chapa: _chapa.text,
                marca: _marca.text,
                modelo: _modelo.text,
                chasis: _chasis.text,
                clienteId: codigoClienteActual,
              );
              agregarOEditarAuto(nuevoAuto, anterior: auto);
            },
            child: Text(auto == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );
  }
} 