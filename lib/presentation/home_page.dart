import 'dart:io';
import 'package:apod/connection_helper.dart';
import 'package:apod/cubits/apod_cubit.dart';
import 'package:apod/data/apod_local_datasource.dart';
import 'package:apod/presentation/apod_page.dart';
import 'package:apod/cubits/apod_state.dart';
import 'package:apod/helpers/date_formatter.dart';
import 'package:apod/helpers/path_provider_save_images.dart';
import 'package:flutter/material.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BrazilianDateFormat brazilianDateFormat = BrazilianDateFormat();
  final double imageWidth = 100;
  final double imageHeight = 100;
  bool isInternetUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) =>
            ApodCubit(ApodRemoteDataSource(), ApodLocalDataSource()),
        child: BlocConsumer<ApodCubit, ApodState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {}
          },
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Busca de APOD por data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2022, 6, 16),
                            lastDate: DateTime.now(),
                          );

                          if (picked != null) {
                            final startDate = picked.start;
                            final endDate = picked.end;
                            if (mounted) {
                              BlocProvider.of<ApodCubit>(context)
                                  .getApods(startDate, endDate);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.apods!.length,
                    itemBuilder: (context, index) {
                      final apod = state.apods![index];
                      return ListTile(
                        title: Text(
                          apod.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(state.startDate != null
                            ? brazilianDateFormat.format(state.startDate!)
                            : 'Tap to select'),
                        leading: isInternetUrl(apod.url)
                            ? Image.network(
                                apod.url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child: Text('Sem imagem'));
                                },
                              )
                            : FutureBuilder<String>(
                                future: getFilePath('apod_${apod.date}.jpg'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('Sem imagem'));
                                    } else {
                                      return Image.file(
                                        File(snapshot.data!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Text('Sem imagem'));
                                        },
                                      );
                                    }
                                  } else {
                                    // O caminho do arquivo ainda está sendo obtido. Exiba um indicador de progresso.
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApodPage(apod: apod),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.apods!.length,
                    itemBuilder: (context, index) {
                      final apod = state.apods![index];
                      return ListTile(
                        title: Text(
                          apod.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(state.startDate != null
                            ? brazilianDateFormat.format(state.startDate!)
                            : 'Tap to select'),
                        leading: FutureBuilder<bool>(
                          future: hasInternetConnection(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == true) {
                                return Image.network(
                                  apod.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Text('Sem imagem'));
                                  },
                                );
                              } else {
                                return FutureBuilder<String>(
                                  future: getFilePath('apod_${apod.date}.jpg'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      // O caminho do arquivo foi obtido com sucesso. Carregue a imagem.
                                      return Image.file(
                                        File(snapshot.data!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Text('Sem imagem'));
                                        },
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                );
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApodPage(apod: apod),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
