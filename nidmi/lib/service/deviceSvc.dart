import 'dart:async';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../entity/Device.dart';
import '../xinternal/DeviceResponse.dart';
import '../xinternal/AppGlobal.dart';
import '../xinternal/LoginResponse.dart';

class DeviceService {

  var logger = Logger(printer: PrettyPrinter(),);
  AppGlobal appGlobal = AppGlobal.single_instance;
  final Dio _dio = new Dio();
  static String bearer;

  // Future<void> getBearer() async {
  //   bearer = await AppGlobal.getUserAccessSharedPreference();
  // }

  DeviceService() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<DeviceResponse> httpPost(Device device, String url) async {
    bearer = await AppGlobal.getUserAccessSharedPreference();
    String endpoint = AppGlobal.baseUrlDevice + url;
    DeviceResponse usr = new DeviceResponse();
    try {
      var response = await _dio.post(
          "$endpoint",
          data: dataRequest(device),
          options: httpOptions()
      ).timeout(Duration(seconds: AppGlobal.secTimeOut));

      return extractDeviceResponse(response);
    } on HttpException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '400';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on SocketException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '400';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on TimeoutException catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = '500';
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    } on DioError catch (e) {
      usr.statusMessage = e.message;
      usr.statusCode = e.error.toString();
      print(e);
      print(usr.statusMessage);
      print(usr.statusCode);
      return usr;
    }
  }

  dynamic dataRequest(Device device) {
    return ({
      "owner_id": device.owner_id,
      "device_unique_id": device.device_unique_id,
      "token": device.token,
      "device_type": device.device_type,
      "activated": device.activated
    });
  }

  Options httpOptions() {
    print('%%%%%%%%%% bearer ##########: ' + bearer);
    return new Options(headers: {
      "content-type": "application/json",
      "x-api-key": AppGlobal.apiKey,
      "Authorization" : "bearer "+ bearer
    });
  }

  DeviceResponse extractDeviceResponse(dynamic response){
    var responseData = response.data;
    DeviceResponse usr = DeviceResponse.fromJson(responseData);
    usr.statusCode = response.statusCode.toString();
    usr.statusMessage = response.statusMessage;
    return usr;
  }

  dynamic exceptionError(dynamic e, dynamic usr) {
    usr.statusMessage = e.message;
    usr.statusCode = e.error.toString();
    print(e);
    print(usr.statusMessage);
    print(usr.statusCode);
    return usr;
  }

}