import 'package:flutter/material.dart';

import '../controller/sqflite_db_controller.dart';
import '../di.dart';
import '../utils/validation.dart';
import '../widget/button.dart';
import '../widget/text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final forgotPasswordKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    obscurePassword.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void checkUserExists() async {
    if (forgotPasswordKey.currentState!.validate()) {
      bool isExists = await locator<SqfLiteDbController>()
          .checkUserExists(email.text, context);
      if (isExists) {
        showPasswordEnterBottomSheet();
      } else {
        showErrorSnackBar(context, "email id not exists");
      }
    }
  }

  void updatePassword(BuildContext ctx) async {
    if (passwordFormKey.currentState!.validate()) {
      await locator<SqfLiteDbController>()
          .updatePassword(email.text, password.text, context);
      Navigator.pop(ctx, true);
    }
  }

  void showPasswordEnterBottomSheet() async {
    password.clear();
    var isSubmit = await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 20.0,
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: passwordFormKey,
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (ctx, snapshot, _) {
                        return CommonTextField(
                            fieldKey: "login_password",
                            label: "PASSWORD",
                            controller: password,
                            validator: locator<Validator>().isNUllCheck,
                            prefixIcon: const Icon(Icons.lock_outline),
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscure: snapshot,
                            suffixIcon: IconButton(
                              icon: Icon(snapshot
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off),
                              onPressed: () => obscurePassword.value =
                                  !obscurePassword.value,
                            ));
                      }),
                  const SizedBox(height: 10.0),
                  Button(
                    title: "Submit",
                    onClick: () {
                      updatePassword(ctx);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (isSubmit != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 380.0,
              width: double.infinity,
              color: Colors.amber,
            ),
            Container(
              margin: const EdgeInsets.only(top: 300),
              padding:
                  const EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: Form(
                key: forgotPasswordKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    CommonTextField(
                      fieldKey: "login_email",
                      label: "EMAIL",
                      controller: email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: locator<Validator>().isEmail,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10.0),
                    Button(
                      title: "Submit",
                      onClick: checkUserExists,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
