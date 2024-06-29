import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

typedef DataObjectListView<G, T extends ViewableWithID>
    = DataObjectListViewBase<G, T>;

class DataObjectListViewBase<G, T extends ViewableWithID>
    extends StatefulWidget {
  final ListControllerBase<G, T> controller;

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

  final ScrollController? scrollController;

  DataObjectListViewBase({
    super.key,
    bool changeVisibilityUpdateInterval = true,
    required this.controller,
    this.itemBuilder,
    this.groupBuilder,
    this.onTap,
    this.onLongPress,
    this.emptyMsg,
    this.scrollController,
    required this.autoDisposeController,
  }) : assert(isSubtype<void, G>() ||
            isSubtype<DataObject?, G>() ||
            groupBuilder != null) {
    if (changeVisibilityUpdateInterval)
      VisibilityDetectorController.instance.updateInterval =
          const Duration(seconds: 1, milliseconds: 500);
  }

  @override
  _DataObjectListViewBaseState<G, T> createState() =>
      _DataObjectListViewBaseState<G, T>();
}

class _DataObjectListViewBaseState<G, T extends ViewableWithID>
    extends State<DataObjectListViewBase<G, T>>
    with AutomaticKeepAliveClientMixin<DataObjectListViewBase<G, T>> {
  bool _builtOnce = false;

  ListControllerBase<G, T> get _controller => widget.controller;

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
          defaultGroupBuilder<ViewableWithID>(
            o as ViewableWithID?,
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

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(() {
      if (_controller.canPaginateForward &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
        _controller.loadNextPage();
      } else if (_controller.canPaginateBackward &&
          _scrollController.position.pixels <=
              _scrollController.position.minScrollExtent) {
        _controller.loadPreviousPage();
      }
    });
  }

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          sectionsCount: groupedData.data!.length + 1,
          countOfItemInSection: (i) {
            if (i == groupedData.data!.length) return 0;

            return groupedData.data!.values.elementAt(i).length;
          },
          cacheExtent: 500,
          groupHeaderBuilder: (context, i) {
            if (i == groupedData.data!.length)
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.isLoading)
                    const Center(child: CircularProgressIndicator()),
                  Container(height: MediaQuery.of(context).size.height / 15),
                ],
              );

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
              child: buildItemWrapper(current, i.index, i.section),
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          addAutomaticKeepAlives: _data.length < 500,
          cacheExtent: 200,
          itemCount: _data.length + 1,
          itemBuilder: (context, i) {
            if (i == _data.length)
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.isLoading)
                    const Center(child: CircularProgressIndicator()),
                  Container(
                    height: MediaQuery.of(context).size.height / 19,
                  ),
                ],
              );

            final T current = _data[i];
            return buildItemWrapper(current, i);
          },
        );
      },
    );
  }

  Widget buildItemWrapper(T current, int index, [int? section]) {
    return StreamBuilder<Set<T>?>(
      stream: _controller.selectionStream,
      builder: (context, snapshot) {
        return VisibilityDetector(
          key: ValueKey(current),
          onVisibilityChanged: (v) =>
              _onItemVisibilityChanged(v, index, section),
          child: _buildItem(
            current,
            onLongPress: widget.onLongPress ?? _defaultLongPress,
            onTap: (T current) async {
              if (_controller.currentSelection == null) {
                widget.onTap == null
                    ? GetIt.I<DefaultViewableObjectService>().onTap(current)
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
          ),
        );
      },
    );
  }

  void _onItemVisibilityChanged(VisibilityInfo v, int index, [int? section]) {
    if (v.visibleFraction >= 0.9)
      _controller.ensureItemPageLoaded(index, section);
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
    if (widget.scrollController == null) _scrollController.dispose();
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

Widget defaultItemBuilder<T extends ViewableWithID>(
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

Widget defaultGroupBuilder<G extends ViewableWithID>(
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
            GetIt.I<DefaultViewableObjectService>().onTap(object);
          },
          icon: const Icon(Icons.info_outlined),
        ),
      ],
    ),
  );
}
