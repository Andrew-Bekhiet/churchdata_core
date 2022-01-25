import 'package:async/async.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tinycolor2/tinycolor2.dart';

class DataObjectWidget<T extends DataObject> extends StatefulWidget {
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

  const DataObjectWidget(
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
  State<DataObjectWidget<T>> createState() => _DataObjectWidgetState<T>();
}

class _DataObjectWidgetState<T extends DataObject>
    extends State<DataObjectWidget<T>> {
  final _secondLineMemoizer = AsyncMemoizer<String?>();

  @override
  Widget build(BuildContext context) {
    final Widget tile = ListTile(
      tileColor: widget.wrapInCard ? null : _getColor(context),
      dense: widget.isDense,
      onLongPress: widget.onLongPress,
      onTap: widget.onTap ??
          () => GetIt.I<DefaultDataObjectTapHandler>().onTap(widget.object),
      trailing: widget.trailing,
      title: widget.title ?? Text(widget.object.name),
      subtitle: widget.showSubtitle
          ? widget.subtitle ??
              FutureBuilder<String?>(
                future:
                    _secondLineMemoizer.runOnce(widget.object.getSecondLine),
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
                      backgroundColor: widget.object.color,
                      valueColor: AlwaysStoppedAnimation(widget.object.color),
                    );
                  }
                  return const SizedBox(height: 1, width: 1);
                },
              )
          : null,
      leading: widget.photo ??
          (widget.object is PhotoObjectBase
              ? PhotoObjectWidget(
                  widget.object as PhotoObjectBase,
                  circleCrop: widget.object is PersonBase,
                )
              : null),
    );
    return widget.wrapInCard
        ? Card(
            color: _getColor(context),
            child: tile,
          )
        : tile;
  }

  Color? _getColor(BuildContext context) {
    if (widget.object.color == null ||
        widget.object.color == Colors.transparent) return null;

    if (widget.object.color!.brightness > 170 &&
        Theme.of(context).brightness == Brightness.dark) {
      //refers to the contrasted text theme color
      return widget.object.color!.darken(
          ((265 - widget.object.color!.brightness) / 255 * 100).toInt());
    } else if (widget.object.color!.brightness < 85 &&
        Theme.of(context).brightness == Brightness.light) {
      return widget.object.color!.lighten(
          ((265 - widget.object.color!.brightness) / 255 * 100).toInt());
    }
    return widget.object.color;
  }
}
