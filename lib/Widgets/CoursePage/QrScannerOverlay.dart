import 'package:flutter/material.dart';

/// Widget overlay untuk QR Scanner dengan frame scanning yang cantik
class QrScannerOverlay extends StatelessWidget {
  const QrScannerOverlay({
    Key? key,
    this.borderColor = Colors.white,
    this.borderWidth = 8.0,
    this.borderLength = 30.0,
    this.borderRadius = 16.0,
    this.cutOutSize = 250.0,
    this.overlayColor,
  }) : super(key: key);

  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: borderColor,
          borderRadius: borderRadius,
          borderLength: borderLength,
          borderWidth: borderWidth,
          cutOutSize: cutOutSize,
          overlayColor: overlayColor ?? Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// Custom shape untuk QR Scanner overlay
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    required this.borderColor,
    required this.borderWidth,
    required this.borderLength,
    required this.borderRadius,
    required this.cutOutSize,
    required this.overlayColor,
  });

  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;
  final Color overlayColor;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(rect.left, rect.top, rect.left + borderRadius, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final cutOutWidth = cutOutSize < width ? cutOutSize : width - borderWidth;
    final cutOutHeight = cutOutSize < height ? cutOutSize : height - borderWidth;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
      rect.left + (width - cutOutWidth) / 2 + borderWidth,
      rect.top + (height - cutOutHeight) / 2 + borderWidth,
      cutOutWidth - borderWidth * 2,
      cutOutHeight - borderWidth * 2,
    );

    // Background overlay dengan cutout di tengah
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()
          ..addRRect(RRect.fromRectAndRadius(
            cutOutRect, 
            Radius.circular(borderRadius)
          ))
          ..close(),
      ),
      backgroundPaint,
    );

    // Corner borders (sudut-sudut frame)
    final cornerPath = Path()
      // Top left corner
      ..moveTo(cutOutRect.left - borderLength, cutOutRect.top)
      ..lineTo(cutOutRect.left, cutOutRect.top)
      ..lineTo(cutOutRect.left, cutOutRect.top + borderLength)
      // Top right corner
      ..moveTo(cutOutRect.right + borderLength, cutOutRect.top)
      ..lineTo(cutOutRect.right, cutOutRect.top)
      ..lineTo(cutOutRect.right, cutOutRect.top + borderLength)
      // Bottom right corner
      ..moveTo(cutOutRect.right, cutOutRect.bottom - borderLength)
      ..lineTo(cutOutRect.right, cutOutRect.bottom)
      ..lineTo(cutOutRect.right - borderLength, cutOutRect.bottom)
      // Bottom left corner
      ..moveTo(cutOutRect.left + borderLength, cutOutRect.bottom)
      ..lineTo(cutOutRect.left, cutOutRect.bottom)
      ..lineTo(cutOutRect.left, cutOutRect.bottom - borderLength);

    canvas.drawPath(cornerPath, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderLength: borderLength,
      borderRadius: borderRadius,
      cutOutSize: cutOutSize,
      overlayColor: overlayColor,
    );
  }
}