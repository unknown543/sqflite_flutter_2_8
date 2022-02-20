import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/sqflite_db_controller.dart';
import '../di.dart';
import '../screen/forgot_password.dart';
import '../screen/register_user.dart';
import '../utils/validation.dart';
import '../widget/button.dart';
import '../widget/outlined_button.dart';
import '../widget/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> obscurePassword = ValueNotifier(true);
  final loginFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    locator<SqfLiteDbController>().insertTestDetail(context);
    super.initState();
  }

  @override
  void dispose() {
    obscurePassword.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void logIn() async {
    if (loginFormKey.currentState!.validate()) {
      await locator<SqfLiteDbController>()
          .logInUser(email.text, password.text, context);
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
              height: 200.0,
              width: double.infinity,
              color: Colors.amber,
            ),
            Container(
              margin: const EdgeInsets.only(top: 210),
              padding:
                  const EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: Form(
                key: loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Text(
                      "Sign in to continue",
                      style: textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
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
                    ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (ctx, snapshot, _) {
                        return CommonTextField(
                          fieldKey: "login_password",
                          label: "PASSWORD",
                          controller: password,
                          validator: locator<Validator>().isNUllCheck,
                          prefixIcon: const Icon(Icons.lock_outline),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          obscure: snapshot,
                          suffixIcon: IconButton(
                            icon: Icon(snapshot
                                ? Icons.remove_red_eye
                                : Icons.visibility_off),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        );
                      },
                    ),
                    Button(title: "Login", onClick: logIn),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    CommonOutlinedButton(
                      title: "Register",
                      fullWidth: true,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
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
