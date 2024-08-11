library telr_payment_gateway_plus;

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telr_payment_gateway_plus/src/network_helper.dart';
import 'package:telr_payment_gateway_plus/src/web_view_screen.dart';
import 'package:xml/xml.dart';

enum PhoneType {
  android,
  ios,
}

/// Telr Payment Gateway Plus.
class TelrPaymentGatewayPlus {
  String _url = '';

  String? getDeviceId() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((value) {
        return value.id; // This is the unique device ID on Android
      },);
    } else if (Platform.isIOS) {
      deviceInfo.iosInfo.then((value) {
        value.identifierForVendor; // This is the unique device ID on iOS
      },);
    }
    return null;
  }

  void alertShow(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void _launchURL(BuildContext context, String url, String code, String APIKey, String storeID) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
              url: url,
              code: code,
              APIKey: APIKey,
              storeID: storeID,
            )));
  }

  void pay(BuildContext context, XmlDocument xml, String APIKey, String storeID) async {
    NetworkHelper networkHelper = NetworkHelper();
    var response = await networkHelper.pay(xml);
    // print(response);
    if (response == 'failed' || response == null) {
      // failed
      if(context.mounted) {
        alertShow(context, 'Failed');
      }
    } else {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      // print(url);
      _url = url.toString();
      String code0 = code.toString();
      if (_url.length > 2) {
        _url = _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        code0 = code0.replaceAll('(', '');
        code0 = code0.replaceAll(')', '');
        if(context.mounted) {
          _launchURL(context, _url, code0, APIKey, storeID);
        }
      }
      // print(_url);
      final message = doc.findAllElements('message').map((node) => node.text);
      // print('Message =  $message');
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        if(context.mounted) {
          alertShow(context, msg);
        }
      }
    }
  }

  TelrPaymentGatewayPlus.pay({required BuildContext context,
    required String APIKey,
    required String storeID,
    required PhoneType phoneType,
    String appName = 'app',
    String appVersion = '1.0.0',
    String appUser = '1',
    required String appUserId,
    required bool testMode,
    required String cartId,
    required String customerEmail,
    required String customerPhone,
    required String customerCountryCode,
    required String customerAddress,
    String customerRegion = '',
    String customerCity = '',
    required String currencyCode,
    required double amount,
    String languageCode = 'en',
    String description = 'Payment',}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        builder.text(storeID);
      });
      builder.element('key', nest: () {
        builder.text(APIKey);
      });

      builder.element('device', nest: () {
        builder.element('type', nest: () {
          builder.text(phoneType == PhoneType.android ? 'android' : 'ios');
        });
        builder.element('id', nest: () {
          builder.text(getDeviceId()??'');
        });
      });

// app
      builder.element('app', nest: () {
        builder.element('name', nest: () {
          builder.text(appName);
        });
        builder.element('version', nest: () {
          builder.text(appVersion);
        });
        builder.element('user', nest: () {
          builder.text(appUser);
        });
        builder.element('id', nest: () {
          builder.text(appUserId);
        });
      });

//tran
      builder.element('tran', nest: () {
        builder.element('test', nest: () {
          builder.text(testMode ? '1' : '2');
        });
        builder.element('type', nest: () {
          builder.text('auth');
        });
        builder.element('class', nest: () {
          builder.text('paypage');
        });
        builder.element('cartid', nest: () {
          builder.text(cartId);
        });
        builder.element('description', nest: () {
          builder.text(description);
        });
        builder.element('currency', nest: () {
          builder.text(currencyCode);
        });
        builder.element('amount', nest: () {
          builder.text(amount);
        });
        builder.element('language', nest: () {
          builder.text(languageCode);
        });
        builder.element('firstref', nest: () {
          builder.text('first');
        });
        builder.element('ref', nest: () {
          builder.text('null');
        });
      });

//billing
      builder.element('billing', nest: () {
// name
        builder.element('name', nest: () {
          builder.element('title', nest: () {
            builder.text('');
          });
          builder.element('first', nest: () {
            builder.text('Div');
          });
          builder.element('last', nest: () {
            builder.text('V');
          });
        });
// address
        builder.element('address', nest: () {
          builder.element('line1', nest: () {
            builder.text(customerAddress);
          });
          builder.element('city', nest: () {
            builder.text(customerCity);
          });
          builder.element('region', nest: () {
            builder.text(customerRegion);
          });
          builder.element('country', nest: () {
            builder.text(customerCountryCode);
          });
        });

        builder.element('phone', nest: () {
          builder.text(customerPhone);
        });
        builder.element('email', nest: () {
          builder.text(customerEmail);
        });
      });
    });

    final bookshelfXml = builder.buildDocument();
    pay(context, bookshelfXml, APIKey, storeID);
  }

}


