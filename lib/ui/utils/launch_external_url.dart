import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  Uri parsedUrl = Uri.parse(url);
  if (await canLaunchUrl(parsedUrl)) {
    await launchUrl(parsedUrl);
  } else {
    throw 'Could not open the url: $url';
  }
}
