import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tcp_scanner/tcp_scanner.dart';
import 'ports.dart'; // Import the ports.dart file containing port-to-service mappings

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NmapScannerScreen(),
    );
  }
}

class NmapScannerScreen extends StatefulWidget {
  const NmapScannerScreen({super.key});

  @override
  _NmapScannerScreenState createState() => _NmapScannerScreenState();
}

class _NmapScannerScreenState extends State<NmapScannerScreen> {
  final TextEditingController _hostController = TextEditingController();
  final List<int> _ports = List.generate(990, (i) => 10 + i)
    ..add(5000)
    ..addAll([1100, 1110]);
  final Stopwatch _stopwatch = Stopwatch();
  String _scanResult = '';
  double _scanProgress = 0.0;
  List<int> _openPorts = [];
  bool _isScanning = false; // Boolean variable to track the scanning state

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _scanPorts() async {
    final String host = _hostController.text.trim();
    if (host.isEmpty) {
      setState(() {
        _scanResult = 'Please enter a valid host or IP address.';
      });
      return;
    }

    _stopwatch.start();
    _isScanning = true; // Set scanning to true when starting the scan

    try {
      await TcpScannerTask(host, _ports, shuffle: true, parallelism: 2)
          .start()
          .asStream()
          .transform(StreamTransformer.fromHandlers(
          handleData: (report, sink) {
            // Update scan progress and open ports
            _scanProgress = 1.0; // Set scan progress to 100% after completion.
            _scanResult = 'Host ${report.host} scan completed\n'
                'Scanned ports:\t${report.ports.length}\n'
                'Open ports:\t${report.openPorts}\n'
                'Status:\t${report.status}\n'
                'Elapsed:\t${_stopwatch.elapsed}\n';
            _openPorts = report.openPorts;
            setState(() {});
            sink.add(report);
          },
          handleError: (error, stackTrace, sink) {
            // Handle errors during scan
            setState(() {
              _scanResult = 'Error: $error';
            });
            sink.addError(error, stackTrace);
          },
          handleDone: (sink) {
            // The scan is completed
            sink.close();
            _isScanning = false; // Set scanning to false when scan is completed
          }))
          .toList();
    } catch (e) {
      setState(() {
        _scanResult = 'Error: $e';
      });
      _isScanning = false; // Set scanning to false in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nmap Scanner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Enter a host or IP address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _isScanning
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () async {
                // Clear previous results
                _stopwatch.reset();
                _scanProgress = 0.0;
                _openPorts.clear();
                setState(() {});

                // Start scanning
                await _scanPorts();
              },
              child: const Text('Scan Ports'),
            ),
            const SizedBox(height: 16),
            if (_scanProgress > 0.0 && _scanProgress < 1.0)
              LinearProgressIndicator(value: _scanProgress),
            if (_scanProgress == 1.0) ...[
              Text(_scanResult),
              const SizedBox(height: 16),
              const Text('Open Ports:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _openPorts.length,
                itemBuilder: (context, index) {
                  final port = _openPorts[index];
                  final service = portServices[port] ?? 'Unknown'; // Use the portServices map
                  return ListTile(
                    title: Text('Port: $port'),
                    subtitle: Text('Service: $service'),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
