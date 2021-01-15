import 'dart:io';

enum FileType { image, video, pdf, doc, spreadsheet, ppt }

extension FileTypeExtension on FileType {
  List<String> get extensionsFile {
    switch (this) {
      case FileType.image:
        return ["jpg", "jpeg", "png"];
      case FileType.video:
        return ["3gp", "mp4", "webm"];
      case FileType.pdf:
        return ["pdf"];
      case FileType.doc:
        return ["doc", "docx"];
      case FileType.spreadsheet:
        return ["xls", "xlsx"];
      case FileType.ppt:
        return ["ppt", "pptx"];
      default:
        return [];
    }
  }

  static FileType find(String extensionFile) => FileType.values.firstWhere(
      (ft) => ft.extensionsFile.contains(extensionFile),
      orElse: () => null);
}

extension FileExtension on File {
  String get extensionName {
    if (this == null) throw Exception("file is null");

    return FileUtils.getExtension(this.path);
  }

  FileType get fileType {
    if (this == null) throw Exception("file is null");

    return FileTypeExtension.find(this.extensionName);
  }
}

class FileUtils {
  static String getExtension(String path) {
    if (path == null) throw Exception("path can't be null");

    return path.substring(path.lastIndexOf(".") + 1);
  }

  static FileType getFileType(String url) {
    if (url == null) throw Exception("url can't be null");

    final String extensionFile = getExtension(url);

    return FileTypeExtension.find(extensionFile);
  }
}
