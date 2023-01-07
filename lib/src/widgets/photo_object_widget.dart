import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';

///Creates `Image` from IPhotoObject
class PhotoObjectWidget extends StatefulWidget {
  ///The object to get photo from
  final PhotoObjectBase object;

  ///Whether to crop the image to circle or not (useful for person photos)
  final bool circleCrop;

  ///Optional `heroTag` to prevent conflicts with other `PhotoObjectWidget`s
  ///
  ///By default the heroTag will be the fullPath of the photo reference
  final Object? heroTag;

  ///If no constraints are specified the widget will
  ///expand to maximum height allowed by its parent
  final BoxConstraints? constraints;

  const PhotoObjectWidget(
    this.object, {
    super.key,
    this.circleCrop = true,
    this.heroTag,
    this.constraints,
  });

  @override
  _PhotoObjectWidgetState createState() => _PhotoObjectWidgetState();
}

class _PhotoObjectWidgetState extends State<PhotoObjectWidget> {
  bool disposed = false;
  bool error = false;

  int _retries = 0;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, parentConstraints) {
        final BoxConstraints constraints = widget.constraints ??
            BoxConstraints.expand(
              height: parentConstraints.maxHeight,
              width: parentConstraints.maxHeight,
            );

        if (!widget.object.hasPhoto || error)
          return Icon(widget.object.defaultIcon, size: constraints.maxHeight);

        return Hero(
          tag: widget.heroTag ?? widget.object.photoRef!.fullPath,
          child: ConstrainedBox(
            constraints: constraints,
            child: FutureBuilder<String>(
              initialData: widget.object.photoUrlCache.cachedResult,
              future: widget.object.photoUrlCache.runOnce(
                () => widget.object.photoRef!.getCachedDownloadUrl(
                  onCacheChanged: (cache, newUrl) async {
                    await widget.object.photoRef!.deleteCache();

                    widget.object.photoUrlCache.invalidate();

                    if (mounted && !disposed) setState(() {});
                  },
                  onError: _onUrlError,
                ),
              ),
              builder: (context, data) {
                if (data.hasError)
                  return Center(child: ErrorWidget(data.error!));

                final imageUrl =
                    data.data ?? widget.object.photoUrlCache.cachedResult;

                if (imageUrl == null)
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                if (imageUrl == '')
                  return Icon(
                    widget.object.defaultIcon,
                    size: constraints.maxHeight,
                  );

                final photo = Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierDismissible: true,
                        barrierColor: Colors.black45,
                        pageBuilder: (context, _, __) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Hero(
                            tag: widget.heroTag ??
                                widget.object.photoRef!.fullPath,
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                cacheManager:
                                    GetIt.I.isRegistered<BaseCacheManager>()
                                        ? GetIt.I<BaseCacheManager>()
                                        : null,
                                useOldImageOnUrlChange: true,
                                imageUrl: imageUrl!,
                                errorWidget: (context, url, error) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    _onUrlError(error, url);
                                  });

                                  return Icon(
                                    widget.object.defaultIcon,
                                    size: constraints.maxHeight,
                                  );
                                },
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: GetIt.I.isRegistered<BaseCacheManager>()
                          ? GetIt.I<BaseCacheManager>()
                          : null,
                      fadeInDuration: Duration.zero,
                      useOldImageOnUrlChange: true,
                      fadeOutDuration: Duration.zero,
                      memCacheHeight: (constraints.maxHeight *
                              MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                      imageUrl: imageUrl!,
                      errorWidget: (context, url, error) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          _onUrlError(error, url);
                        });

                        return Icon(
                          widget.object.defaultIcon,
                          size: constraints.maxHeight,
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
                  ),
                );

                return widget.circleCrop
                    ? ClipOval(
                        child: photo,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: photo,
                      );
              },
            ),
          ),
        );
      },
    );
  }

  void _onUrlError(exception, cache) async {
    if (cache != null) await widget.object.photoRef!.deleteCache();

    error = true;

    if (_retries <= 5) {
      _retries += 1;

      widget.object.photoUrlCache.invalidate();

      if (mounted && !disposed) setState(() {});
    }
  }
}
