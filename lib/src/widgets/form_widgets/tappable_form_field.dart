import 'dart:async';

import 'package:flutter/material.dart';

class TappableFormField<T> extends StatefulWidget {
  const TappableFormField({
    super.key,
    required this.initialValue,
    required this.onTap,
    this.labelText,
    required this.builder,
    this.decoration,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.focusNode,
  }) : assert(labelText != null || decoration != null);

  final T initialValue;
  final FutureOr<void> Function(FormFieldState<T>) onTap;
  final String? labelText;
  final Widget? Function(BuildContext, FormFieldState<T>) builder;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;
  final InputDecoration Function(BuildContext, FormFieldState<T>)? decoration;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  @override
  State<TappableFormField<T>> createState() => _TappableFormFieldState<T>();
}

class _TappableFormFieldState<T> extends State<TappableFormField<T>> {
  late final FocusNode _focusNode = widget.focusNode ??
      Focus.maybeOf(context) ??
      FocusNode(debugLabel: 'TappableFormField<$T>:${widget.labelText}');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormField<T>(
        autovalidateMode: widget.autovalidateMode,
        initialValue: widget.initialValue,
        builder: (state) => InkWell(
          focusNode: _focusNode,
          onTap: () async {
            _focusNode.requestFocus();

            final previousValue = state.value;

            await widget.onTap(state);

            if (state.value != previousValue) _focusNode.nextFocus();
          },
          child: AnimatedBuilder(
            animation: _focusNode,
            child: widget.builder(context, state),
            builder: (context, child) => InputDecorator(
              isFocused: _focusNode.hasFocus,
              decoration: widget.decoration != null
                  ? widget.decoration!(context, state)
                  : InputDecoration(
                      errorText: state.errorText,
                      labelText: widget.labelText,
                    ),
              isEmpty: state.value == null,
              child: child,
            ),
          ),
        ),
        onSaved: widget.onSaved,
        validator: widget.validator ??
            (value) => value == null ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if ((widget.focusNode ?? Focus.maybeOf(context)) == null)
      _focusNode.dispose();
  }
}
