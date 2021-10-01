// ignore_for_file: public_member_api_docs
String toStringWithMicrosecond(DateTime dateTime) {
  if (dateTime.microsecond == 0) {
    final iso = dateTime.toIso8601String();
    return '${iso.substring(0, iso.length - 1)}000Z';
  }

  return dateTime.toIso8601String();
}
