import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_api/models/character.dart';

import 'error_screen.dart';
import 'loading_screen.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.charId});

  final int charId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Character? _characterResponse;

  bool _isLoading = true;
  String onError = '';

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_characterResponse == null ? "" : _characterResponse!.name),
      ),
      body: _isLoading
          ? const LoadingScreen()
          : onError.isNotEmpty
              ? ErrorScreen(
                  message: onError,
                  onPressed: () => _fetchDetail(),
                )
              : Center(
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(_characterResponse?.image ?? '')),
                      const SizedBox(height: 10),
                      Text(
                        _characterResponse?.name ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _characterResponse?.species ?? '',
                      )
                    ],
                  ),
              ),
    );
  }

  _fetchDetail() async {
    setState(() {
      _isLoading = true;
      onError = '';
    });
    final options = BaseOptions(baseUrl: "https://rickandmortyapi.com/api");
    final dio = Dio(options);

    try {
      final response = await dio.get('/character/${widget.charId}');
      final responseData = response.data;
      final responseApi = Character.fromJson(responseData);

      setState(() {
        _isLoading = false;
        _characterResponse = responseApi;
      });
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
        onError = e.message ?? 'Something happened.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        onError = e.toString();
      });
    }
  }
}
