import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ps_utils/popup/loaders.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html;
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateController extends GetxController {
  static UpdateController get instance => Get.find();

  final isUpdating = false.obs;
  final isDownloaded = false.obs;
  final isUpdated = true.obs;
  static Dio dio = Dio();

  String link = dotenv.get("FILE_URL", fallback: "");
  String name = "";

  final ReceivePort receivePort = ReceivePort();

  final progress = 0.obs;

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('Update');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    isUpdating.value = false;
    _unbindBackgroundIsolate();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      'Update',
    );
    if (!isSuccess) {
      print("error");
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    receivePort.listen((dynamic data) async {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1];
      final progressD = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progressD)',
      );

      progress.value = progressD;
      print("${progress.value} %");

      if (progress.value == -1) {
        isUpdating.value = false;
        progress.value = 0;
        PSLoaders.errorSnackBar(
            title: "OOPS",
            message: "Une erreur s'est produite, Veuillez réessayer");
      }
      if (progress.value == 100) {
        print("Fin");
        isUpdating.value = false;
        progress.value = 0;
        final directory = await getExternalStorageDirectory();
        print("Directory : $directory");
        if (directory == null) {
          throw Exception("Failed to get external storage directory");
        }

        final filePath = '${directory.path}/$name';
        await _installAPK(filePath);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _unbindBackgroundIsolate();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(id, status, progress) {
    print("here $progress");
    SendPort sendPort = IsolateNameServer.lookupPortByName("Update")!;
    sendPort.send([id, status, progress]);
  }

  Future<String> getFileNameFromUrl(String url) async {
    try {
      final dio = Dio();

      final response = await dio.get(url);

      final htmlContent = response.data;

      final fileNameRegex = RegExp(r'<a href="/open\?id=[^"]+">([^<]+)</a>');
      final match = fileNameRegex.firstMatch(htmlContent);

      if (match != null) {
        print("name is ${match.group(1)!}");
        name = match.group(1)!;
        return match.group(1)!;
      } else {
        print('File name not found in HTML content');
        return "";
      }
    } catch (e) {
      print('Failed to fetch file name from Google Drive: $e');
      return "";
    }
  }

  String extractVersionFromFileName(String fileName) {
    final regex = RegExp(r'v(\d+\.\d+\.\d+)');
    final match = regex.firstMatch(fileName);

    if (match != null) {
      return match.group(1)!;
    } else {
      print('Version not found in file name');
      return "";
    }
  }

  Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> checkForUpdates() async {
    String currentVersion = await getCurrentAppVersion();
    String fileName = await getFileNameFromUrl(link);
    String latestVersion = extractVersionFromFileName(fileName);

    print(currentVersion);
    if (currentVersion != latestVersion && latestVersion != "") {
      isUpdated.value = false;
    } else {
      isUpdated.value = true;
    }
  }

  Future<void> downloadAndInstallAPK() async {
    isUpdating.value = true;
    try {
      // Request permission to install packages (Android 8+)
      if (await _requestInstallPermission()) {
        // Get the application directory to store the APK file
        final directory = await getExternalStorageDirectory();
        print("Directory : $directory");
        if (directory == null) {
          throw Exception("Failed to get external storage directory");
        }

        // final filePath = '${directory.path}/$name';
        final filePath = directory.path;

        // Start the download
        await downloadFile(link, filePath);

        print("HERE IS REACHED");
        // isUpdating.value = false;
      } else {
        PSLoaders.infoSnackBar(
            title: "App Permission",
            message: "Permission is needed to Install file");
        isUpdating.value = false;
      }
    } catch (e) {
      print("Error downloading or installing APK: $e");
      PSLoaders.errorSnackBar(
          title: "OOPS!", message: "Error downloading or installing APK");
      isUpdating.value = false;
    }
  }

  // Request the necessary permission to install APK on Android
  Future<bool> _requestInstallPermission() async {
    if (Platform.isAndroid) {
      // Request permissions for installing APKs
      final status = await Permission.requestInstallPackages.request();
      return status.isGranted;
    }
    return true; // No need for permission on iOS
  }

  // Download file using Dio
  Future<void> downloadFile(String url, String filePath) async {
    try {
      // Step 1: Perform a GET request to get the HTML content
      final response = await dio.get(url);

      // Step 2: Extract the necessary parameters from the HTML
      String? downloadUrl = await _extractDownloadUrl(response.data);
      if (downloadUrl == null) {
        throw Exception(
            "Failed to extract download URL from the HTML content.");
      }

      // Step 3: Perform the actual download using the generated URL
      await downloadFileInBackground(downloadUrl, filePath);

      print("Here");
    } catch (e) {
      print("Error during the download process: $e");
      throw Exception("Download failed: $e");
    }
  }

  // Extract the download URL from the HTML response
  Future<String?> _extractDownloadUrl(String htmlContent) async {
    try {
      // Parse the HTML content
      var document = html.parse(htmlContent);

      // Extract the necessary hidden input values (file id, confirm token, uuid, etc.)
      var fileIdElement = document.querySelector('input[name="id"]');
      var confirmElement = document.querySelector('input[name="confirm"]');
      var uuidElement = document.querySelector('input[name="uuid"]');

      // Extract values
      if (fileIdElement == null ||
          confirmElement == null ||
          uuidElement == null) {
        print("Failed to find required form parameters in the HTML.");
        isUpdating.value = false;
        return null;
      }

      String fileId = fileIdElement.attributes['value']!;
      String confirm = confirmElement.attributes['value']!;
      String uuid = uuidElement.attributes['value']!;

      // Construct the download URL
      String downloadUrl =
          "https://drive.usercontent.google.com/download?id=$fileId&export=download&confirm=$confirm&uuid=$uuid";

      print("Generated download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error extracting download parameters: $e");
      isUpdating.value = false;
      return null;
    }
  }

  Future<void> downloadFileInBackground(String url, String filePath) async {
    String? tId = (await FlutterDownloader.enqueue(
      url: url,
      savedDir: filePath,
      fileName: name,
      showNotification: true, // Show notification when download is complete
      openFileFromNotification: true, // Open file after download
    ));
  }

  // Install the APK (for Android only)
  Future<void> _installAPK(String filePath) async {
    try {
      // Open the downloaded APK file to start the installation process
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception("Failed to open APK for installation");
      }
      print("APK opened successfully, installation started.");
    } catch (e) {
      throw Exception("Failed to open APK for installation: $e");
    }
  }
}
