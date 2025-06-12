// ignore_for_file: deprecated_member_use

import 'package:card_swiper/card_swiper.dart';
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:finpay/utils/utiles.dart';
import 'package:finpay/view/home/widget/circle_card.dart';
import 'package:finpay/view/home/widget/custom_card.dart';
import 'package:finpay/view/reservas/reservas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../pagos/pagos_screen.dart';
import '../autos/autos_screen.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController;

  // Variables reactivas para controlar la expansión y filtros
  final RxBool pendientesExpandido = true.obs;
  final RxBool pagadasExpandido = false.obs;
  final RxString filtroPendientes = 'TODOS'.obs;
  final RxString filtroPagadas = 'TODOS'.obs;
  final RxString reservaSeleccionada = ''.obs;

  HomeView({Key? key, required this.homeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.isLightTheme == false
          ? const Color(0xff15141F)
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                    ),
                    Text(
                      "Good morning",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 28,
                      width: 69,
                      decoration: BoxDecoration(
                        color: const Color(0xffF6A609).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            DefaultImages.ranking,
                          ),
                          Text(
                            "Gold",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color(0xffF6A609),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        DefaultImages.avatar,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.isLightTheme == false
                              ? HexColor('#15141f')
                              : Theme.of(context).appBarTheme.backgroundColor,
                          border: Border.all(
                            color: HexColor(AppTheme.primaryColorString!)
                                .withOpacity(0.05),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              customContainer(
                                title: "USD",
                                background: AppTheme.primaryColorString,
                                textColor: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              customContainer(
                                title: "IDR",
                                background: AppTheme.isLightTheme == false
                                    ? '#211F32'
                                    : "#FFFFFF",
                                textColor: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: HexColor(AppTheme.primaryColorString!),
                            size: 20,
                          ),
                          Text(
                            "Add Currency",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: HexColor(AppTheme.primaryColorString!),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 180,
                    width: Get.width,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return SvgPicture.asset(
                          DefaultImages.debitcard,
                          fit: BoxFit.fill,
                        );
                      },
                      itemCount: 3,
                      viewportFraction: 1,
                      scale: 0.9,
                      autoplay: true,
                      itemWidth: Get.width,
                      itemHeight: 180,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => PagoScreen(),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 500));
                      },
                      child: circleCard(
                        image: DefaultImages.topup,
                        title: "Pagar",
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: circleCard(
                        image: DefaultImages.withdraw,
                        title: "Withdraw",
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => AutosScreen(),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 500));
                      },
                      child: circleCard(
                        icon: Icons.directions_car,
                        title: "Autos",
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(
                          () => ReservaScreen(),
                          binding: BindingsBuilder(() {
                            Get.delete<
                                ReservaController>(); // 🔥 elimina instancia previa

                            Get.create(() => ReservaController());
                          }),
                          transition: Transition.downToUp,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      child: circleCard(
                        image: DefaultImages.transfer,
                        title: "Reservar",
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reservas",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.isLightTheme == false
                              ? const Color(0xff211F32)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: HexColor(AppTheme.primaryColorString!)
                                .withOpacity(0.1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Obx(() {
                            final pendientes = homeController.reservasActivas.where((r) => r.estadoReserva == 'PENDIENTE').toList();
                            final pagadas = homeController.reservasActivas.where((r) => r.estadoReserva == 'PAGADO').toList();
                            return Column(
                              children: [
                                _buildExpandableReservationSection(
                                  context,
                                  title: "Reservas Pendientes",
                                  icon: Icons.pending_actions,
                                  color: const Color(0xffF6A609),
                                  count: pendientes.length,
                                  expanded: pendientesExpandido.value,
                                  onTap: () {
                                    pendientesExpandido.value = true;
                                    pagadasExpandido.value = false;
                                  },
                                  filtro: filtroPendientes.value,
                                  onFiltroChanged: (nuevo) => filtroPendientes.value = nuevo,
                                  reservas: pendientes,
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),
                                _buildExpandableReservationSection(
                                  context,
                                  title: "Reservas Pagadas",
                                  icon: Icons.check_circle,
                                  color: const Color(0xff4CAF50),
                                  count: pagadas.length,
                                  expanded: pagadasExpandido.value,
                                  onTap: () {
                                    pendientesExpandido.value = false;
                                    pagadasExpandido.value = true;
                                  },
                                  filtro: filtroPagadas.value,
                                  onFiltroChanged: (nuevo) => filtroPagadas.value = nuevo,
                                  reservas: pagadas,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpandableReservationSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required bool expanded,
    required VoidCallback onTap,
    required String filtro,
    required ValueChanged<String> onFiltroChanged,
    required List reservas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.filter_list),
                label: Text(_filtroLabel(filtro)),
                onPressed: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('Filtrar reservas'),
                      children: [
                        _buildFiltroOption(context, filtro, 'TODOS', 'Todos', onFiltroChanged),
                        _buildFiltroOption(context, filtro, 'DIA', 'Día', onFiltroChanged),
                        _buildFiltroOption(context, filtro, 'SEMANA', 'Semana', onFiltroChanged),
                        _buildFiltroOption(context, filtro, 'MES', 'Mes', onFiltroChanged),
                        _buildFiltroOption(context, filtro, 'AÑO', 'Año', onFiltroChanged),
                      ],
                    ),
                  );
                  if (selected != null) {
                    onFiltroChanged(selected);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildReservasList(context, reservas, filtro),
        ],
      ],
    );
  }

  Widget _buildReservasList(BuildContext context, List reservas, String filtro) {
    final ahora = DateTime.now();
    List filtered = reservas;
    if (filtro == 'DIA') {
      filtered = reservas.where((r) => r.horarioInicio.year == ahora.year && r.horarioInicio.month == ahora.month && r.horarioInicio.day == ahora.day).toList();
    } else if (filtro == 'SEMANA') {
      final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));
      filtered = reservas.where((r) => r.horarioInicio.isAfter(inicioSemana.subtract(const Duration(seconds: 1))) && r.horarioInicio.isBefore(finSemana.add(const Duration(days: 1)))).toList();
    } else if (filtro == 'MES') {
      filtered = reservas.where((r) => r.horarioInicio.year == ahora.year && r.horarioInicio.month == ahora.month).toList();
    } else if (filtro == 'AÑO') {
      filtered = reservas.where((r) => r.horarioInicio.year == ahora.year).toList();
    }
    if (filtered.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No hay reservas en este periodo"),
      );
    }
    return Obx(() => Column(
      children: filtered.map<Widget>((reserva) {
        final isPendiente = reserva.estadoReserva == "PENDIENTE";
        final isSelected = reservaSeleccionada.value == reserva.codigoReserva;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: isSelected && isPendiente ? Colors.orange.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              leading: const Icon(Icons.local_parking),
              title: Text("Reserva: "+reserva.codigoReserva),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Auto: "+reserva.chapaAuto),
                  if (reserva.horarioInicio.day == reserva.horarioSalida.day)
                    Text("Duración: "+((reserva.horarioSalida.difference(reserva.horarioInicio).inMinutes / 60).round().toString())+" horas")
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Inicio: "+UtilesApp.formatearFechaDdMMAaaa(reserva.horarioInicio)),
                        Text("Fin: "+UtilesApp.formatearFechaDdMMAaaa(reserva.horarioSalida)),
                      ],
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₲"+UtilesApp.formatearGuaranies(reserva.monto),
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: reserva.estadoReserva == "PENDIENTE"
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      reserva.estadoReserva,
                      style: TextStyle(
                        color: reserva.estadoReserva == "PENDIENTE"
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: isPendiente
                  ? () {
                      reservaSeleccionada.value = reserva.codigoReserva;
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Get.to(() => PagoScreen(), arguments: reserva);
                        reservaSeleccionada.value = '';
                      });
                    }
                  : null,
            ),
          ),
        );
      }).toList(),
    ));
  }

  String _filtroLabel(String value) {
    switch (value) {
      case 'DIA': return 'Día';
      case 'SEMANA': return 'Semana';
      case 'MES': return 'Mes';
      case 'AÑO': return 'Año';
      case 'TODOS':
      default: return 'Todos';
    }
  }

  Widget _buildFiltroOption(BuildContext context, String current, String value, String label, ValueChanged<String> onFiltroChanged) {
    final isSelected = current == value;
    return SimpleDialogOption(
      onPressed: () => Navigator.of(context).pop(value),
      child: Row(
        children: [
          if (isSelected)
            const Icon(Icons.check, color: Colors.blue, size: 18),
          if (isSelected) const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
