import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  Uri parsedUrl = Uri.parse(url);
  if (await canLaunchUrl(parsedUrl)) {
    await launchUrl(
      parsedUrl,
      mode: LaunchMode.platformDefault,
    );
  } else {
    throw 'Could not open the url: $url';
  }
}

Future<void> openExternalApp(String appId) async {
  final url = Uri.parse("market://details?id=$appId");
  launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}
