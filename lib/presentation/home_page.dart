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
  final double imageWidth = 100;
  final double imageHeight = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.all(16.0),
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

                            await BlocProvider.of<ApodCubit>(context)
                                .getApods(startDate, endDate);

                            for (var apod in state.apods!) {
                              await BlocProvider.of<ImagesCubit>(context)
                                  .saveImage(apod);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Counting stars...',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.apods!.length,
                    itemBuilder: (context, index) {
                      final apod = state.apods![index];
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LeadingImage extends StatelessWidget {
  const LeadingImage({
    super.key,
    required this.apod,
  });

  final Apod apod;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesCubit, ImagesState>(
      builder: (context, state) {
        if (state is ImagesLoading) {
          return Image.network(
            apod.url,
            fit: BoxFit.cover,
            width: 300,
            height: 300,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('No Image'));
            },
          );
        }

        return Image.network(
          apod.url,
          fit: BoxFit.cover,
          width: 300,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('No Image'));
          },
        );
      },
    );
  }
}
