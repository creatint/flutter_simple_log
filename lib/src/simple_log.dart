import 'dart:convert';
import 'package:dio/dio.dart';

enum Level { Debug, Info, Warning, Error, Fatal }

class SimpleLog {
  String _apiPrefix;
  int _appId;
  String _appKey;
  Dio _dio;
  String _user;
  String _flag;
  List<Level> _printLevels;
  List<Level> _uploadLevels;

  static final Map<String, SimpleLog> _cache = {};

  /// Get singleton instance by [key]
  ///
  /// ```dart
  /// var logger = SimpleLog();
  /// ```
  ///
  /// The default value of [apiPrefix] is *https://avenge.app/api*, you can set your own server to receive logs.
  /// ```dart
  /// var logger = SimpleLog(apiPrefix: 'your own server');
  /// ```
  ///
  /// When it reports a log, it will post a json to remote server:
  /// ```json
  /// {
  ///   "app_id": 123,
  ///   "app_key": "appKey123",
  ///   "user": "user123",
  ///   "flag": "flag123",
  ///   "level": 2,
  ///   "data": {}
  /// }
  /// ```
  /// *data* is the content of the log, it can be string or json.
  ///
  /// Then, the remote server will give back a json:
  /// ```json
  /// {
  ///   "code": 0,
  ///   "message": "success"
  /// }
  /// ```
  /// If *code* is 0, it means success.
  ///
  /// If something went wrong, it would be:
  /// ```json
  /// {
  ///   "code": -1,
  ///   "message": "something wrong ..."
  /// }
  /// ```
  factory SimpleLog(
      {String key = 'default',
      int appId,
      String appKey,
      String user,
      String flag,
      List<Level> printLevels,
      List<Level> uploadLevels = Level.values,
      String apiPrefix = 'https://avenge.app/api'}) {
    if (_cache.containsKey(key)) {
      _cache[key]
        ..setPrintLevels(printLevels)
        ..setUploadLevels(uploadLevels)
        .._appId = appId
        .._appKey = appKey
        .._user = user
        .._flag = flag
        .._apiPrefix = apiPrefix;
      return _cache[key];
    }
    _cache[key] = SimpleLog._internal(
        appId: appId,
        appKey: appKey,
        user: user,
        flag: flag,
        printLevels: printLevels,
        uploadLevels: uploadLevels,
        apiPrefix: apiPrefix);
    return _cache[key];
  }

  SimpleLog._internal(
      {int appId,
      String appKey,
      String user,
      String flag,
      List<Level> printLevels,
      List<Level> uploadLevels,
      String apiPrefix}) {
    _appId = appId;
    _appKey = appKey;
    _user = user;
    _flag = flag;
    _printLevels = printLevels;
    _uploadLevels = uploadLevels;
    _apiPrefix = apiPrefix;
    _dio = Dio(BaseOptions(
        baseUrl: _apiPrefix,
        contentType: 'application/json',
        followRedirects: true));
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

  /// Set levels which will be uploaded to avenge.app.
  ///
  /// ### Example
  ///
  /// ```
  /// logger.setUploadLevel([Level.Info, Level.Warning]);
  /// ```
  void setUploadLevels(List<Level> levels) {
    _uploadLevels = levels;
  }

  Future<Response> _report(
      {Level level, Object object, String user, String flag}) {
    var body = {
      'app_id': _appId,
      'app_key': _appKey,
      'user': user ?? _user,
      'flag': flag ?? _flag,
      'level': level.index,
      'data': null
    };
    if (object is String) {
      body['data'] = object;
    } else if (object is List || object is Map) {
      body['data'] = jsonEncode(object);
    } else {
      body['data'] = object.toString();
    }
    return _dio.post('/log', data: FormData.fromMap(body));
  }

  Future<dynamic> _log(Level level, dynamic object,
      {String user, String flag}) async {
    if (_printLevels != null &&
        _printLevels.isNotEmpty &&
        _printLevels.contains(level)) {}

    if (_uploadLevels == null ||
        _uploadLevels.isEmpty ||
        !_uploadLevels.contains(level)) {
      return null;
    }

    var res =
        await _report(level: level, object: object, user: user, flag: flag);
    if (res.statusCode == 200) {
      try {
        var data = res.data;
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
  /// logger.d('hello world', user: 'user1', flag: 'login');
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
  /// logger.i('hello world', user: 'user1', flag: 'login');
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
  /// logger.w('hello world', user: 'user1', flag: 'login');
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
  /// logger.e('hello world', user: 'user1', flag: 'login');
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
  /// logger.f('hello world', user: 'user1', flag: 'login');
  /// ```
  Future<dynamic> f(dynamic object, {String user, String flag}) async {
    return _log(Level.Fatal, object, user: user, flag: flag);
  }
}
