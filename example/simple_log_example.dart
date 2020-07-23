import 'package:simple_log/simple_log.dart';

void main() {
  SimpleLog logger = SimpleLog(appId: 123, appKey: 'yourAppKey1');
  SimpleLog logger2 = SimpleLog(key: 'key2', appId: 456, appKey: 'yourAppKey2');

  // default key is 'default'
  assert(logger == SimpleLog(key: 'default'));

  // debug level
  logger.d('hello world');

  // info level
  logger.i('hello world');

  // warning level
  logger.w({'a': 1, 'b': 'c'});

  // error level log will be printed on the local terminal
  logger2.setPrintLevels([Level.Error]);

  // error level
  // this log will be printed on the local terminal
  logger2.e(logger);

  // cancel upload logs
  logger2.setUploadLevels(null);

  // fatal level
  // this log will be printed on the local terminal but will not be uploaded
  logger2.f(['p1', 'p2']);
}
