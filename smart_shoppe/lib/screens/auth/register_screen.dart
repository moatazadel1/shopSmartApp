import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_shoppe/constants/app_methods.dart';
import 'package:smart_shoppe/widgets/loading_widget.dart';
import 'package:smart_shoppe/widgets/text/text_effect_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../../constants/validators.dart';
import '../../widgets/auth/pick_image_widget.dart';
import '../../root_screen.dart';
import '../../widgets/text/subtitle_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = 'RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;
  late final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool _isLoading = false;
  String? userImageUrl;
  XFile? _pickedImage;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Focus Nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null) {
      AppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: "Make sure to pick up an image",
        fct: () {},
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child('${_emailController.text.trim()}.jpg');
        await ref.putFile(File(_pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
        Fluttertoast.showToast(
          msg: "An account has been created",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      } on FirebaseAuthException catch (error) {
        await AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured ${error.message}",
          fct: () {},
        );
      } catch (error) {
        await AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: "An error has been occured $error",
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // Future<void> _registerFct() async {
  //   final isValid = _formKey.currentState!.validate();
  //   FocusScope.of(context).unfocus();
  // if (_pickedImage == null) {
  //   AppMethods.showErrorORWarningDialog(
  //     context: context,
  //     subtitle: "Make sure to pick up an image",
  //     fct: () {},
  //   );
  //   return;
  // }
  //   if (isValid) {
  //     _formKey.currentState!.save();
  //     try {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       auth.createUserWithEmailAndPassword(
  //           email: _emailController.text.trim(),
  //           password: _passwordController.text.trim());
  //       Fluttertoast.showToast(
  //         msg: "An account has been created",
  //         toastLength: Toast.LENGTH_SHORT,
  //         textColor: Colors.white,
  //       );
  //     } on FirebaseAuthException catch (error) {
  //       await AppMethods.showErrorORWarningDialog(
  //         context: context,
  //         subtitle: "${error.message}",
  //         fct: () {},
  //       );
  //     } catch (error) {
  //       await AppMethods.showErrorORWarningDialog(
  //         context: context,
  //         subtitle: "$error",
  //         fct: () {},
  //       );
  //     } finally {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await AppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
        ),
        body: LoadingWidget(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TextEffectWidget(
                    label: 'SmartShoppe',
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(label: "Welcome"),
                        SizedBox(
                          height: 3,
                        ),
                        SubtitleTextWidget(
                            fontSize: 16,
                            label:
                                "Sign up now to receive special offers and updates from our app.")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: PickImageWidget(
                      pickedImage: _pickedImage,
                      function: () async {
                        await localImagePicker();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: "Full name",
                            filled: true,
                            prefixIcon: Icon(
                              IconlyLight.profile,
                            ),
                          ),
                          validator: (value) {
                            return Validators.displayNamevalidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
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
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
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
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocusNode);
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "*********",
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
                            return Validators.repeatPasswordValidator(
                                value: value,
                                password: _passwordController.text);
                          },
                          onFieldSubmitted: (value) {
                            _registerFct();
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              _registerFct();
                            },
                          ),
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
    );
  }
}
