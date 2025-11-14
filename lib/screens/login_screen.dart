import 'package:flutter/material.dart';
import 'package:partice_project/components/app_button.dart';
import 'package:partice_project/components/app_input.dart';
import 'package:partice_project/components/app_padding.dart';
import 'package:partice_project/components/gap.dart';
import 'package:partice_project/components/login_footer.dart';
import 'package:partice_project/constant/colors.dart';
import 'package:partice_project/utils/route_name.dart';
import 'package:provider/provider.dart';
import 'package:partice_project/providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final focusNodeEmail = FocusNode();
  final focusNodePassword = FocusNode();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formkey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        username: email.text.trim(),
        password: password.text.trim(),
      );

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: "Giriş başarılı!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.homeScreen,
          (route) => false,
        );
      } else if (!success && mounted) {
        final errorMsg = authProvider.errorMessage ?? 'Giriş başarısız';
        Fluttertoast.showToast(
          msg: errorMsg,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: AppPadding(
          padddingValue: 15,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: const Image(
                    width: 80,
                    fit: BoxFit.cover,
                    image: AssetImage("lib/assets/logo.png"),
                  ),
                ),
                Center(
                  child: Text(
                    "Giriş Yap",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(isWidth: false, isHeight: true, height: height * 0.02),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      AppInput(
                          myController: email,
                          focusNode: focusNodeEmail,
                          onFiledSubmitedValue: (value) {
                            focusNodePassword.requestFocus();
                          },
                          keyBoardType: TextInputType.emailAddress,
                          obscureText: false,
                          isFilled: true,
                          hinit: "Kullanıcı Adınızı Girin",
                          leftIcon: true,
                          icon: const Icon(Icons.person),
                          onValidator: (value) {
                            if (value.isEmpty) {
                              return 'Kullanıcı adınızı girin';
                            }
                            return null;
                          }),
                      Gap(
                          isWidth: false,
                          isHeight: true,
                          height: height * 0.019),
                      AppInput(
                          myController: password,
                          focusNode: focusNodePassword,
                          onFiledSubmitedValue: (value) {
                            _handleLogin();
                          },
                          keyBoardType: TextInputType.text,
                          obscureText: true,
                          hinit: "Şifrenizi Girin",
                          leftIcon: true,
                          icon: const Icon(Icons.lock),
                          isFilled: true,
                          onValidator: (value) {
                            if (value.isEmpty) {
                              return 'Şifrenizi girin';
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                Gap(isWidth: false, isHeight: true, height: height * 0.019),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutesName.forgotPasswordScreen);
                    },
                    child: Text(
                      "Şifremi Unuttum?",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Gap(isWidth: false, isHeight: true, height: height * 0.04),
                AppButton(
                  onPress: authProvider.isLoading
                      ? () {}
                      : () {
                          _handleLogin();
                        },
                  loading: authProvider.isLoading,
                  title: "Giriş Yap",
                  height: 63,
                  textColor: AppColors.whiteColor,
                ),
                const LoginFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
