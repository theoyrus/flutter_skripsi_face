import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widgets/buttonLoading.widget.dart';
import 'controllers/auth_login.controller.dart';

class AuthLoginScreen extends GetView<AuthLoginController> {
  const AuthLoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('AuthLoginScreen'),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 60, left: 16, right: 16),
          width: context.width,
          height: context.height,
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                    width: context.width,
                  ),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                    width: context.width,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailCtrl,
                    onSaved: (value) {
                      controller.email = value!;
                    },
                    validator: (value) {
                      return controller.validateEmail(value!);
                    },
                  ),
                  SizedBox(
                    height: 15,
                    width: context.width,
                  ),
                  Obx(
                    () => TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () => controller.hiddenPass.toggle(),
                          icon: controller.hiddenPass.isTrue
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: controller.hiddenPass.value,
                      controller: controller.passwordCtrl,
                      onSaved: (value) {
                        controller.password = value!;
                      },
                      validator: (value) {
                        return controller.validatePass(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                    width: context.width,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: context.width),
                    child: Obx(
                      () => ButtonLoading(
                        isLoading: controller.isLoading.value,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurpleAccent),
                        onPressed: () => controller.checkLogin(),
                        defaultLabel: const Text(
                          "Login ",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
