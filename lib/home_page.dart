import 'package:apod/apod_page.dart';
import 'package:apod/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:apod/apod.dart';
import 'package:apod/apod_remote_datasource.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Apod> _apods = [];
  bool _loading = false;
  BrazilianDateFormat brazilianDateFormat = BrazilianDateFormat();
  final double imageWidth = 100; // Adjust the width to the desired value
  final double imageHeight = 100; // Adjust the height to the desired value

  final ApodRemoteDataSource _dataSource = ApodRemoteDataSource();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchApods() async {
    setState(() {
      _loading = true;
    });
    try {
      List<Apod> apods = await _dataSource.getApods(_startDate, _endDate);
      setState(() {
        _apods = apods;
      });
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
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
                        setState(() {
                          _startDate = picked.start;
                          _endDate = picked.end;
                        });
                        if (mounted) {
                          _fetchApods();
                        }
                      }
                    }),
              ],
            ),
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Expanded(
              child: ListView.builder(
            itemCount: _apods.length,
            itemBuilder: (context, index) {
              final apod = _apods[index];
              if (apod.url == null) {
                return ListTile(
                  title: Text(apod.title),
                  subtitle: Text(_startDate != null
                      ? brazilianDateFormat.format(_startDate!)
                      : 'Tap to select'),
                  leading: SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: const Center(child: Text('Image Not Available')),
                  ),
                  onTap: () {},
                );
              } else {
                return ListTile(
                  title: Text(apod.title),
                  subtitle: Text(_startDate != null
                      ? brazilianDateFormat.format(_startDate!)
                      : 'Tap to select'),
                  leading: SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.network(
                      apod.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Sem imagem'));
                      },
                    ),
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
              }
            },
          )),
        ],
      ),
    );
  }
}
