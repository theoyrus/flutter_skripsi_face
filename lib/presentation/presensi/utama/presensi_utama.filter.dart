import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../utils/date_time.utils.dart';
import '../../../utils/filter.utils.dart';
import '../../widgets/slideUp.widget.dart';

class PresensiUtamaFilterController extends GetxController {
  final PanelController panelCtrl = PanelController();
  final filtering = Filtering();
  GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 500), () {
      panelCtrl.isAttached ? panelCtrl.open() : null;
    });
    super.onInit();
  }

  void doSearch() {
    // var qParams = (filtering.generateQueryParams());
    var form = fbKey.currentState;
    form?.save();
    var fVal = form?.value;
    // debugPrint('saved ... $fVal');
    Get.back(result: fVal);
  }
}

class PresensiUtamaFilter extends StatelessWidget {
  const PresensiUtamaFilter({super.key});

  List<Widget> panelSlideUp(PresensiUtamaFilterController c) {
    // int bulanFilter = DateTime.now().month;
    // int tahunFilter = DateTime.now().year;

    // var initialValue = {
    //   'bulan': DateTime.now().month,
    //   'tahun': DateTime.now().year,
    // };

    // List<S2Choice<int>> bulanS2Opts = List.generate(
    //   12,
    //   (bulan) => S2Choice<int>(
    //       value: bulan + 1,
    //       title: getMonthNameByIdx(bulan + 1, langCode: 'id')),
    // );

    // List<S2Choice<int>> tahunS2Opts = List.generate(
    //   tahunFilter == 2023 ? 1 : (tahunFilter - 2023 + 1),
    //   (tahun) => S2Choice<int>(
    //     value: tahunFilter - tahun,
    //     title: (tahunFilter - tahun).toString(),
    //   ),
    // );

    List<MonthOpts> bulanOpts = List.generate(
        12,
        (bulan) => MonthOpts(
              bulan + 1,
              getMonthNameByIdx(bulan + 1, langCode: 'id'),
            ));

    return [
      const SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          ),
        ],
      ),
      const SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          key: c.fbKey,
          onChanged: () {
            c.fbKey.currentState?.save();
            // debugPrint(c.fbKey.currentState?.value.toString());
          },
          // initialValue: c.initialValue,
          // initialValue: initialValue,
          child: Column(
            children: [
              // FormBuilderRadioGroup<String>(
              //   decoration: const InputDecoration(
              //     labelText: 'Rentang Waktu',
              //   ),
              //   initialValue: null,
              //   name: 'range',
              //   validator: FormBuilderValidators.compose(
              //       [FormBuilderValidators.required()]),
              //   options: ['7 hari terakhir', 'Bulan ini']
              //       .map((lang) => FormBuilderFieldOption(
              //             value: lang,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(lang),
              //                 // Image widget,
              //               ],
              //             ),
              //           ))
              //       .toList(growable: false),
              //   controlAffinity: ControlAffinity.trailing,
              // ),
              const Center(
                child: Text(
                  'Filter Data Presensi',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FormBuilderDropdown(
                name: 'bulan',
                items: bulanOpts
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.value,
                        child: Text(item.title),
                      ),
                    )
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Bulan',
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                validator: FormBuilderValidators.required(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              FormBuilderTextField(
                name: 'tahun',
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: FormBuilderValidators.match(r'^\d{4}$',
                    errorText: 'isikan tahun'),
                autovalidateMode: AutovalidateMode.always,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      // SmartSelect<int>.single(
      //   title: 'Bulan',
      //   choiceItems: bulanOpts,
      //   selectedValue: bulanFilter,
      //   modalType: S2ModalType.bottomSheet,
      //   onChange: (selected) {
      //     c.filtering.addFilter('bulan', selected.value);
      //   },
      // ),
      // SmartSelect<int>.single(
      //   title: 'Tahun',
      //   choiceItems: tahunOpts,
      //   selectedValue: tahunFilter,
      //   modalType: S2ModalType.bottomSheet,
      //   onChange: (selected) {
      //     c.filtering.addFilter('tahun', selected.value);
      //   },
      // ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () => c.doSearch(),
          child: const Text('Cari'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PresensiUtamaFilterController>(
      init: PresensiUtamaFilterController(),
      builder: (controller) {
        return SlideUpWidget(
          panelCtrl: controller.panelCtrl,
          panel: panelSlideUp(controller),
        );
      },
    );
  }
}
