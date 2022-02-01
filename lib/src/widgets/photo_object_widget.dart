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
    Key? key,
    this.circleCrop = true,
    this.heroTag,
    this.constraints,
  }) : super(key: key);

  @override
  _PhotoObjectWidgetState createState() => _PhotoObjectWidgetState();
}

class _PhotoObjectWidgetState extends State<PhotoObjectWidget> {
  bool disposed = false;

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

        if (!widget.object.hasPhoto)
          return Icon(widget.object.defaultIcon, size: constraints.maxHeight);

        return Hero(
          tag: widget.heroTag ?? widget.object.photoRef!.fullPath,
          child: ConstrainedBox(
            constraints: constraints,
            child: FutureBuilder<String>(
              future: widget.object.photoUrlCache.runOnce(
                () => widget.object.photoRef!.getCachedDownloadUrl(
                  onCacheChanged: (cache, newUrl) async {
                    await (GetIt.I.isRegistered<BaseCacheManager>()
                            ? GetIt.I<BaseCacheManager>()
                            : DefaultCacheManager())
                        .removeFile(cache);

                    widget.object.photoUrlCache.invalidate();

                    if (mounted && !disposed) setState(() {});
                  },
                  onError: (exception, cache) async {
                    if (cache != null)
                      await (GetIt.I.isRegistered<BaseCacheManager>()
                              ? GetIt.I<BaseCacheManager>()
                              : DefaultCacheManager())
                          .removeFile(cache);

                    widget.object.photoUrlCache.invalidate();

                    if (mounted && !disposed) setState(() {});
                  },
                ),
              ),
              builder: (context, data) {
                if (data.hasError)
                  return Center(child: ErrorWidget(data.error!));

                if (!data.hasData)
                  return AspectRatio(
                    aspectRatio: constraints.biggest.aspectRatio,
                    child: const CircularProgressIndicator(),
                  );

                if (data.data == '')
                  return Icon(
                    widget.object.defaultIcon,
                    size: constraints.maxHeight,
                  );

                final photo = Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => Dialog(
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
                              imageUrl: data.data!,
                              progressIndicatorBuilder:
                                  (context, url, progress) => AspectRatio(
                                aspectRatio: constraints.biggest.aspectRatio,
                                child: CircularProgressIndicator(
                                  value: progress.progress,
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
                      imageUrl: data.data!,
                      progressIndicatorBuilder: (context, url, progress) =>
                          AspectRatio(
                        aspectRatio: constraints.biggest.aspectRatio,
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
}
