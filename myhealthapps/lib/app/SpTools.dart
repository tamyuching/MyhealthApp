import 'package:myhealthapps/app/bean/RecordBean.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'bean/PlanBean.dart';

//local storage
class SpTools {
  static SpTools? _singleton;
  static SharedPreferences? _sharedPreferences;

  static Future<SpTools?> getInstance() async {
    if (_singleton == null) {
      var singleton = SpTools._internal();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  SpTools._internal();

  Future _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool>? putObject(String key, Object value) {
    return _sharedPreferences?.setString(key, json.encode(value));
  }

  /// get obj.
  static T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map? getObject(String key) {
    String? _data = _sharedPreferences?.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool>? putObjectList(String key, List<Object> list) {
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _sharedPreferences?.setStringList(key, _dataList);
  }

  /// get obj list.
  static List<T>? getObjList<T>(String key, T f(Map v),
      {List<T>? defValue = const []}) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map>? getObjectList(String key) {
    List<String>? dataLis = _sharedPreferences?.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  /// get string.
  static String? getString(String key, {String? defValue = ''}) {
    return _sharedPreferences?.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? putString(String key, String value) {
    return _sharedPreferences?.setString(key, value);
  }

  static Stream<bool?> putStreamString(String key, String value) {
    return Stream.fromFuture(putString(key, value)!).asBroadcastStream();
  }

  /// get bool.
  static bool? getBool(String key, {bool? defValue = false}) {
    return _sharedPreferences?.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool>? putBool(String key, bool value) {
    return _sharedPreferences?.setBool(key, value);
  }

  static Stream<bool?> putStreamBool(String key, bool value) {
    return Stream.fromFuture(putBool(key, value)!).asBroadcastStream();
  }

  /// get int.
  static int? getInt(String key, {int? defValue = 0}) {
    return _sharedPreferences?.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? putInt(String key, int value) {
    return _sharedPreferences?.setInt(key, value);
  }

  /// get double.
  static double? getDouble(String key, {double? defValue = 0.0}) {
    return _sharedPreferences?.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? putDouble(String key, double value) {
    return _sharedPreferences?.setDouble(key, value);
  }

  /// get string list.
  static List<String>? getStringList(String key, {List<String>? defValue}) {
    return _sharedPreferences?.getStringList(key) ?? [];
  }

  /// put string list.
  static Future<bool>? putStringList(String key, List<String> value) {
    return _sharedPreferences?.setStringList(key, value);
  }

  static void setPlanList(List<PlanBean> list, String key) {
    String str = PlanBean.encode(list);
    putString(key, str);
  }

  static List<PlanBean> getPlanList(String key) {
    String? str = getString(key, defValue: "");
    if (str == "") {
      return [];
    }
    List<PlanBean> list = PlanBean.decode(str!);
    return list;
  }

  static void setRecordList(List<RecordBean> list, String key) {
    String str = RecordBean.encode(list);
    putString(key, str);
  }

  static List<RecordBean> getRecordList(String key) {
    String? str = getString(key, defValue: "");
    if (str == "") {
      return [];
    }
    List<RecordBean> list = RecordBean.decode(str!);
    return list;
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    return _sharedPreferences?.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    return _sharedPreferences?.getKeys().contains(key);
  }

  /// contains Key.
  static bool? containsKey(String key) {
    return _sharedPreferences?.containsKey(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    return _sharedPreferences?.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    return _sharedPreferences?.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    return _sharedPreferences?.clear();
  }

  /// Fetches the latest values from the host platform.
  static Future<void>? reload() {
    return _sharedPreferences?.reload();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _sharedPreferences != null;
  }

  /// get Sp.
  static SharedPreferences? getSp() {
    return _sharedPreferences;
  }
}
