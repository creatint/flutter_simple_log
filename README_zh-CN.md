# simple_log
![Pub Version](https://img.shields.io/pub/v/simple_log?style=flat-square)
![Platform](https://img.shields.io/badge/platform-flutter%7Cflutter%20web%7Cdart%20vm-brightgreen)

最简单的日志收集方式，支持所有平台。

默认情况下，日志会被上传到[avenge.app](https://avenge.app)，这是一个简单的日志管理系统，欢迎试用^_^

你也可以设置自己的服务器来接收日志。

## 开始

1. 注册账号

   [https://avenge.app/register](https://avenge.app/register)
2. 创建应用

   [https://avenge.app/developer/resources/app-apps/new](https://avenge.app/developer/resources/app-apps/new)
   
3. 安装扩展
   ```yaml
   dependencies:
       simple_log: ^1.2.3
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
   SimpleLog logger = SimpleLog(appId: 123, appKey: 'yourAppKey');
   SimpleLog logger2 = SimpleLog(key: 'key2',appId: 456, appKey: 'yourAppKey2');
   
   // key默认值为'default'
   assert(logger == SimpleLog(key: 'default'));
   
   // debug等级
   logger.d('hello world');
   
   // info等级 
   logger.i('hello world');
   
   // warning等级 
   logger.w({'a':1,'b':'c'}); 
   
   // 设置本地打印日志的等级，error等级的日志会被打印在本地终端
   logger2.setPrintLevels([Level.Error]);
   
   // error等级
   // 此日志会被打印在本地终端
   logger2.e(logger); 
   
   // 取消上传日志
   logger2.setUploadLevels(null);
   
   // fatal等级
   // 此日志会被打印在本地终端，但不会上传
   logger2.f(['p1', 'p2']); 
    ```
   
## 构建接收日志服务器

  
*SimpleLog.apiPrefix* 的默认值是 *https://avenge.app/api* ，你可以指定自己的服务器来接收日志。
```dart
var logger = SimpleLog(apiPrefix: 'your own server');
```
  
当提交一个日志时，它会向服务器发送一个json：
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
*data* 是这个日志的内容，可以是字符串，也可以是json。
  
然后，服务器会返回json：
```json
{
  "code": 0,
  "message": "success"
}
```
如果 *code* 值是 0 ，意味着提交成功。

如果发生了错误，将会是：
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
