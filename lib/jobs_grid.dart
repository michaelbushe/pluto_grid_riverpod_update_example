import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:pluto_grid_riverpod_example/job_columns.dart';
import 'package:pluto_grid_riverpod_example/no_jobs_rows_widget.dart';

class JobsGrid extends ConsumerWidget {
  final AsyncValue<List<Job>> jobsStream;

  const JobsGrid(this.jobsStream);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        print('Rebuilding job grid');
        return jobsStream.when(
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (jobEntries) {
              print('When job grid');
              final List<PlutoRow> rows = jobEntries.map(rowBuilder).toList();
              return SizedBox(
                height: 600,
                child: PlutoGrid(
                  noRowsWidget: const NoJobsRowsWidget(),
                  columns: createJobColumns(ref),
                  rows: rows,
                  configuration: const PlutoGridConfiguration(),
                ),
              );
            });
      },
    );
  }

  PlutoRow rowBuilder(Job job) => PlutoRow(cells: {
        'id': PlutoCell(value: job.id),
        'name': PlutoCell(value: job.name),
        'ratePerHour': PlutoCell(value: job.ratePerHour),
        'actions': PlutoCell(value: ''),
      });
}
