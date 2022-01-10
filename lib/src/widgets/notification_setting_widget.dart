import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

///Widget for controlling a periodic notification settings
///
///An example use case would be birthday notifications that
///appears every day
class NotificationSettingWidget extends StatefulWidget {
  final String label;
  final String hiveKey;
  final int alarmId;
  final Function notificationCallback;

  const NotificationSettingWidget({
    Key? key,
    required this.label,
    required this.hiveKey,
    required this.alarmId,
    required this.notificationCallback,
  }) : super(key: key);

  @override
  _NotificationSettingWidgetState createState() =>
      _NotificationSettingWidgetState();
}

class _NotificationSettingWidgetState extends State<NotificationSettingWidget> {
  int multiplier = 1;
  late final TextEditingController periodTextController;
  late final NotificationSetting setting;
  late TimeOfDay time;

  final nSettingsBox = GetIt.I<CacheRepository>()
      .box<NotificationSetting>('NotificationsSettings');

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: widget.label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 45,
            child: TextField(
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              keyboardType: TextInputType.number,
              controller: periodTextController,
            ),
          ),
          Container(width: 20),
          Flexible(
            flex: 25,
            child: DropdownButtonFormField<DateType>(
              items: const [
                DropdownMenuItem(
                  value: DateType.day,
                  child: Text('يوم'),
                ),
                DropdownMenuItem(
                  value: DateType.week,
                  child: Text('أسبوع'),
                ),
                DropdownMenuItem(
                  value: DateType.month,
                  child: Text('شهر'),
                )
              ],
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
              ),
              value: _getAndSetMultiplier(
                setting.intervalInDays,
              ),
              onSaved: (_) => onSave(),
              onChanged: (value) async {
                if (value == DateType.month) {
                  multiplier = 30;
                } else if (value == DateType.week) {
                  multiplier = 7;
                } else if (value == DateType.day) {
                  multiplier = 1;
                }
              },
            ),
          ),
          Container(width: 20),
          Flexible(
            flex: 25,
            child: TappableFormField<TimeOfDay>(
              decoration: (context, state) => InputDecoration(
                errorText: state.errorText,
                border: InputBorder.none,
              ),
              initialValue: time,
              onTap: (state) async {
                final selected = await showTimePicker(
                  context: context,
                  initialTime: state.value!,
                );

                if (selected == null) return;

                state.didChange(
                  time =
                      TimeOfDay(hour: selected.hour, minute: selected.minute),
                );
              },
              builder: (context, state) => Text(
                DateFormat(
                  'h:m' +
                      (MediaQuery.of(context).alwaysUse24HourFormat
                          ? ''
                          : ' a'),
                  'ar-EG',
                ).format(
                  DateTime.now().replaceTimeOfDay(state.value!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    setting = nSettingsBox.get(
      widget.hiveKey,
      defaultValue: const NotificationSetting(11, 0, 7),
    )!;

    time = TimeOfDay(
      hour: setting.hours,
      minute: setting.minutes,
    );

    periodTextController = TextEditingController(
      text: _totalDays(setting.intervalInDays).toString(),
    );
  }

  void onSave() async {
    final current = nSettingsBox.get(widget.hiveKey,
        defaultValue: const NotificationSetting(11, 0, 7))!;

    if (current.intervalInDays ==
            int.parse(periodTextController.text) * multiplier &&
        current.hours == time.hour &&
        current.minutes == time.minute) return;

    await nSettingsBox.put(
      widget.hiveKey,
      NotificationSetting(
        time.hour,
        time.minute,
        int.parse(periodTextController.text) * multiplier,
      ),
    );

    await GetIt.I<NotificationsService>().schedulePeriodic(
      Duration(days: int.parse(periodTextController.text) * multiplier),
      widget.alarmId,
      widget.notificationCallback,
      exact: true,
      startAt: DateTime.now().replaceTimeOfDay(time),
      rescheduleOnReboot: true,
    );
  }

  DateType _getAndSetMultiplier(int days) {
    if (days % 30 == 0) {
      multiplier = 30;
      return DateType.month;
    } else if (days % 7 == 0) {
      multiplier = 7;
      return DateType.week;
    }
    multiplier = 1;
    return DateType.day;
  }

  static int _totalDays(int days) {
    if (days % 30 == 0) {
      return days ~/ 30;
    } else if (days % 7 == 0) {
      return days ~/ 7;
    }
    return days;
  }
}

enum DateType {
  month,
  week,
  day,
}
