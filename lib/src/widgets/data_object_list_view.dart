import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:group_list_view/group_list_view.dart';

class DataObjectListView<G, T extends DataObject> extends StatefulWidget {
  final ListController<G, T> controller;

  ///Optional: override the default build function for items
  ///
  ///Provides the default [onTap] and [onLongPress] callbacks
  ///and default [trailing] and [subtitle] widgets
  final ItemBuilder<T>? itemBuilder;

  ///The build function for groups
  ///
  ///Provides the default [onTap] and [onLongPress] callbacks
  ///and default [trailing] and [subtitle] widgets
  final GroupBuilder<G>? groupBuilder;

  ///Optional: override the default [onTap] callback
  final void Function(T)? onTap;

  ///Optional: override the default [onLongPress] callback
  final void Function(T)? onLongPress;

  ///Wether to dispose [controller] when the widget is disposed
  final bool autoDisposeController;

  ///Optional string to show when there are no items
  final String? emptyMsg;

  DataObjectListView({
    Key? key,
    required this.controller,
    this.itemBuilder,
    this.groupBuilder,
    this.onTap,
    this.onLongPress,
    this.emptyMsg,
    required this.autoDisposeController,
  })  : assert(isSubtype<void, G>() ||
            isSubtype<DataObject?, G>() ||
            groupBuilder != null),
        super(key: key);

  @override
  _DataObjectListViewState<G, T> createState() =>
      _DataObjectListViewState<G, T>();
}

class _DataObjectListViewState<G, T extends DataObject>
    extends State<DataObjectListView<G, T>>
    with AutomaticKeepAliveClientMixin<DataObjectListView<G, T>> {
  bool _builtOnce = false;

  ListController<G, T> get _controller => widget.controller;

  ItemBuilder<T> get _buildItem => widget.itemBuilder ?? defaultItemBuilder<T>;
  GroupBuilder<G> get _buildGroup =>
      widget.groupBuilder ??
      (
        G? o, {
        void Function(G)? onLongPress,
        void Function(G)? onTap,
        void Function()? onTapOnNull,
        bool? showSubtitle,
        Widget? trailing,
        Widget? subtitle,
      }) =>
          defaultGroupBuilder<DataObject>(
            o as DataObject?,
            onLongPress:
                onLongPress != null ? (o) => onLongPress(o as G) : null,
            onTap: onTap != null ? (o) => onTap(o as G) : null,
            onTapOnNull: onTapOnNull,
            showSubtitle: showSubtitle,
            trailing: trailing,
            subtitle: subtitle,
          );

  @override
  bool get wantKeepAlive => _builtOnce && ModalRoute.of(context)!.isCurrent;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _builtOnce = true;
    updateKeepAlive();

    return StreamBuilder<bool>(
      initialData: false,
      stream: _controller.groupingSubject
          .map((event) => event && G != Null)
          .distinct(),
      builder: (context, grouped) {
        if (grouped.hasError)
          return Center(
            child: ErrorWidget(grouped.error!),
          );

        if (!grouped.hasData)
          return const Center(child: CircularProgressIndicator());

        if (grouped.requireData) {
          return buildGroupedListView();
        } else {
          return buildListView();
        }
      },
    );
  }

  Widget buildGroupedListView() {
    return StreamBuilder<Map<G, List<T>>>(
      stream: _controller.groupedObjectsStream,
      builder: (context, groupedData) {
        if (groupedData.hasError) return ErrorWidget(groupedData.error!);

        if (!groupedData.hasData)
          return const Center(child: CircularProgressIndicator());

        if (groupedData.data!.isEmpty)
          return Center(child: Text(widget.emptyMsg ?? 'لا يوجد عناصر'));

        return GroupListView(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          sectionsCount: groupedData.data!.length + 1,
          countOfItemInSection: (i) {
            if (i == groupedData.data!.length) return 0;

            return groupedData.data!.values.elementAt(i).length;
          },
          cacheExtent: 500,
          groupHeaderBuilder: (context, i) {
            if (i == groupedData.data!.length)
              return Container(height: MediaQuery.of(context).size.height / 15);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: _buildGroup(
                groupedData.data!.keys.elementAt(i),
                onTap: (o) {
                  _controller.toggleGroup(
                    groupedData.data!.keys.elementAt(i),
                  );
                },
                onTapOnNull: () {
                  _controller.toggleGroup(
                    groupedData.data!.keys.elementAt(i),
                  );
                },
                trailing: IconButton(
                  onPressed: () {
                    _controller.toggleGroup(
                      groupedData.data!.keys.elementAt(i),
                    );
                  },
                  icon: Icon(
                    _controller.currentOpenedGroups!
                            .contains(groupedData.data!.keys.elementAt(i))
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ),
              ),
            );
          },
          itemBuilder: (context, i) {
            final T current =
                groupedData.data!.values.elementAt(i.section)[i.index];

            return Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 9, 0),
              child: buildItemWrapper(current),
            );
          },
        );
      },
    );
  }

  Widget buildListView() {
    return StreamBuilder<List<T>>(
      stream: _controller.objectsStream,
      builder: (context, data) {
        if (data.hasError) return Center(child: ErrorWidget(data.error!));
        if (!data.hasData)
          return const Center(child: CircularProgressIndicator());

        final List<T> _data = data.data!;
        if (_data.isEmpty)
          return Center(child: Text(widget.emptyMsg ?? 'لا يوجد عناصر'));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          addAutomaticKeepAlives: _data.length < 500,
          cacheExtent: 200,
          itemCount: _data.length + 1,
          itemBuilder: (context, i) {
            if (i == _data.length)
              return Container(
                height: MediaQuery.of(context).size.height / 19,
              );

            final T current = _data[i];
            return buildItemWrapper(current);
          },
        );
      },
    );
  }

  Widget buildItemWrapper(T current) {
    return StreamBuilder<Set<T>?>(
      stream: _controller.selectionStream,
      builder: (context, snapshot) {
        return _buildItem(
          current,
          onLongPress: widget.onLongPress ?? _defaultLongPress,
          onTap: (T current) async {
            if (_controller.currentSelection == null) {
              widget.onTap == null
                  ? GetIt.I<DefaultViewableObjectTapHandler>().onTap(current)
                  : widget.onTap!(current);
            } else {
              _controller.toggleSelected(current);
            }
          },
          trailing: snapshot.hasData
              ? Checkbox(
                  value: snapshot.data!.contains(current),
                  onChanged: (v) {
                    if (v!) {
                      _controller.select(current);
                    } else {
                      _controller.deselect(current);
                    }
                  },
                )
              : null,
        );
      },
    );
  }

  void _defaultLongPress(T current) async {
    if (_controller.currentSelection != null) {
      final currentSelection = _controller.currentSelection!;

      _controller.exitSelectionMode();

      if (currentSelection.isNotEmpty) {
        await GetIt.I<ShareService>().shareText(
          (await Future.wait(
            currentSelection
                .map((f) async =>
                    f.name +
                    ': ' +
                    (await GetIt.I<ShareService>().shareObject(f)).toString())
                .toList(),
          ))
              .join('\n'),
        );
      }
    } else {
      _controller.select(current);
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (widget.autoDisposeController) await _controller.dispose();
  }
}

