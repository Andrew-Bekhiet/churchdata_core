import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class CopiablePropertyWidget extends StatelessWidget {
  const CopiablePropertyWidget(
    this.propName,
    this.value, {
    super.key,
    this.showErrorIfEmpty = true,
    this.additionalOptions,
  });

  final String propName;
  final String? value;
  final bool showErrorIfEmpty;
  final List<Widget>? additionalOptions;

  @override
  Widget build(BuildContext context) {
    final Widget? copyOrError;
    if (value != null && value!.isNotEmpty) {
      copyOrError = IconButton(
        icon: const Icon(Icons.copy),
        tooltip: 'نسخ',
        onPressed: () => Clipboard.setData(ClipboardData(text: value)),
      );
    } else if (showErrorIfEmpty) {
      copyOrError = const Tooltip(
        message: 'بيانات غير كاملة',
        child: Icon(Icons.warning),
      );
    } else {
      copyOrError = null;
    }

    final Widget? trailing;
    if (additionalOptions != null) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (copyOrError != null) copyOrError,
          ...additionalOptions!,
        ],
      );
    } else {
      trailing = copyOrError;
    }

    return ListTile(
      title: Text(propName),
      subtitle: value != null ? Text(value!) : null,
      trailing: trailing,
    );
  }
}

class PhoneNumberProperty extends StatelessWidget {
  const PhoneNumberProperty(
      this.propName, this.value, this.phoneCall, this.contactAdd,
      {super.key, this.showErrorIfEmpty = true});

  final bool showErrorIfEmpty;
  final String propName;
  final String? value;
  final void Function(String?) phoneCall;
  final void Function(String?) contactAdd;

  @override
  Widget build(BuildContext context) {
    final Widget? trailing;
    if (value != null && value!.isNotEmpty) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.phone),
            tooltip: 'اجراء مكالمة',
            onPressed: () => phoneCall(value),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            tooltip: 'اضافة الى جهات الاتصال',
            onPressed: () => contactAdd(value),
          ),
          IconButton(
            icon: Image.asset(
              'assets/whatsapp.png',
              package: 'churchdata_core',
              width: IconTheme.of(context).size,
              height: IconTheme.of(context).size,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: 'ارسال رسالة (واتساب)',
            onPressed: () => GetIt.I<LauncherService>()
                .launchWhatsappChat(formatPhone(value!)),
          ),
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'SMS',
                child: Text('ارسال رسالة'),
              ),
              PopupMenuItem(
                value: 'Copy',
                child: Text('نسخ'),
              ),
            ],
            onSelected: (v) {
              if (v == 'SMS') {
                GetIt.I<LauncherService>()
                    .launchSMSChat(formatPhone(value!, false));
              } else if (v == 'Copy') {
                Clipboard.setData(ClipboardData(text: value));
              }
            },
          ),
        ],
      );
    } else if (showErrorIfEmpty) {
      trailing = const Tooltip(
        message: 'بيانات غير كاملة',
        child: Icon(Icons.warning),
      );
    } else {
      trailing = null;
    }

    return ListTile(
      title: Text(propName),
      subtitle: value != null ? Text(value!) : null,
      trailing: trailing,
    );
  }
}
