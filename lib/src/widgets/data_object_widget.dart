import 'package:async/async.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tinycolor2/tinycolor2.dart';

class DataObjectWidget<T extends DataObject> extends StatelessWidget {
  final T object;

  final void Function()? onLongPress;
  final void Function()? onTap;
  final Widget? trailing;
  final Widget? photo;
  final Widget? subtitle;
  final Widget? title;
  final bool wrapInCard;
  final bool isDense;
  final bool showSubtitle;

  final _secondLineMemoizer = AsyncMemoizer<String?>();

  DataObjectWidget(
    this.object, {
    Key? key,
    this.isDense = false,
    this.onLongPress,
    this.onTap,
    this.trailing,
    this.subtitle,
    this.title,
    this.wrapInCard = true,
    this.photo,
    this.showSubtitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget tile = ListTile(
      tileColor: wrapInCard ? null : _getColor(context),
      dense: isDense,
      onLongPress: onLongPress,
      onTap:
          onTap ?? () => GetIt.I<DefaultDataObjectTapHandler>().onTap(object),
      trailing: trailing,
      title: title ?? Text(object.name),
      subtitle: showSubtitle
          ? subtitle ??
              FutureBuilder<String?>(
                future: _secondLineMemoizer.runOnce(object.getSecondLine),
                builder: (cont, subtitleData) {
                  if (subtitleData.hasData) {
                    return Text(
                      subtitleData.data!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  } else if (subtitleData.connectionState !=
                      ConnectionState.done) {
                    return LinearProgressIndicator(
                      backgroundColor: object.color,
                      valueColor: AlwaysStoppedAnimation(object.color),
                    );
                  }
                  return const SizedBox(height: 1, width: 1);
                },
              )
          : null,
      leading: photo ??
          (object is PhotoObjectBase
              ? PhotoObjectWidget(
                  object as PhotoObjectBase,
                  circleCrop: object is PersonBase,
                )
              : null),
    );
    return wrapInCard
        ? Card(
            color: _getColor(context),
            child: tile,
          )
        : tile;
  }

  Color? _getColor(BuildContext context) {
    if (object.color == null || object.color == Colors.transparent) return null;

    if (object.color!.brightness > 170 &&
        Theme.of(context).brightness == Brightness.dark) {
      //refers to the contrasted text theme color
      return object.color!
          .darken(((265 - object.color!.brightness) / 255 * 100).toInt());
    } else if (object.color!.brightness < 85 &&
        Theme.of(context).brightness == Brightness.light) {
      return object.color!
          .lighten(((265 - object.color!.brightness) / 255 * 100).toInt());
    }
    return object.color;
  }
}