typedef ItemBuilder<T> = Widget Function(
  T, {
  void Function(T)? onLongPress,
  void Function(T)? onTap,
  Widget? trailing,
  Widget? subtitle,
});

typedef GroupBuilder<G> = Widget Function(
  G?, {
  void Function(G)? onLongPress,
  void Function(G)? onTap,
  void Function()? onTapOnNull,
  bool? showSubtitle,
  Widget? trailing,
  Widget? subtitle,
});

Widget defaultItemBuilder<T extends DataObject>(
  T object, {
  void Function(T)? onLongPress,
  void Function(T)? onTap,
  Widget? trailing,
  Widget? subtitle,
}) =>
    ViewableObjectWidget<T>(
      object,
      subtitle: subtitle,
      onLongPress: onLongPress != null ? () => onLongPress(object) : null,
      onTap: onTap != null ? () => onTap(object) : null,
      trailing: trailing,
    );

Widget defaultGroupBuilder<G extends DataObject>(
  G? object, {
  void Function(G)? onLongPress,
  void Function(G)? onTap,
  void Function()? onTapOnNull,
  bool? showSubtitle,
  Widget? trailing,
  Widget? subtitle,
}) {
  if (object == null)
    return ListTile(
      title: const Text('غير محددة'),
      subtitle: showSubtitle ?? false ? subtitle : null,
      onTap:
          onTap != null && object != null ? () => onTap(object) : onTapOnNull,
      onLongPress: onLongPress != null && object != null
          ? () => onLongPress(object)
          : null,
      trailing: trailing,
    );

  return ViewableObjectWidget<G>(
    object,
    wrapInCard: false,
    showSubtitle: showSubtitle ?? false,
    subtitle: showSubtitle ?? false ? subtitle : null,
    onTap: onTap != null ? () => onTap(object) : null,
    onLongPress: onLongPress != null ? () => onLongPress(object) : null,
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing != null) trailing,
        IconButton(
          onPressed: () {
            GetIt.I<DefaultViewableObjectTapHandler>().onTap(object);
          },
          icon: const Icon(Icons.info_outlined),
        ),
      ],
    ),
  );
}
