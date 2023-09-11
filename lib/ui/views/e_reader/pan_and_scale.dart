// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';

// class PanAndScalingGestureRecognizer extends StatefulWidget {
//   final Widget child;
//   final void Function(Offset initialPoint) onPanStart;
//   final void Function(Offset initialPoint, Offset delta) onPanUpdate;
//   final void Function() onPanEnd;

//   final void Function(Offset initialFocusPoint) onScalingStart;
//   final void Function(Offset changedFocusPoint, double scale) onScalingUpdate;
//   final void Function() onScalingEnd;

//   const PanAndScalingGestureRecognizer({
//     super.key,
//     required this.child,
//     required this.onPanStart,
//     required this.onPanUpdate,
//     required this.onPanEnd,
//     required this.onScalingStart,
//     required this.onScalingUpdate,
//     required this.onScalingEnd,
//   });

//   @override
//   _PanAndScalingGestureRecognizerState createState() =>
//       _PanAndScalingGestureRecognizerState();
// }

// class _PanAndScalingGestureRecognizerState
//     extends State<PanAndScalingGestureRecognizer> {
//   final List<Touch> touches = [];
//   double initialScalingDistance = 0;

//   @override
//   Widget build(BuildContext context) {
//     return RawGestureDetector(
//       child: widget.child,
//       gestures: {
//         ImmediateMultiDragGestureRecognizer:
//             GestureRecognizerFactoryWithHandlers<
//                 ImmediateMultiDragGestureRecognizer>(
//           () => ImmediateMultiDragGestureRecognizer(),
//           (ImmediateMultiDragGestureRecognizer instance) {
//             instance.onStart = (Offset offset) {
//               final touch = Touch(
//                 offset,
//                 (drag, details) => _onTouchUpdate(drag., details),
//                 (drag, details) => _onTouchEnd(drag, details),
//               );
//               _onTouchStart(touch);
//               return touch;
//             };
//           },
//         ),
//       },
//     );
//   }

//   void _onTouchStart(Touch touch) {
//     touches.add(touch);
//     if (touches.length == 1) {
//       widget.onPanStart(touch.startOffset);
//     } else if (touches.length == 2) {
//       initialScalingDistance =
//           (touches[0].currentOffset - touches[1].currentOffset).distance;
//       widget.onScalingStart(
//           (touches[0].currentOffset + touches[1].currentOffset) / 2);
//     } else {
//       // Do nothing/ ignore
//     }
//   }

//   void _onTouchUpdate(Touch touch, DragUpdateDetails details) {
//     assert(touches.isNotEmpty);
//     touch.currentOffset = details.localPosition;

//     if (touches.length == 1) {
//       widget.onPanUpdate(
//         touch.startOffset,
//         details.localPosition - touch.startOffset,
//       );
//     } else {
//       // TODO average of ALL offsets, not only 2 first
//       var newDistance =
//           (touches[0].currentOffset - touches[1].currentOffset).distance;

//       widget.onScalingUpdate(
//         (touches[0].currentOffset + touches[1].currentOffset) / 2,
//         newDistance / initialScalingDistance,
//       );
//     }
//   }

//   void _onTouchEnd(Touch touch, DragEndDetails details) {
//     touches.remove(touch);
//     if (touches.length == 0) {
//       widget.onPanEnd();
//     } else if (touches.length == 1) {
//       widget.onScalingEnd();

//       // Restart pan
//       touches[0].startOffset = touches[0].currentOffset;
//       widget.onPanStart(touches[0].startOffset);
//     }
//   }
// }

// class Touch extends Drag {
//   Offset startOffset;
//   Offset currentOffset;
//   final void Function(Drag drag, DragUpdateDetails details) onUpdate;
//   final void Function(Drag drag, DragEndDetails details) onEnd;

//   Touch(this.startOffset, this.onUpdate, this.onEnd) {
//     currentOffset = startOffset;
//   }

//   @override
//   void update(DragUpdateDetails details) {
//     super.update(details);
//     onUpdate(this, details);
//   }

//   @override
//   void end(DragEndDetails details) {
//     super.end(details);
//     onEnd(this, details);
//   }
// }
