# simple_log

简单的日志扩展程序，可以把日志上传到[avenge.cn](https://avenge.cn)。


[avenge.cn](https://avenge.cn)是一个日志管理平台，欢迎使用~

[English](README.md)

## 开始

1. 注册账号

   [https://avenge.cn/register](https://avenge.cn/register)
2. 创建应用
   [https://avenge.cn/home/resources/apps/new](https://avenge.cn/home/resources/apps/new)
   
3. 安装扩展
   ```yaml
   dependencies:
       simple_log: ^1.0.2
   ```
4. 用法
   ```dart
   import 'package:simple_log/simple_log.dart';

   void main(){
     SimpleLog logger = SimpleLog(appId: yourAppId, appKey: 'yourAppKey');
     FlutterError.onError = (FlutterErrorDetails details) {
       logger.e(details);
     };
     runApp(MyApp());
   }
    ```
5. 其他用法

   [simple_logger_example.dart](example/simple_logger_example.dart)
    ```dart
   SimpleLog logger = SimpleLog(appId: 1, appKey: 'yourAppKey');
   SimpleLog logger2 = SimpleLog(key: 'key2',appId: 2, appKey: 'yourAppKey2');
   
   // key默认值为"default"
   assert(logger == SimpleLog(key: 'default'));
   
   // debug等级
   logger.d("hello world");
   
   // info等级 
   logger.i("hello world");
   
   // warning等级 
   logger.w({"a":1,"b":"c"}); 
   
   // 设置本地打印日志的等级，error等级的日志会被打印在本地终端
   logger2.setPrintLevels([Level.Error]);
   
   // error等级
   // 此日志会被打印在本地终端
   logger2.e(logger); 
   
   // 取消上传
   logger2.setUploadLevels(null);
   
   // fatal等级
   // 此日志会被打印在本地终端，但不会上传
   logger2.f(["p1", "p2"]); 
    ```
