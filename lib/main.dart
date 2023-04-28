import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/firebase_options.dart';
import 'package:pluto_grid_riverpod_example/grid_builder.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:pluto_grid_riverpod_example/job_columns.dart';
import 'package:pluto_grid_riverpod_example/jobs_grid.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';
import 'package:pluto_grid_riverpod_example/list_items_builder.dart';
import 'package:pluto_grid_riverpod_example/no_jobs_rows_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
          title: 'Pluto Grid does not update with Riverpod stream Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            body: Consumer(builder: (context, ref, child) {
              final jobsStream = ref.watch(jobsStreamProvider);
              print('rebuild main');
              return SingleChildScrollView(
                  child: Column(children: [
                SizedBox(
                  height: 300,
                  child: JobGridBuilder(jobsStream: jobsStream),
                ),
                SizedBox(
                  height: 300,
                  child: JobsGrid(jobsStream),
                ),
                SizedBox(
                  height: 200,
                  child: ListItemsBuilder<Job>(
                    data: jobsStream,
                    itemName: 'Jobs',
                    itemBuilder: (context, job) => Text(job.name),
                  ),
                )
              ]));
            }),
          )),
    );
  }
}

class JobGridBuilder extends ConsumerWidget {
  const JobGridBuilder({
    super.key,
    required this.jobsStream,
  });

  final AsyncValue<List<Job>> jobsStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var jobColumns = createJobColumns(ref);
    return GridBuilder<Job>(
      data: jobsStream,
      noRowsWidget: const NoJobsRowsWidget(),
      columns: jobColumns,
      rowsBuilder: (data) {
        List<PlutoRow> rows = [];
        for (final job in data) {
          rows.add(PlutoRow(cells: {
            'id': PlutoCell(value: job.id),
            'name': PlutoCell(value: job.name),
            'ratePerHour': PlutoCell(value: job.ratePerHour),
          }));
        }
        return rows;
      },
    );
  }
}
