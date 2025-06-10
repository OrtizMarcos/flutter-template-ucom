// ignore_for_file: deprecated_member_use

import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<TransactionModel> transactionList = List<TransactionModel>.empty().obs;
  RxBool isWeek = true.obs;
  RxBool isMonth = false.obs;
  RxBool isYear = false.obs;
  RxBool isAdd = false.obs;
  RxList<Pago> pagosPrevios = <Pago>[].obs;
  RxList<Reserva> reservasActivas = <Reserva>[].obs;
  RxString filtroPagos = 'DIA'.obs;
  RxString filtroReservas = 'TODOS'.obs;

  customInit() async {
    await cargarPagosPrevios();
    await cargarReservasActivas();
    isWeek.value = true;
    isMonth.value = false;
    isYear.value = false;
  }

  Future<void> cargarPagosPrevios() async {
    final db = LocalDBService();
    final data = await db.getAll("pagos.json");
    pagosPrevios.value = data.map((json) => Pago.fromJson(json)).toList();
  }

  Future<void> cargarReservasActivas() async {
    final db = LocalDBService();
    final data = await db.getAll("reservas.json");
    reservasActivas.value = data.map((json) => Reserva.fromJson(json)).toList();
  }

  List<Pago> get pagosFiltrados {
    final ahora = DateTime.now();
    if (filtroPagos.value == 'DIA') {
      return pagosPrevios.where((p) => p.fechaPago.year == ahora.year && p.fechaPago.month == ahora.month && p.fechaPago.day == ahora.day).toList();
    } else if (filtroPagos.value == 'SEMANA') {
      final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));
      return pagosPrevios.where((p) => p.fechaPago.isAfter(inicioSemana.subtract(const Duration(seconds: 1))) && p.fechaPago.isBefore(finSemana.add(const Duration(days: 1)))).toList();
    } else if (filtroPagos.value == 'MES') {
      return pagosPrevios.where((p) => p.fechaPago.year == ahora.year && p.fechaPago.month == ahora.month).toList();
    }
    return pagosPrevios;
  }

  List<Reserva> get reservasFiltradas {
    final ahora = DateTime.now();
    final pendientes = reservasActivas.where((r) => r.estadoReserva == 'PENDIENTE').toList();
    if (filtroReservas.value == 'DIA') {
      return pendientes.where((r) => r.horarioInicio.year == ahora.year && r.horarioInicio.month == ahora.month && r.horarioInicio.day == ahora.day).toList();
    } else if (filtroReservas.value == 'SEMANA') {
      final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));
      return pendientes.where((r) => r.horarioInicio.isAfter(inicioSemana.subtract(const Duration(seconds: 1))) && r.horarioInicio.isBefore(finSemana.add(const Duration(days: 1)))).toList();
    } else if (filtroReservas.value == 'MES') {
      return pendientes.where((r) => r.horarioInicio.year == ahora.year && r.horarioInicio.month == ahora.month).toList();
    } else if (filtroReservas.value == 'AÑO') {
      return pendientes.where((r) => r.horarioInicio.year == ahora.year).toList();
    }
    // 'TODOS' u otro valor muestra todos los pendientes
    return pendientes;
  }
}
