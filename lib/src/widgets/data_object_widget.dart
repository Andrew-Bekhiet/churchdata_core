import 'package:async/async.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ViewableObjectWidget<T extends Viewable> extends StatefulWidget {
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

  const ViewableObjectWidget(
    this.object, {
    super.key,
    this.isDense = false,
    this.onLongPress,
    this.onTap,
    this.trailing,
    this.subtitle,
    this.title,
    this.wrapInCard = true,
    this.photo,
    this.showSubtitle = true,
  });

  @override
  State<ViewableObjectWidget<T>> createState() =>
      _ViewableObjectWidgetState<T>();
}

class _ViewableObjectWidgetState<T extends Viewable>
    extends State<ViewableObjectWidget<T>> {
  final _secondLineMemoizer = AsyncMemoizer<String?>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textColor = ListTileTheme.of(context).textColor ??
        themeData.listTileTheme.textColor ??
        themeData.textTheme.subtitle1!.color!;
    final foregroundColor = widget.object.color.getContrastingColor(textColor);

    final Widget tile = ListTile(
      iconColor: foregroundColor,
      textColor: foregroundColor,
      tileColor: widget.wrapInCard ? null : widget.object.color,
      dense: widget.isDense,
      onLongPress: widget.onLongPress,
      onTap: widget.onTap ??
          () => GetIt.I<DefaultViewableObjectService>().onTap(widget.object),
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
            color: widget.object.color,
            child: tile,
          )
        : tile;
  }
}
