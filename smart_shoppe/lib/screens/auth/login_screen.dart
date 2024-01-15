import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_shoppe/constants/validators.dart';
import 'package:smart_shoppe/screens/auth/forgot_password_screen.dart';
import 'package:smart_shoppe/screens/auth/register_screen.dart';
import 'package:smart_shoppe/root_screen.dart';
import 'package:smart_shoppe/widgets/loading_widget.dart';
import 'package:smart_shoppe/widgets/text/text_effect_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';

import '../../constants/app_methods.dart';
import '../../widgets/auth/google_button_widget.dart';
import '../../widgets/text/subtitle_text_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
  final auth = FirebaseAuth.instance;

  // final bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Focus Nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });

        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        await AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "${error.message}",
          fct: () {},
        );
      } catch (error) {
        if (!mounted) return;

        await AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "$error",
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingWidget(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const TextEffectWidget(
                      label: 'SmartShoppe',
                      fontSize: 30,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: TitleTextWidget(label: "Welcome back"),
                    ),
                    const Align(
                      heightFactor: 1.3,
                      alignment: Alignment.centerLeft,
                      child: SubtitleTextWidget(
                          fontSize: 15,
                          label:
                              "Let's get you logged in so you can start exploring"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "user123@gmail.com",
                              filled: true,
                              prefixIcon: Icon(
                                IconlyLight.message,
                              ),
                            ),
                            validator: (value) {
                              return Validators.emailValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              hintText: "**********",
                              filled: true,
                              prefixIcon: const Icon(
                                IconlyLight.lock,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              return Validators.passwordValidator(value);
                            },
                            onFieldSubmitted: (value) {
                              _loginFct();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordScreen.routeName);
                              },
                              child: const SubtitleTextWidget(
                                label: "Forgot Password?",
                                color: Colors.deepPurple,
                                // textDecoration: TextDecoration.underline,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                _loginFct();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SubtitleTextWidget(
                            color: Colors.grey,
                            label: "OR connect using".toUpperCase(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: kBottomNavigationBarHeight + 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: kBottomNavigationBarHeight,
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            GoogleButtonWidget(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: kBottomNavigationBarHeight,
                                      child: FittedBox(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(12),
                                            // elevation: 1,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Guest",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, RootScreen.routName);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(
                                label: "Don't have an account?",
                              ),
                              TextButton(
                                child: const SubtitleTextWidget(
                                  label: "Sign up",
                                  fontStyle: FontStyle.italic,
                                  color: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.routName);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
