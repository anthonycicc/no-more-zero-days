import 'package:intl/intl.dart';

class Entry {
  final DateTime date;
  final String whatYouDid;

  Entry(this.date, this.whatYouDid);

  Entry.fromJson(Map<String, dynamic> json)
    : date = DateTime.parse(json['date']),
      whatYouDid = json['whatyoudid'];

  Map<String, dynamic> toJson() =>
      {
        'date': date.toString(),
        'whatyoudid': whatYouDid,
      };

  @override
  String toString() {
    return "${new DateFormat.yMMMMd().format(date)}: $whatYouDid";
  }
}