import 'dart:convert';

class PlanBean {
  late String? account;
  late String date;
  late String plan;
  late String? title;

  PlanBean({
    required this.account,
    required this.date,
    required this.plan,
    required this.title,
  });

  factory PlanBean.fromJson(Map<String, dynamic> json) {
    return PlanBean(
      account: json['account'],
      date: json['date'],
      plan: json['plan'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson(PlanBean entity) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = entity.account;
    data['date'] = entity.date;
    data['plan'] = entity.plan;
    data['title'] = entity.title;

    return data;
  }

  static Map<String, dynamic> toMap(PlanBean diary) => {
        'account': diary.account,
        'date': diary.date,
        'plan': diary.plan,
        'title': diary.title,
      };

  static String encode(List<PlanBean> list) => json.encode(
        list
            .map<Map<String, dynamic>>((diary) => PlanBean.toMap(diary))
            .toList(),
      );

  static List<PlanBean> decode(String diarys) =>
      (json.decode(diarys) as List<dynamic>)
          .map<PlanBean>((item) => PlanBean.fromJson(item))
          .toList();
}
