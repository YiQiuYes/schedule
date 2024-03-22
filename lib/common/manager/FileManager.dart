import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';

class FileManager {
  FileManager._privateConstructor();
  static final FileManager _instance = FileManager._privateConstructor();
  factory FileManager() {
    return _instance;
  }

  // 本地基本路径
  late String basePath;

  /// 获取本地路径
  Future<void> fileManagerInit() async {
    // web端不需要初始化
    if (PlatformUtils.isWeb) {
      return;
    }

    final path = await getTemporaryDirectory();
    Directory cacheDir = Directory("${path.path}/cache");
    // 如果文件夹不存在则创建
    if (!cacheDir.existsSync()) {
      cacheDir.create();
    }
    basePath = cacheDir.path;
  }

  /// 获取本地文件
  Future<File> loadFileByPath(String filePath) {
    return Future.value(File(filePath));
  }

  /// 读取文件路径列表
  Future<List<String>> loadFileList({String headerPath = "cacheFile"}) async {
    String char = headerPath.substring(0, 1);
    if (char == "/") {
      headerPath = headerPath.substring(1);
    }

    // 获取文件夹
    List<String> fileList = [];
    Directory dir = Directory('$basePath/$headerPath');
    if (dir.existsSync()) {
      dir.listSync().forEach((element) {
        if (element is File) {
          fileList.add(element.path);
        }
      });
    }
    return Future.value(fileList);
  }

  /// 写入文件数据二进制
  Future<File> writeAsBytes(String fileName, List<int> bytes,
      {String headerPath = "cacheFile"}) async {
    // 处理fileName
    String char = fileName.substring(0, 1);
    if (char == "/") {
      fileName = fileName.substring(1);
    }
    char = headerPath.substring(0, 1);
    if (char == "/") {
      headerPath = headerPath.substring(1);
    }

    // 判断头部路径是否存在
    Directory dir = Directory('$basePath/$headerPath');
    if (!dir.existsSync()) {
      dir.create();
    }

    File file = File('$basePath/$headerPath/$fileName');
    return file.writeAsBytes(bytes);
  }

  /// 异步批量获取二进制文件数据
  Future<List<Uint8List>> readAsUint8List(List<String> filePathList,
      {String headerPath = "cacheFile"}) async {
    String char = headerPath.substring(0, 1);
    if (char == "/") {
      headerPath = headerPath.substring(1);
    }

    List<Uint8List> result = [];
    for (String fileName in filePathList) {
      File file = await loadFileByPath(fileName);
      Uint8List data = await file.readAsBytes();
      result.add(data);
    }
    return result;
  }

  /// 批量删除文件
  Future<void> deleteFileList(List<String> filePathList) async {
    for (String fileName in filePathList) {
      File file = await loadFileByPath(fileName);
      await file.delete();
    }
  }
}
