import 'package:flutter/material.dart';

/// RemoteFoodImage
/// - primaryImageUrl: optional direct image URL from your API
/// - query: used to generate provider URLs (category/name like "pizza")
/// - width/height/fit: visual params
class RemoteFoodImage extends StatefulWidget {
  final String? primaryImageUrl;
  final String query;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RemoteFoodImage({
    Key? key,
    this.primaryImageUrl,
    required this.query,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<RemoteFoodImage> createState() => _RemoteFoodImageState();
}

class _RemoteFoodImageState extends State<RemoteFoodImage> {
  late final List<String> _providers;
  int _attempt = 0;

  @override
  void initState() {
    super.initState();

    final q = Uri.encodeComponent(widget.query.trim());

    // order of tries: primary API image (if provided) -> Unsplash source -> LoremFlickr -> Picsum
    _providers = [
      if (widget.primaryImageUrl != null && widget.primaryImageUrl!.isNotEmpty)
        widget.primaryImageUrl!,
      // Unsplash source (may redirect to an image)
      'https://source.unsplash.com/400x300/?$q',
      // LoremFlickr (stable)
      'https://loremflickr.com/400/300/$q',
      // Picsum seeded image (guaranteed)
      'https://picsum.photos/seed/$q/400/300',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final url = _providers[_attempt];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        key: ValueKey(url + '::$_attempt'),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        // show a simple loader while image is coming
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            ),
          );
        },
        // on error, try next provider or finally show local placeholder
        errorBuilder: (context, error, stackTrace) {
          if (_attempt < _providers.length - 1) {
            // defer setState to after this frame to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _attempt++);
            });
            // show a small loader while we retry
            return SizedBox(
              width: widget.width,
              height: widget.height,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          // final fallback: local asset placeholder
          return Image.asset(
            'assets/images/placeholder.png',
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        },
      ),
    );
  }
}
