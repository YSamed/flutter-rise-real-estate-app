import 'package:flutter/material.dart';
import 'package:partice_project/constant/colors.dart';

class AppInput extends StatefulWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFiledSubmitedValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final String hinit;
  final bool obscureText,
      enable,
      autoFocus,
      leftIcon,
      rightIcon,
      isFilled,
      otherColor,
      isCompact;
  final Icon icon;
  const AppInput(
      {Key? key,
      required this.myController,
      required this.focusNode,
      required this.onFiledSubmitedValue,
      this.onChanged,
      required this.keyBoardType,
      required this.obscureText,
      required this.hinit,
      required this.onValidator,
      this.leftIcon = false,
      this.isFilled = false,
      this.icon = const Icon(Icons.email),
      this.rightIcon = false,
      this.otherColor = false,
      this.enable = true,
      this.autoFocus = false,
      this.isCompact = false})
      : super(key: key);

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool passwordShow;

  @override
  void initState() {
    super.initState();
    passwordShow = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.myController,
      focusNode: widget.focusNode,
      obscureText: passwordShow,
      onFieldSubmitted: widget.onFiledSubmitedValue,
      onChanged: widget.onChanged,
      validator: widget.onValidator,
      keyboardType: widget.keyBoardType,
      decoration: InputDecoration(
        fillColor: widget.otherColor
            ? AppColors.whiteColor
            : AppColors.inputBackground,
        contentPadding: widget.isCompact
            ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0)
            : const EdgeInsets.symmetric(vertical: 27.0, horizontal: 10.0),
        filled: widget.isFilled,
        hintText: widget.hinit,
        enabled: widget.enable,
        prefixIcon: widget.leftIcon ? widget.icon : null,
        suffixIcon: widget.obscureText
            ? InkWell(
                onTap: () {
                  setState(() {
                    passwordShow = !passwordShow;
                  });
                },
                child: passwordShow
                    ? const Icon(Icons.remove_red_eye)
                    : const Icon(Icons.visibility_off))
            : null,
        // contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondaryColor),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.alertColor),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor),
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
