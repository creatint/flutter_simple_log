Language: [English](README.md) | [中文](README_zh-CN.md)

# simple_log
![Pub Version](https://img.shields.io/pub/v/simple_log?style=flat-square)
![Platform](https://img.shields.io/badge/platform-flutter%7Cflutter%20web%7Cdart%20vm-brightgreen)

The simplest way to upload logs to remote server, support all platforms.

By default, logs will be uploaded to [avenge.app](https://avenge.app), which is a simple Log-Management-System, welcome to try ^_^

You can set your own server to receive logs.

## Getting Started

1. Register for free

   [https://avenge.app/register](https://avenge.app/register)
2. Create app

   [https://avenge.app/developer/resources/app-apps/new](https://avenge.app/developer/resources/app-apps/new)

3. Install
   ```yaml
   dependencies:
       simple_log: ^1.2.3
   ```
4. Usage
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
5. Other usages

   [simple_logger_example.dart](example/simple_logger_example.dart)
    ```dart
   SimpleLog logger = SimpleLog(appId: 123, appKey: 'yourAppKey');
   SimpleLog logger2 = SimpleLog(key: 'key2',appId: 456, appKey: 'yourAppKey2');
   
   // default key is 'default'
   assert(logger == SimpleLog(key: 'default'));
   
   // debug level
   logger.d('hello world');
   
   // info level
   logger.i('hello world');
   
   // warning level
   logger.w({'a':1,'b':'c'}); 
   
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
    ```

## Build receive server

  
   The default value of [SimpleLog.apiPrefix] is 'https://avenge.app/api', you can set your own server to receive logs.
   ```dart
   var logger = SimpleLog(apiPrefix: 'your own server');
   ```
  
   When it reports a log, it will post a json to remote server:
   ```json
   {
     "app_id": 123,
     "app_key": "appKey123",
     "user": "user123",
     "flag": "flag123",
     "level": 2,
     "data": {}
   }
   ```
   *data* is the content of the log, it can be string or json.
  
   Then, the remote server will give back a json:
   ```json
   {
     "code": 0,
     "message": "success"
   }
   ```
   If *code* is 0, it means success.
  
   If something went wrong, it would be:
   ```json
   {
     "code": -1,
     "message": "something wrong ..."
   }
   ```

## 全部项目
| 插件                                                     | 状态                                                       | 描述                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [simple_log](https://github.com/creatint/flutter_simple_log) | ![Pub Version](https://img.shields.io/pub/v/simple_log?style=flat-square) | The simplest way to upload logs to remote server, support all platforms |
| [simple_update](https://github.com/creatint/flutter_simple_update) | ![Pub Version](https://img.shields.io/pub/v/simple_update?style=flat-square) | The simplest way to update your app, support all platforms |
