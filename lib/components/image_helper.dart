import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  /// Downloads images from given URLs and stores them temporarily as [File].
  /// Returns a List<File>.
  static Future<List<File>> downloadImages(List<String> urls) async {
    List<File> files = [];
    final tempDir = await getTemporaryDirectory();

    for (String url in urls) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final fileName = url.split('/').last; // get image name
          final file = File('${tempDir.path}/$fileName');

          await file.writeAsBytes(response.bodyBytes);
          files.add(file);
        } else {
          print("Failed to download: $url (Status ${response.statusCode})");
        }
      } catch (e) {
        print("Error downloading $url => $e");
      }
    }
    return files;
  }
}
