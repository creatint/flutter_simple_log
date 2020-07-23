import 'package:test/test.dart';

import 'package:simple_log/simple_log.dart';

void main() {
  group('A group of tests', () {
    SimpleLog logger;

    setUp(() {
      logger = SimpleLog(
          appId: 1,
          appKey: 'g4rehwe8fq4qe9rgh4q',
          user: 'user haha',
          flag: 'flag hahaha');
    });

    test('test simple_log', () async {
      var res1 = await logger.d('haha');
      expect(res1, true);

      var res2 = await logger.d([1, 2, 3], flag: 'flag123');
      expect(res2, true);

      var res3 = await logger.d({"a": 1, "b": "c"}, user: 'abc');
      expect(res3, true);

      var res4 = await logger.d(Object());
      expect(res4, true);

      var res5 = await logger.f('haha');
      expect(res5, true);
    });
  });
}
