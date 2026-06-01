import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/app_colors.dart';
import '../../../../config/app_radius.dart';
import '../../../../config/app_spacing.dart';
import '../../../../config/app_text_styles.dart';

class OtpCodeBoxes extends StatefulWidget {
  const OtpCodeBoxes({
    super.key,
    this.validator,
    this.onChanged,
    this.onCompleted,
  });

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpCodeBoxes> createState() => _OtpCodeBoxesState();
}

class _OtpCodeBoxesState extends State<OtpCodeBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  String get _code => _controllers.map((controller) => controller.text).join();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String value, FormFieldState<String> field) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      _fillFrom(index, digits, field);
      return;
    }

    final digit = digits;
    if (_controllers[index].text != digit) {
      _controllers[index]
        ..text = digit
        ..selection = TextSelection.collapsed(offset: digit.length);
    }

    field.didChange(_code);
    widget.onChanged?.call(_code);

    if (digit.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_code.length == 6) {
      _focusNodes[index].unfocus();
      widget.onCompleted?.call(_code);
    }
  }

  void _fillFrom(int startIndex, String digits, FormFieldState<String> field) {
    var digitIndex = 0;
    for (
      var boxIndex = startIndex;
      boxIndex < _controllers.length && digitIndex < digits.length;
      boxIndex++, digitIndex++
    ) {
      final digit = digits[digitIndex];
      _controllers[boxIndex]
        ..text = digit
        ..selection = const TextSelection.collapsed(offset: 1);
    }

    field.didChange(_code);
    widget.onChanged?.call(_code);

    final nextIndex = (startIndex + digitIndex).clamp(
      0,
      _focusNodes.length - 1,
    );
    if (_code.length == 6) {
      _focusNodes[nextIndex].unfocus();
      widget.onCompleted?.call(_code);
    } else {
      _focusNodes[nextIndex].requestFocus();
    }
  }

  KeyEventResult _handleKeyEvent(
    int index,
    KeyEvent event,
    FormFieldState<String> field,
  ) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace ||
        _controllers[index].text.isNotEmpty ||
        index == 0) {
      return KeyEventResult.ignored;
    }

    _focusNodes[index - 1].requestFocus();
    _controllers[index - 1].clear();
    field.didChange(_code);
    widget.onChanged?.call(_code);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var index = 0; index < _controllers.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: Focus(
                        onKeyEvent: (_, event) =>
                            _handleKeyEvent(index, event, field),
                        child: _OtpBox(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          hasError: field.hasError,
                          textInputAction: index == _controllers.length - 1
                              ? TextInputAction.done
                              : TextInputAction.next,
                          onChanged: (value) =>
                              _handleChanged(index, value, field),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (field.hasError) ...[
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  field.errorText!,
                  style: AppTextStyles.textXsMedium.copyWith(
                    color: AppColors.error500,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.textInputAction,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        onChanged: onChanged,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.indigo500,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(
              color: hasError ? AppColors.error500 : AppColors.gray200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(
              color: hasError ? AppColors.error500 : AppColors.indigo500,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(color: AppColors.error500),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(color: AppColors.error500, width: 1.5),
          ),
        ),
      ),
    );
  }
}
