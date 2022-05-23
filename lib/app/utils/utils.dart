import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension ListExtension<E> on List<E> {
  void addAllUnique(Iterable<E> iterable) {
    for (var element in iterable) {
      if (!contains(element)) {
        add(element);
      }
    }
  }
}

bool equalsIgnoreCase(String? string1, String? string2) {
  return string1?.toLowerCase() == string2?.toLowerCase();
}

Future<File> moveFile(File sourceFile) async {
  var dir = await getExternalStorageDirectory() ?? await getLibraryDirectory();
  if (!Directory('${dir.path}/oop').existsSync()) {
    Directory('${dir.path}/oop').createSync(recursive: true);
  }
  String fileName = sourceFile.path.split('/').last;
  try {
    /// prefer using rename as it is probably faster
    /// if same directory path
    return await sourceFile
        .rename(Directory('${'${dir.path}/oop/'}$fileName').path);
  } catch (e) {
    /// if rename fails, copy the source file
    final newFile =
        await sourceFile.copy(Directory('${'${dir.path}/oop/'}$fileName').path);
    return newFile;
  }
}

double libraryContentTextRowsInWidget(context, String desc) {
  if (desc == null) return 0;
  String text = desc != null ? desc : '';
  TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: Color.fromRGBO(130, 130, 130, 1.0),
            fontSize: 12,
            letterSpacing: 0.1,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontFamily: 'Varela'),
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr);
  final Size size = (textPainter..layout()).size;
  double rows = MediaQuery.of(context).size.width - 200;
  rows = size.width / rows;
  return rows;
}

bool isOpenableOnIos(String path) {
  if (path == null) return false;
  String extension = path.split('.').last;
  return extension != null
      ? (extension.toLowerCase() == 'txt' ||
          extension.toLowerCase() == 'rtf' ||
          extension.toLowerCase() == 'xls' ||
          extension.toLowerCase() == 'xlsx' ||
          extension.toLowerCase() == 'docx' ||
          extension.toLowerCase() == 'doc')
      : false;
}

bool isYoutubeLink(String url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  final RegExp pattern =
      RegExp(r'^(http(s)?:\/\/)?((w){3}.)?(m.)?youtu(be|.be)?(\.com)?\/.+');
  return pattern.hasMatch(url);
}

bool isVimeoLink(String url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  final RegExp pattern = RegExp(
      r'^(http|https)?:\/\/(www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|)(\d+)(?:|\/\?)');
  return pattern.hasMatch(url);
}

Future<void> askPermissions(BuildContext context, Permission perm) async {
  PermissionStatus permissionStatus = await perm.status;
  if (permissionStatus != PermissionStatus.granted) {
    if (await perm.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      _gotoSettings(context);
    } else if (false == await perm.request().isGranted) {
      _gotoSettings(context);
    }
  }
}

_gotoSettings(BuildContext context) {
  // showAlertDialog(
  //     context,
  //     'Permission Alert',
  //     'Please update your settings to allow this app to access your photo library.',
  //     'Settings',
  //     () => {openAppSettings()});
}

String sanitizeChatDialogTitle(String title) {
  if (title != null && title.contains('#')) {
    return title.substring(0, title.indexOf('#'));
  }
  return title;
}

String getMimeType(File file, String contentType) {
  return _getMimeType(file.path, contentType) ?? contentType;
}

String? _getMimeType(String path, String contentType) {
  return lookupMimeType(path);
}
