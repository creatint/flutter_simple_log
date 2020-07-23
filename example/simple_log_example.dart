import 'package:simple_log/simple_log.dart';

void main() {
  SimpleLog logger = new SimpleLog(appId: 123, appKey: 'yourAppKey1');
  SimpleLog logger2 =
      new SimpleLog(key: 'key2', appId: 456, appKey: 'yourAppKey2');

  // default key is "default"
  assert(logger == new SimpleLog(key: 'default'));

  // debug level
  logger.d("hello world");

  // info level
  logger.i("hello world");

  // warning level
  logger.w({"a": 1, "b": "c"});

  // error level log will be printed on the local terminal
  logger2.setPrintLevels([Level.Error]);

  // error level
  // this log will be printed on the local terminal
  logger2.e(logger);

  logger2.setUploadLevels(null);

  // fatal level
  // this log will be printed on the local terminal but will not be uploaded
  logger2.f(["p1", "p2"]);
}
