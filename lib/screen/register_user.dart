import 'package:flutter/material.dart';

import '../controller/sqflite_db_controller.dart';
import '../di.dart';
import '../model/user.dart';
import '../utils/validation.dart';
import '../widget/button.dart';
import '../widget/outlined_button.dart';
import '../widget/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ValueNotifier<bool> showPassword = ValueNotifier(true);
  final registerFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    showPassword.dispose();
    email.dispose();
    name.dispose();
    password.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (registerFormKey.currentState!.validate()) {
      User user =
          User(email: email.text, password: password.text, username: name.text);
      await locator<SqfLiteDbController>().insertUser(user, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 310.0,
              width: double.infinity,
              color: Colors.amber,
            ),
            Container(
              margin: const EdgeInsets.only(top: 250),
              padding:
                  const EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: Form(
                key: registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Text(
                      "Create an account",
                      style: textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30.0),
                    CommonTextField(
                      fieldKey: "register_name",
                      label: "NAME",
                      controller: name,
                      prefixIcon: const Icon(Icons.person_outlined),
                      validator: locator<Validator>().isNUllCheck,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10.0),
                    CommonTextField(
                      fieldKey: "register_email",
                      label: "EMAIL",
                      controller: email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: locator<Validator>().isEmail,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10.0),
                    ValueListenableBuilder<bool>(
                      valueListenable: showPassword,
                      builder: (ctx, snapshot, _) {
                        return CommonTextField(
                          fieldKey: "register_pwd",
                          label: "PASSWORD",
                          controller: password,
                          validator: locator<Validator>().isNUllCheck,
                          prefixIcon: const Icon(Icons.lock_outline),
                          obscure: snapshot,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          suffixIcon: IconButton(
                            icon: Icon(snapshot
                                ? Icons.remove_red_eye
                                : Icons.visibility_off),
                            onPressed: () =>
                                showPassword.value = !showPassword.value,
                          ),
                        );
                      },
                    ),
                    Button(
                      title: "Sign Up",
                      onClick: registerUser,
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: CommonOutlinedButton(
                            title: "Login",
                            fullWidth: true,
                            onClick: () {},
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
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
