import 'package:elite_soft/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';


class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.svgPath,
    this.margin,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.width,
    this.maxLines = 1,
    this.maxLength,
    this.showMaxLength = false,
    this.onChanged,
    this.errorText,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? svgPath;
  final EdgeInsetsGeometry? margin;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double? width;
  final int maxLines;
  final int? maxLength;
  final bool? showMaxLength;
  final Function? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? errorText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextFormField(
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  onFieldSubmitted: widget.onFieldSubmitted,

                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorName.NuturalColor2,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorName.NuturalColor2,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorName.errorColor6,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: ColorName.NuturalColor3),
                    prefixIcon: widget.svgPath != null
                        ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        widget.svgPath!,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          ColorName.NuturalColor3,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                        : null,
                  ),
                  onChanged: (text) {
                    setState(() {}); // Trigger a rebuild on text change
                  },
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _errorText = error;
                    });
                    return error != null ? '' : error;
                  },
                ),
                if (widget.showMaxLength ?? true)
                  Positioned(
                    left: 0,
                    bottom: -5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.controller.text.length >
                            (widget.maxLength ?? 0)
                            ? ColorName.errorColor6
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '${widget.controller.text.length}/${widget.maxLength ?? 0}',
                        style: const TextStyle(color: ColorName.errorColor6),
                      ),
                    ),
                  ),
              ],
            ),
            if (_errorText != null)
              Padding(
                padding:
                const EdgeInsets.only(left: Sizes.space16,),
                child: Text(
                  _errorText!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: ColorName.errorColor6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
