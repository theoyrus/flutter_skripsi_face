import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../domain/divisi/divisi.provider.dart';
import 'controllers/setting_profile.controller.dart';

class SettingProfileScreen extends GetView<SettingProfileController> {
  const SettingProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var kMe = controller.karyawanMe;
    var initialValue = {
      'noinduk': kMe.noinduk,
      'nama': kMe.nama,
      'divisi': kMe.divisi?.divisiId,
      'username': kMe.user?.username,
      'new_email': kMe.user?.email,
      'first_name': kMe.nama?.split(' ').first, // kMe.user?.firstName,
      'last_name':
          kMe.nama?.split(' ').skip(1).join(' '), // kMe.user?.lastName,
    };
    var genderOptions = ['Laki-Laki', 'Perempuan'];

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
              // debugPrint(controller.fbKey.currentState?.value.toString());
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
                  onChanged: (v) {
                    if (v != null) {
                      var cS = controller.fbKey.currentState;
                      String? fName = v.split(' ').first;
                      String? lName = v.split(' ').skip(1).join(' ');
                      cS?.fields['first_name']?.didChange(fName);
                      cS?.fields['last_name']?.didChange(lName);
                    }
                  },
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

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Atur akun',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'username',
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                  ),
                  validator: FormBuilderValidators.match(r'^[A-Za-z0-9_-]+$',
                      errorText:
                          'Username hanya mengizinkan karakter (A-Z, a-z, 0-9, -, dan _)'),
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'first_name',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Nama Depan',
                    prefixIcon: Icon(Icons.person_outline_sharp),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'last_name',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Nama Belakang',
                    prefixIcon: Icon(Icons.person_outline_sharp),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                FormBuilderSwitch(
                  name: 'is_change_pass',
                  initialValue: false,
                  title: const Text('Ganti email & kata sandi?'),
                  onChanged: (value) => controller.isChangePass.toggle(),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isChangePass.isTrue,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'new_email',
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(),
                            FormBuilderValidators.required()
                          ]),
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          obscureText: controller.hiddenPass.isTrue,
                          name: 'current_password',
                          decoration: InputDecoration(
                            labelText: 'Kata sandi saat ini',
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () => controller.hiddenPass.toggle(),
                              icon: controller.hiddenPass.isTrue
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          initialValue: '',
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          obscureText: controller.hiddenNewPass.isTrue,
                          name: 'new_password',
                          decoration: InputDecoration(
                            labelText: 'Kata sandi baru',
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  controller.hiddenNewPass.toggle(),
                              icon: controller.hiddenNewPass.isTrue
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(8,
                                errorText: 'Minimal 8 karakter'),
                          ]),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          initialValue: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
