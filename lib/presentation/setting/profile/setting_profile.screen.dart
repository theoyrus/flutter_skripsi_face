import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/divisi/divisi.provider.dart';
import '../../../utils/date_time.utils.dart';
import 'controllers/setting_profile.controller.dart';

class SettingProfileScreen extends GetView<SettingProfileController> {
  const SettingProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var kMe = controller.karyawanMe;
    var initialValue = {
      'noinduk': kMe.noinduk,
      'nama': kMe.nama,
      'divisi': kMe.divisi?.divisiId
    };
    var genderOptions = ['Laki-Laki', 'Perempuan'];
    void _onChanged(dynamic val) => debugPrint(val.toString());

    const allCountries = [
      'Guatemala',
      'Guinea',
      'Guinea-Bissau',
      'Guyana',
      'Haiti',
      'Heard and Mc Donald Islands',
      'Holy See (Vatican City State)',
      'Honduras',
      'Hong Kong',
      'Hungary',
      'Iceland',
      'India',
      'Indonesia',
      'Iran (Islamic Republic of)',
      'Iraq',
      'Ireland',
      'Israel',
      'Italy',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          ElevatedButton(
            onPressed: () => controller.save(),
            child: const Icon(Icons.save_outlined),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Center(
            child: Text(
              'Atur profil karyawan',
              style: TextStyle(fontSize: 20),
            ),
          ),
          FormBuilder(
            key: controller.fbKey,
            onChanged: () {
              controller.fbKey.currentState?.save();
              debugPrint(controller.fbKey.currentState?.value.toString());
            },
            initialValue: initialValue,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'noinduk',
                  decoration: const InputDecoration(
                    labelText: 'Nomor Induk',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: FormBuilderValidators.numeric(),
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'nama',
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.face_outlined),
                  ),
                  validator: FormBuilderValidators.required(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                // const SizedBox(height: 20),
                // FormBuilderDateTimePicker(
                //   name: "tgllahir",
                //   textInputAction: TextInputAction.done,
                //   inputType: InputType.date,
                //   format: DateFormat("dd MMMM yyyy", 'id'),
                //   decoration: const InputDecoration(
                //       labelText: "Tanggal Lahir",
                //       prefixIcon: Icon(Icons.calendar_month_outlined)
                //       // border: OutlineInputBorder(borderSide: BorderSide()),
                //       ),
                //   validator: FormBuilderValidators.compose([
                //     FormBuilderValidators.required(),
                //   ]),
                //   onChanged: (v) {
                //     if (v != null) {
                //       debugPrint('tgllahir: $v');
                //       DateTime tglLahir = DateTime.parse(enFullDate(v));
                //       debugPrint('birthDateFmt $tglLahir');
                //       controller.fbKey.currentState?.fields['tgllahir']
                //           ?.setValue(tglLahir);
                //     }
                //   },
                // ),
                // const SizedBox(height: 20),
                // FormBuilderSearchableDropdown<String>(
                //   popupProps: const PopupProps.menu(showSearchBox: true),
                //   name: 'searchable_dropdown_online',
                //   onChanged: _onChanged,
                //   asyncItems: (filter) async {
                //     // await Future.delayed(const Duration(seconds: 1));
                //     return allCountries
                //         .where((element) => element
                //             .toLowerCase()
                //             .contains(filter.toLowerCase()))
                //         .toList();
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Searchable Dropdown Online',
                //     prefixIcon: Icon(Icons.flag_outlined),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // FormBuilderDropdown<String>(
                //   name: 'gender',
                //   decoration: const InputDecoration(
                //     labelText: 'Gender',
                //     hintText: 'Select Gender',
                //     prefixIcon: Icon(MdiIcons.genderMaleFemale),
                //   ),
                //   validator: FormBuilderValidators.compose(
                //       [FormBuilderValidators.required()]),
                //   items: genderOptions
                //       .map((gender) => DropdownMenuItem(
                //             alignment: AlignmentDirectional.center,
                //             value: gender,
                //             child: Text(gender),
                //           ))
                //       .toList(),
                //   valueTransformer: (val) => val?.toString(),
                // ),
                const SizedBox(height: 20),
                GetBuilder<DivisiProvider>(
                  init: DivisiProvider(),
                  initState: (_) {},
                  builder: (_) {
                    return FormBuilderDropdown(
                      name: 'divisi',
                      items: _.divisiList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.divisiId,
                              child: Text("[${item.kode}] ${item.nama}"),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Divisi',
                        prefixIcon: Icon(Icons.groups_outlined),
                      ),
                      validator: FormBuilderValidators.required(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
