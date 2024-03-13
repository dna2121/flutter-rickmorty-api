import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_api/views/detail.dart';
import 'package:rick_morty_api/views/error_screen.dart';
import 'package:rick_morty_api/views/loading_screen.dart';
import 'package:rick_morty_api/models/rick_morty.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RickMorty? _rickMortyResponses;

  bool _isLoading = true;
  String onError = '';

  @override
  void initState() {
    _fetchApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("rick n morty"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const LoadingScreen()
            : onError.isNotEmpty
                ? ErrorScreen(
                    message: onError,
                    onPressed: () => _fetchApi(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _fetchApi(),
                    child: ListScreen(rickMortyResponses: _rickMortyResponses),
                  ),
      ),
    );
  }

  _fetchApi() async {
    setState(() {
      _isLoading = true;
      onError = '';
    });
    final options = BaseOptions(baseUrl: "https://rickandmortyapi.com/api");
    final dio = Dio(options);

    try {
      final response = await dio.get('/character');
      final responseData = response.data;
      final responseApi = RickMorty.fromJson(responseData);

      setState(() {
        _rickMortyResponses = responseApi;
        _isLoading = false;
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

class ListScreen extends StatelessWidget {
  const ListScreen({
    super.key,
    required RickMorty? rickMortyResponses,
  }) : _rickMortyResponses = rickMortyResponses;

  final RickMorty? _rickMortyResponses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _rickMortyResponses?.results.length ?? 0,
      itemBuilder: (context, index) {
        final result = _rickMortyResponses?.results[index];

        return Row(
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(charId: result!.id),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    result?.image ?? '',
                    height: 150,
                    width: 150,
                  )),
            ),
            const SizedBox(width: 10),
            Text(result?.name ?? ''),
          ],
        );
      },
    );
  }
}
