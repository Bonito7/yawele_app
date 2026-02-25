import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final file = File('assets/images/Yawele logo.png');
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);

  if (image == null) {
    print('Failed to decode image');
    return;
  }

  print('Original size: \${image.width} x \${image.height}');

  int targetSize =
      (image.width > image.height ? image.width : image.height) * 2;

  // Create an image and fill it with transparent color instead of default
  final paddedImage =
      img.Image(width: targetSize, height: targetSize, numChannels: 4);
  img.fill(paddedImage, color: img.ColorRgba8(0, 0, 0, 0)); // Transparent black

  int offsetX = (targetSize - image.width) ~/ 2;
  int offsetY = (targetSize - image.height) ~/ 2;

  img.compositeImage(paddedImage, image, dstX: offsetX, dstY: offsetY);

  final targetFile = File('assets/images/Yawele logo padded.png');
  await targetFile.writeAsBytes(img.encodePng(paddedImage));

  print(
      'Saved truly transparent padded image: \${targetSize} x \${targetSize}');
}
