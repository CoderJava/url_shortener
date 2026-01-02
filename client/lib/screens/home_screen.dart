import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/qr_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _inputController = TextEditingController();
  final _apiService = ApiService();
  final _storageService = StorageService();
  bool _isLoading = false;
  LinkItem? _createdLink;
  String? _errorMessage;

  Future<void> _shortenUrl() async {
    final url = _inputController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _createdLink = null;
    });

    try {
      final link = await _apiService.shortenUrl(url);
      await _storageService.saveLink(link);
      setState(() {
        _createdLink = link;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Paste a long URL to shorten it',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Enter Long URL',
              border: OutlineInputBorder(),
              hintText: 'https://example.com/very/long/url',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _shortenUrl,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Shorten URL'),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 20),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
          if (_createdLink != null) ...[
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              'Shortened URL:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(
              '${ApiConstants.baseUrl}/${_createdLink!.slug}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: QrDisplay(
                data: '${ApiConstants.baseUrl}/${_createdLink!.slug}',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
