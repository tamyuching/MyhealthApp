import 'dart:convert';

class RecordBean {
  late String? account;
  late String? date;
  late String weight;
  late String blood_pressure;
  late String glucose_level;
  late String cholesterol_level;
  late String take_medicine;
  late String any;

  RecordBean({
    required this.account,
    required this.date,
    required this.weight,
    required this.blood_pressure,
    required this.glucose_level,
    required this.cholesterol_level,
    required this.take_medicine,
    required this.any,
  });

  factory RecordBean.fromJson(Map<String, dynamic> json) {
    return RecordBean(
      account: json['account'],
      date: json['date'],
      weight: json['weight'],
      blood_pressure: json['blood_pressure'],
      glucose_level: json['glucose_level'],
      cholesterol_level: json['cholesterol_level'],
      take_medicine: json['take_medicine'],
      any: json['any'],
    );
  }

  static Map<String, dynamic> toMap(RecordBean diary) => {
        'account': diary.account,
        'date': diary.date,
        'weight': diary.weight,
        'blood_pressure': diary.blood_pressure,
        'glucose_level': diary.glucose_level,
        'cholesterol_level': diary.cholesterol_level,
        'take_medicine': diary.take_medicine,
        'any': diary.any,
      };

  static String encode(List<RecordBean> list) => json.encode(
        list
            .map<Map<String, dynamic>>((diary) => RecordBean.toMap(diary))
            .toList(),
      );

  static List<RecordBean> decode(String diarys) =>
      (json.decode(diarys) as List<dynamic>)
          .map<RecordBean>((item) => RecordBean.fromJson(item))
          .toList();
}
