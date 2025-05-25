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
}
