import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../face_detector_view.dart';
import '../../models/face_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/Validator.dart';
import '../../constants/colors.dart';
import 'custom_textformfield.dart';
import 'loading_dialog.dart';
import '../../constants/sizes.dart';
import '../../constants/string_app_constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog();
      },
    );

    await authProvider.login(_emailController.text, _passwordController.text);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Close the loading dialog

    if (authProvider.isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceDetectorView(
            listFace: [
              FaceModel(
                  faceAction: AppConstants.turnLeft,
                  faceEnum: FaceEnum.turnLeft),
              FaceModel(
                  faceAction: AppConstants.turnRight,
                  faceEnum: FaceEnum.turnRight),
              FaceModel(
                  faceAction: AppConstants.smile, faceEnum: FaceEnum.smile),
            ],
          ),
        ),
      );
    } else if (authProvider.error != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          content: Center(
              child: Text(
            AppConstants.errorEmailOrAccesscode,
            style: TextStyle(
              fontSize: Sizes.space14,
              color: ColorName.secondaryLight,
            ),
          )),
          backgroundColor: ColorName.errorColor7,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              const Text(
                AppConstants.loginGreeting,
                style: TextStyle(
                  color: ColorName.NuturalColor5,
                  fontSize: Sizes.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CustomTextFormField(
            keyboardType: TextInputType.text,
            margin: const EdgeInsets.only(
              top: Sizes.space16,
              bottom: Sizes.space10,
            ),
            controller: _emailController,
            hintText: AppConstants.emailHint,
            svgPath: AppConstants.userIconPath,
            validator: (value) => Validator.validateEmail(value),
          ),
          CustomTextFormField(
            controller: _passwordController,
            hintText: AppConstants.passwordHint,
            svgPath: AppConstants.keyIconPath,
            validator: (value) => Validator.validatePassword(value),
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _login(context);
              }
            },
            child: authProvider.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorName.secondaryLight,
                    ),
                  )
                : Text(
                    AppConstants.loginButtonText,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: ColorName.secondaryLight,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}
