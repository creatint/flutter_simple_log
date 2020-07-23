Language: [English](README.md) | [中文](README_zh-CN.md)

# simple_log
The simplest way to upload logs to remote server, support all platforms.

Logs will be uploaded to [avenge.cn](https://avenge.cn), which is a simple Log-Management-System, welcome to try ^_^

[中文](README_zh-CN.md)

## Getting Started

1. Register for free

   [https://avenge.cn/register](https://avenge.cn/register)
2. Install
   ```yaml
   dependencies:
       simple_log: ^1.0.8
   ```
3. Usage
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
4. Other usages

   [simple_logger_example.dart](example/simple_logger_example.dart)
    ```dart
   SimpleLog logger = SimpleLog(appId: 123, appKey: 'yourAppKey');
   SimpleLog logger2 = SimpleLog(key: 'key2',appId: 456, appKey: 'yourAppKey2');
   
   // default key is "default"
   assert(logger == SimpleLog(key: 'default'));
   
   // debug level
   logger.d("hello world");
   
   // info level
   logger.i("hello world");
   
   // warning level
   logger.w({"a":1,"b":"c"}); 
   
   // error level log will be printed on the local terminal
   logger2.setPrintLevels([Level.Error]);
   
   // error level
   // this log will be printed on the local terminal
   logger2.e(logger); 
   
   // cancel upload logs
   logger2.setUploadLevels(null);
   
   // fatal level
   // this log will be printed on the local terminal but will not be uploaded
   logger2.f(["p1", "p2"]); 
    ```
