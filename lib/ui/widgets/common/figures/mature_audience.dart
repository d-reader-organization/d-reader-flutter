import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:flutter/material.dart';

Color getAudienceColor(String type) {
  if (type == AudienceType.Mature.name) {
    return const Color(0xFFE00924);
  } else if (type == AudienceType.Teen.name) {
    return const Color(0xFFF2CA63);
  }
  return const Color(0xFFA6C434);
}

String getAudienceText(String type) {
  if (type == AudienceType.Mature.name) {
    return '18';
  } else if (type == AudienceType.Teen.name ||
      type == AudienceType.TeenPlus.name) {
    return '12';
  }
  return '7';
}

class MatureAudience extends StatelessWidget {
  final String audienceType;
  const MatureAudience({
    super.key,
    required this.audienceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: getAudienceColor(audienceType),
        ),
      ),
      child: Text(
        getAudienceText(audienceType),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: getAudienceColor(audienceType),
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
