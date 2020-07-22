import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

enum Level { Debug, Info, Warning, Error, Fatal }

const String _apiPrefix = 'https://avenge.cn/api';
//const String apiPrefix = 'http://192.168.101.43:8012/api';
//const String apiPrefix = 'http://localhost:8012/api';

class SimpleLog {
  int _appId;
  String _appKey;
  http.Client _client;
  String _user;
  String _flag;
  List<Level> _printLevels;
  List<Level> _uploadLevels;

  static Map<String, SimpleLog> _cache = Map();

  /// Get singleton instance by [key]
  ///
  /// ```dart
  /// var logger = SimpleLog();
  /// ```
  factory SimpleLog(
      {String key = 'default',
        int appId,
        String appKey,
        String user,
        String flag,
        List<Level> printLevels,
        List<Level> uploadLevels: Level.values}) {
    if (_cache.containsKey(key)) {
      _cache[key]
        ..setPrintLevels(printLevels)
        ..setUploadLevels(uploadLevels)
        .._user = user
        .._flag = flag;
      return _cache[key];
    }
    _cache[key] = SimpleLog._internal(
        appId: appId,
        appKey: appKey,
        user: user,
        flag: flag,
        printLevels: printLevels,
        uploadLevels: uploadLevels);
    return _cache[key];
  }

  SimpleLog._internal(
      {int appId,
        String appKey,
        String user,
        String flag,
        List<Level> printLevels,
        List<Level> uploadLevels}) {
    _appId = appId;
    _appKey = appKey;
    _user = user;
    _flag = flag;
    _printLevels = printLevels;
    _uploadLevels = uploadLevels;
    _client = http.Client();
  }

  /// Set levels which will be printed on the local terminal.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.setPrintLevel([Level.Info, Level.Warning]);
  /// ```
  void setPrintLevels(List<Level> levels) {
    _printLevels = levels;
  }

  /// Set levels which will be uploaded to avenge.cn.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.setUploadLevel([Level.Info, Level.Warning]);
  /// ```
  void setUploadLevels(List<Level> levels) {
    _uploadLevels = levels;
  }

  Future<http.Response> _report(
      {Level level, Object object, String user, String flag}) {
    Map<String, dynamic> body = {
      "app_id": _appId,
      "app_key": _appKey,
      "user": user ?? this._user,
      "flag": flag ?? this._flag,
      "level": level.index,
      "data": null
    };
    if (object is String) {
      body['data'] = object;
    } else if (object is List || object is Map) {
      body['data'] = jsonEncode(object);
    } else {
      body['data'] = object.toString();
    }
    return _client.post('${_apiPrefix}/log',
        headers: {"content-type": "application/json"}, body: jsonEncode(body));
  }

  Future<dynamic> _log(Level level, dynamic object,
      {String user, String flag}) async {
    if (_printLevels != null &&
        _printLevels.isNotEmpty &&
        _printLevels.contains(level)) {
      print(object);
    }

    if (_uploadLevels == null ||
        _uploadLevels.isEmpty ||
        !_uploadLevels.contains(level)) {
      return;
    }

    var res =
    await _report(level: level, object: object, user: user, flag: flag);
    if (res.statusCode == HttpStatus.ok) {
      try {
        var data = jsonDecode(res.body);
        if (data['code'] == 0) {
          return true;
        }
        return data['message'];
      } catch (e) {
        return e.toString();
      }
    } else {
      return false;
    }
  }

  /// Debug log
  ///
  ///The [object] argument must not be null.
  ///The [user] argument temporarily sets the user id.
  ///The [flag] argument temporarily sets the flag.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.d("hello world", user: "user1", flag: "login");
  /// ```
  Future<dynamic> d(dynamic object, {String user, String flag}) async {
    return _log(Level.Debug, object, user: user, flag: flag);
  }

  /// Info log
  ///
  ///The [object] argument must not be null.
  ///The [user] argument temporarily sets the user id.
  ///The [flag] argument temporarily sets the flag.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.i("hello world", user: "user1", flag: "login");
  /// ```
  Future<dynamic> i(dynamic object, {String user, String flag}) async {
    return _log(Level.Info, object, user: user, flag: flag);
  }

  /// Warning log
  ///
  ///The [object] argument must not be null.
  ///The [user] argument temporarily sets the user id.
  ///The [flag] argument temporarily sets the flag.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.w("hello world", user: "user1", flag: "login");
  /// ```
  Future<dynamic> w(dynamic object, {String user, String flag}) async {
    return _log(Level.Warning, object, user: user, flag: flag);
  }

  /// Error log
  ///
  ///The [object] argument must not be null.
  ///The [user] argument temporarily sets the user id.
  ///The [flag] argument temporarily sets the flag.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.e("hello world", user: "user1", flag: "login");
  /// ```
  Future<dynamic> e(dynamic object, {String user, String flag}) async {
    return _log(Level.Error, object, user: user, flag: flag);
  }

  /// Fatal log
  ///
  ///The [object] argument must not be null.
  ///The [user] argument temporarily sets the user id.
  ///The [flag] argument temporarily sets the flag.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.f("hello world", user: "user1", flag: "login");
  /// ```
  Future<dynamic> f(dynamic object, {String user, String flag}) async {
    return _log(Level.Fatal, object, user: user, flag: flag);
  }
}
