// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbm/common/styles/const.dart';

import '../common_function.dart';

class AllInputDesign extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final controller;
  final floatingLabelBehavior;
  final prefixText;
  final fillColor;
  final enabled;
  final initialValue;
  final hintText;
  final labelText;
  final textInputAction;
  final prefixStyle;
  final validator;
  final errorText;
  final keyBoardType;
  final validatorFieldValue;
  final List<TextInputFormatter>? inputFormatterData;
  final FormFieldSetter<String>? onSaved;
  final onTap;
  final onSubmitted;
  final obsecureText;
  final suffixIcon;
  final prefixIcon;
  final maxLength;
  final outlineInputBorderColor;
  final outlineInputBorder;
  final enabledBorderRadius;
  final focusedBorderRadius;
  final enabledOutlineInputBorderColor;
  final focusedBorderColor;
  final hintTextStyleColor;
  final counterText;
  final cursorColor;
  final textStyleColors;
  final inputHeaderName;
  final autofillHints;
  final onEditingComplete;
  final textCapitalization;
  final keyboardType;
  final maxLines;
  final minLines;
  final boxshadow;
  final elevation;
  final widthtextfield;
  final higthtextfield;
  final inputHeaderTextStyle;
  final inputLableColor;

  const AllInputDesign({
    Key? key,
    this.textStyleColors,
    this.controller,
    this.floatingLabelBehavior,
    this.initialValue,
    this.cursorColor,
    this.prefixIcon,
    this.textInputAction,
    this.outlineInputBorder,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.enabled,
    this.prefixText,
    this.fillColor,
    this.prefixStyle,
    this.keyBoardType,
    this.obsecureText,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.validatorFieldValue,
    this.inputFormatterData,
    this.validator,
    this.onSaved,
    this.onTap,
    this.onSubmitted,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.outlineInputBorderColor,
    this.enabledOutlineInputBorderColor,
    this.focusedBorderColor,
    this.hintTextStyleColor,
    this.counterText,
    this.inputHeaderName,
    this.onEditingComplete,
    this.autofillHints,
    this.textCapitalization,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.boxshadow,
    this.elevation,
    this.widthtextfield,
    this.higthtextfield,
    this.inputHeaderTextStyle,
    this.inputLableColor,
  }) : super(key: key);

  @override
  _AllInputDesignState createState() => _AllInputDesignState();
}

class _AllInputDesignState extends State<AllInputDesign> {
  var cf = CommonFunctions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.inputHeaderName != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      (widget.inputHeaderName != null)
                          ? widget.inputHeaderName
                          : '',
                      style: (widget.inputHeaderTextStyle != null)
                          ? widget.inputHeaderTextStyle
                          : textstylesubtitle1(context)!
                              .copyWith(color: colorgrey),
                    ),
                  ),
                  myTextfieldWidget(context),
                ],
              )
            : myTextfieldWidget(context),
      ],
    );
  }

  Widget myTextfieldWidget(BuildContext context) {
    double screensize = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: widget.enabledBorderRadius ?? BorderRadius.circular(0),
      color: Colors.transparent,
      elevation: widget.elevation ?? 0,
      child: Container(
        width: widget.widthtextfield ?? screensize,
        height: widget.higthtextfield,
        decoration: BoxDecoration(
            borderRadius: widget.boxshadow != null
                ? BorderRadius.circular(3)
                : BorderRadius.circular(0),
            boxShadow: widget.boxshadow ??
                [
                  BoxShadow(
                    color: Colors.transparent,
                    // spreadRadius: 1,
                    // blurRadius: 1,
                    // offset: Offset(0, 3),
                  )
                ]),
        child: TextFormField(
          // expands: true,
          onFieldSubmitted: widget.onSubmitted,
          minLines: widget.maxLines ?? 1,
          maxLines: widget.maxLines ?? 1,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          cursorColor: widget.cursorColor ?? colorblack,
          key: Key(cf.convertKey(widget.labelText)),
          //onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          style: TextStyle(
              color: widget.textStyleColors ?? colorblack,
              // fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              fontSize: screensize <= 350 ? 14 : 16),
          keyboardType: widget.keyBoardType,
          validator: widget.validator,
          controller: widget.controller,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          // initialValue: widget.initialValue == null ? '' : widget.initialValue,
          inputFormatters: widget.inputFormatterData,
          obscureText: widget.obsecureText ?? false,
          //onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            labelText: widget.labelText ?? widget.hintText ?? '',

            labelStyle: textstylesubtitle1(context)!
                .copyWith(color: widget.inputLableColor ?? colorgrey),
            counterText: widget.counterText,
            filled: true,
            fillColor: widget.fillColor ?? colorWhitetextfield,
            hintText: (widget.hintText != null) ? widget.hintText : '',
            floatingLabelBehavior:
                widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            hintStyle: TextStyle(
              color: widget.hintTextStyleColor ?? colorblack,
              fontSize: 14,

              // fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon != null
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: widget.prefixIcon,
                  )
                : null,

            suffixIcon: widget.suffixIcon != null
                ? widget.suffixIcon ?? Text('')
                : null,
            prefixText: (widget.prefixText != null) ? widget.prefixText : '',
            prefixStyle: widget.prefixStyle,
            errorText: widget.errorText,
            // errorStyle: TextStyle(fontFamily: pCommonRegularFont),
            contentPadding: const EdgeInsets.all(10.0),
            // border: InputBorder.none
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  widget.focusedBorderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? colorblue, width: 0.6),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  widget.enabledBorderRadius ?? BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: widget.enabledOutlineInputBorderColor ?? colorgrey,
                  width: 0.8),
            ),
            border: widget.outlineInputBorder ??
                OutlineInputBorder(
                  borderRadius:
                      widget.enabledBorderRadius ?? BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: widget.outlineInputBorderColor ?? colorblue,
                      width: 0.6),
                ),
          ),
        ),
      ),
    );
  }
}
