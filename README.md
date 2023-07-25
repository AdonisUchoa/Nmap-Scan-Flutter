# Nmap Scanner App

The Nmap Scanner App is a simple Flutter application that allows users to scan a host or IP address for open ports using the Nmap TCP scanner library. It displays the open ports along with their corresponding service names.

## Features

- Scan a host or IP address for open ports.
- Display the open ports and their corresponding service names.
- Real-time scan progress and loading indicator.

## Dependencies

- [tcp_scanner: ^2.0.5](https://pub.dev/packages/tcp_scanner) - A simple and fast TCP scanner for Flutter.
- [flutter_spinkit: ^5.1.0](https://pub.dev/packages/flutter_spinkit) - A collection of loading indicators for Flutter.
- [network_info_plus: ^4.0.1](https://pub.dev/packages/network_info_plus) - A Flutter plugin to access various information about the mobile device's network.

## Screenshots

<!-- Add screenshots of the app in action here -->

## Getting Started

1. Clone the repository: `git clone https://github.com/yourusername/nmap_scanner_app.git`
2. Change directory to the app folder: `cd nmap_scanner_app`
3. Install dependencies: `flutter pub get`
4. Run the app on a connected device: `flutter run`

## Usage

1. Enter a host or IP address in the provided text field.
2. Click on the "Scan Ports" button to start the scan.
3. While scanning, a progress indicator will be displayed, showing the progress of the scan.
4. Once the scan is completed, the open ports and their corresponding service names will be displayed.

## Contributing

Contributions are welcome! If you find a bug or want to add a new feature, please open an issue or submit a pull request.

## License

The Nmap Scanner App is open-source software licensed under the [MIT License](https://opensource.org/licenses/MIT).
