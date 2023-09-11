import 'package:flutter/material.dart';

class PinchZooming extends StatefulWidget {
  final Widget child;
  final double maxScale, minScale;
  final Duration resetDuration;
  final bool zoomEnabled;
  final Function? onZoomStart, onZoomEnd;

  const PinchZooming({
    Key? key,
    required this.child,
    this.resetDuration = const Duration(milliseconds: 100),
    this.maxScale = 4.0,
    this.minScale = 1.0,
    this.zoomEnabled = true,
    this.onZoomStart,
    this.onZoomEnd,
  })  : assert(maxScale != 0 && minScale != 0 && maxScale > minScale,
            'Either min or max scale value equal zero or max scale is less than min scale'),
        super(key: key);
  @override
  State<PinchZooming> createState() => _PinchZoomingState();
}

class _PinchZoomingState extends State<PinchZooming>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();

  late Animation<Matrix4> _animation;

  late AnimationController _controller;

  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.resetDuration,
      vsync: this,
    );
    _animation = Matrix4Tween().animate(_controller);
    _controller
        .addListener(() => _transformationController.value = _animation.value);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    removeOverlay();
    _entry = OverlayEntry(
      builder: (c) => Stack(
        children: [
          Positioned.fill(
              child:
                  Opacity(opacity: 0.5, child: Container(color: Colors.black))),
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: InteractiveViewer(
              minScale: widget.minScale,
              clipBehavior: Clip.none,
              scaleEnabled: widget.zoomEnabled,
              maxScale: widget.maxScale,
              panEnabled: false,
              onInteractionStart: (ScaleStartDetails details) {
                if (details.pointerCount < 2) return;
                if (_entry == null) {
                  showOverlay(context);
                }
              },
              onInteractionEnd: (_) => restAnimation(),
              transformationController: _transformationController,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
    final OverlayState overlay = Overlay.of(context);
    overlay.insert(_entry!);
  }

  void removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void restAnimation() {
    _animation = Matrix4Tween(
            begin: _transformationController.value, end: Matrix4.identity())
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInBack));
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      minScale: widget.minScale,
      scaleEnabled: widget.zoomEnabled,
      maxScale: widget.maxScale,
      constrained: true,
      panEnabled: false,
      onInteractionStart: (ScaleStartDetails details) {
        if (details.pointerCount < 2) return;
        if (_entry == null) {
          showOverlay(context);
        }
        if (widget.onZoomStart != null) {
          widget.onZoomStart!();
        }
      },
      onInteractionUpdate: (details) {
        if (_entry == null) return;
        _entry!.markNeedsBuild();
      },
      onInteractionEnd: (details) {
        if (details.pointerCount != 1) return;
        restAnimation();
        if (widget.onZoomEnd != null) {
          widget.onZoomEnd!();
        }
      },
      transformationController: _transformationController,
      child: widget.child,
    );
  }
}
