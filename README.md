<img src="https://skillicons.dev/icons?i=flutter,dart" />
<br>

# Telr Payment Gateway Plus
Telr Payment Gateway Plus is a Flutter package that provides a seamless integration with the Telr payment gateway, allowing you to process payments easily within your Flutter apps. This package simplifies the integration by handling the communication between your app and the Telr API.

## Table of Contents
1. Overview
2. Features
3. Installation
4. Usage
5. Configuration
6. Contributing
7. License
   
## Overview
The Telr Payment Gateway Plus package enables developers to integrate Telr’s payment processing functionality into their Flutter apps. With support for multiple payment methods, this package provides a flexible and secure solution for handling transactions.

## Features
Easy setup: Quickly integrate Telr payments with minimal code.

Support for various payment methods: Credit cards, debit cards, and more.

Secure: Communicates with Telr API using secure protocols.

Customizable UI: You can customize the payment experience to fit your app’s design.

Transaction management: Support for starting, completing, and tracking payment statuses.

## Installation
To use this package, add telr_payment_gateway_plus as a dependency in your pubspec.yaml file:
````
dependencies:
  telr_payment_gateway_plus: ^1.0.0
````
Then, run the following command in your project directory:
```
flutter pub get
```

## Usage
Here’s a basic example to get you started with Telr Payment Gateway Plus:
````
import 'package:telr_payment_gateway_plus/telr_payment_gateway_plus.dart';

void initiatePayment() {
  TelrPaymentGatewayPlus.initiatePayment(
    amount: 100.00,
    currency: 'AED',
    customerName: 'John Doe',
    customerEmail: 'johndoe@example.com',
    onSuccess: (response) {
      print('Payment successful: ${response.transactionId}');
    },
    onError: (error) {
      print('Payment failed: $error');
    },
  );
}
````

## Example
To see a full example of how to integrate and customize Telr payment processing in your app, check the example directory in the repository.

## Configuration
Before using the package, you need to configure your Telr merchant credentials and other necessary parameters.

Add your credentials in the appropriate place in your app:
````
TelrPaymentGatewayPlus.configure(
  merchantId: 'your_merchant_id',
  storeId: 'your_store_id',
  authKey: 'your_auth_key',
);
````

## Contributing
We welcome contributions to improve this package. Please follow the steps below:

1. Fork the repository.
2. Create a new branch: ```git checkout -b feature-name```.
3. Make your changes and commit them: ```git commit -m 'Add some feature'```.
4. Push to the branch: ```git push origin feature-name```.
5. Open a pull request.
   
##  License
This package is licensed under the MIT License. See the LICENSE file for details.
