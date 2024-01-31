import 'dart:io';

import 'package:apod/helpers/connection_helper.dart';
import 'package:apod/presentation/cubits/apod_cubit.dart';
import 'package:apod/presentation/cubits/images_cubit.dart';
import 'package:apod/presentation/cubits/images_state.dart';
import 'package:apod/database_service.dart';
import 'package:apod/models/apod.dart';
import 'package:apod/presentation/apod_page.dart';
import 'package:apod/presentation/cubits/apod_state.dart';
import 'package:apod/helpers/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:apod/data/apod_remote_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final DatabaseService database;

  const HomePage({
    super.key,
    required this.database,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BrazilianDateFormat brazilianDateFormat = BrazilianDateFormat();
  ConnectionHelper connectionHelper = ConnectionHelper();
  final double imageWidth = 100;
  final double imageHeight = 100;
  late ApodCubit apodCubit;
  late ImagesCubit imagesCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ApodCubit>(
              create: (context) => ApodCubit(
                ApodRemoteDataSource(),
              ),
            ),
            BlocProvider<ImagesCubit>(
              create: (context) => ImagesCubit(
                database: widget.database,
              ),
            ),
          ],
          child: BlocConsumer<ApodCubit, ApodState>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {}
            },
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Search APODS',
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

                              final verify =
                                  await connectionHelper.checkConnection();

                              if (verify) {
                                await BlocProvider.of<ApodCubit>(context)
                                    .getApods(startDate, endDate);

                                for (var apod in state.apods!) {
                                  await BlocProvider.of<ImagesCubit>(context)
                                      .saveImage(apod, startDate, endDate);
                                }
                              } else {
                                loadImagesIfDatesPicked(
                                    startDate, endDate, context);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: connectionHelper.checkConnection(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.data == false) {
                        return Expanded(
                          child: buildImagesBlocBuilder(),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.apods!.length,
                            itemBuilder: (context, index) {
                              final apod = state.apods![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ApodPage(apod: apod),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Colors.black,
                                  surfaceTintColor: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(22),
                                          child: Text(
                                            apod.title,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: LeadingImage(
                                            isFromWeb: true,
                                            apod: apod,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Divider(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LeadingImage extends StatelessWidget {
  final Apod apod;
  final bool isFromWeb;
  const LeadingImage({
    super.key,
    required this.apod,
    required this.isFromWeb,
  });

  @override
  Widget build(BuildContext context) {
    if (isFromWeb) {
      return Image.network(
        apod.url,
        fit: BoxFit.cover,
        width: 300,
        height: 300,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Image'));
        },
      );
    } else {
      return Image(
        image: FileImage(File(
          apod.path!,
        )),
        fit: BoxFit.cover,
        width: 300,
        height: 300,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text('No Image'));
        },
      );
    }
  }
}

void loadImagesIfDatesPicked(DateTime start, DateTime end, BuildContext _) {
  BlocProvider.of<ImagesCubit>(_, listen: false).loadImages(start, end);
}

Widget buildImagesBlocBuilder() {
  return BlocBuilder<ImagesCubit, ImagesState>(
    builder: (context, state) {
      if (state.images!.isNotEmpty) {
        return Expanded(
            child: ListView.builder(
          itemCount: state.images!.length,
          itemBuilder: (context, index) {
            final apod = state.images![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApodPage(apod: apod),
                  ),
                );
              },
              child: Card(
                color: Colors.black,
                surfaceTintColor: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Text(
                          apod.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LeadingImage(
                          isFromWeb: false,
                          apod: apod,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
      } else if (state.errorMessage.isNotEmpty) {
        return const Center(
          child: Text(
            'There was a problem loading the images. Please check your spaceship\'s communication system and try again.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return const Center(
          child: Text(
            'Your spaceship is out of communication with the planet earth, but you can see the images that were saved the last time you were in contact!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    },
  );
}
