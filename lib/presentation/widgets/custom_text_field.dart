import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final String subTitle;
  final String hintText;
  final String titleHintText;
  final bool isEmail;
  final bool isPassword;
  final bool obscureText;
  final int? minLines;
  final double? height;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onsuffixIconPressed;
  final void Function()? onprefixIconPressed;
  final void Function()? onPressed;
  final TextInputType keyboardType;
  final String? error;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatter;
  final TextAlign textAlign;
  final bool readOnly;
  final bool? expands;
  final double? borderWidth;
  final double? borderRadius;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? enableBorderColor;
  final InputBorder? border;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final String? Function(String? value)? validator;
  final String? initialValue;
  final bool noHeight;
  final TextStyle? style;
  final Color? textColor;
  final TextStyle? hintStyle;
  final bool isRequired;
  final bool isCap;
  final Color? borderColor;
  final Color? tetxColor;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  const CustomTextField({
    super.key,
    this.onPressed,
    this.border,
    this.expands,
    this.enableBorderColor,
    this.onsuffixIconPressed,
    this.onprefixIconPressed,
    this.contentPadding,
    this.formatter,
    this.borderWidth = 1,
    this.borderRadius,
    this.fillColor,
    this.controller,
    this.hintText = '',
    this.title = '',
    this.subTitle = '',
    this.isPassword = false,
    this.minLines,
    this.maxLines,
    this.isEmail = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.obscureText = false,
    this.error,
    this.titleHintText = '',
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.padding,
    this.validator,
    this.initialValue,
    this.noHeight = false,
    this.height,
    this.style,
    this.textColor,
    this.hintStyle,
    this.isRequired = false,
    this.isCap = false,
    this.autofocus = false,
    this.borderColor,
    this.tetxColor,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isRequired
              ? RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: context.color.darkText,
                    ),
                    children: const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: red,
                        ),
                      )
                    ],
                  ),
                )
              : widget.title.isNotEmpty
                  ? Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: widget.tetxColor ?? context.color.white,
                      ),
                    )
                  : const SizedBox(),
          widget.title.isNotEmpty
              ? const SizedBox(height: 6)
              : const SizedBox(),
          widget.titleHintText.isNotEmpty
              ? Text(
                  widget.titleHintText,
                  // style: fonts.caption.copyWith(
                  //   color: colors.grey,
                  // ),
                )
              : const SizedBox(),
          widget.titleHintText.isNotEmpty
              ? const SizedBox(height: 6)
              : const SizedBox(),
          SizedBox(
            height: widget.noHeight ? null : widget.height ?? 64,
            child: GestureDetector(
              onTap: widget.onPressed,
              child: TextFormField(
                initialValue: widget.initialValue,
                expands: widget.expands ?? true,
                onTap: widget.onPressed,
                autofocus: widget.autofocus,
                textInputAction: TextInputAction.done,
                focusNode: widget.focusNode,
                maxLength: widget.maxLength,
                onChanged: widget.onChanged,
                readOnly: widget.readOnly,
                textAlign: widget.textAlign,
                inputFormatters: widget.formatter,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                controller: widget.controller,
                style: widget.style ??
                    Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: widget.textColor,
                        ),
                textCapitalization: widget.isCap
                    ? TextCapitalization.words
                    : widget.textCapitalization,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                validator: widget.validator,
                decoration: InputDecoration(
                  counterText: widget.maxLength == 500 ? null : '',
                  suffixIcon: widget.suffixIcon != null
                      ? IconButton(
                          icon: widget.suffixIcon!,
                          onPressed: widget.onsuffixIconPressed ?? () {},
                        )
                      : null,
                  prefixIcon: widget.prefixIcon != null
                      ? IconButton(
                          icon: widget.prefixIcon!,
                          onPressed: widget.onprefixIconPressed ?? () {})
                      : null,
                  focusColor: context.color.contGrey,
                  fillColor: widget.fillColor ?? context.color.contGrey,
                  hoverColor: context.color.contGrey,
                  filled: true,
                  border: widget.border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: widget.borderColor ??
                              shuttleGrey.withValues(alpha: .2),
                        ),
                      ),
                  enabledBorder: widget.border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 24,
                        ),
                        borderSide: BorderSide(
                          color: widget.borderColor ??
                              shuttleGrey.withValues(alpha: .2),
                        ),
                      ),
                  focusedBorder: widget.border ??
                      OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? 24,
                        ),
                        borderSide: BorderSide(
                          color: widget.borderColor ??
                              shuttleGrey.withValues(alpha: .2),
                        ),
                      ),
                  hintText: widget.hintText,
                  hintMaxLines: 1,
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                        color: widget.tetxColor ?? context.color.darkText,
                        overflow: TextOverflow.ellipsis,
                      ),
                  // hintStyle: fonts.subtitle1.copyWith(
                  //     color: colors.customBlack.withValues(alpha:0.5), fontSize: 14.sp),
                  // errorText: widget.error,
                  // errorStyle: fonts.caption.copyWith(color: colors.error),
                  contentPadding:widget.contentPadding??
                      const EdgeInsets.only(left: 12, top: 12, right: 12),
                ),
              ),
            ),
          ),
          widget.subTitle.isNotEmpty
              ? const SizedBox(height: 6)
              : const SizedBox(),
          widget.subTitle.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.subTitle,
                      // style: fonts.bodyText1.copyWith(
                      //     color: widget.error == null
                      //         ? colors.bodyText
                      //         : colors.error,
                      //     fontSize: 12.sp),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
