import 'package:intl/intl.dart';

class Entry {
  final int id;
  final DateTime date;
  final String whatYouDid;

  Entry(this.id, this.date, this.whatYouDid);

  Entry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['date']),
        whatYouDid = json['whatyoudid'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toString(),
        'whatyoudid': whatYouDid,
      };

  @override
  String toString() {
    return "${new DateFormat.yMMMMd().format(date)}: $whatYouDid";
  }
}
