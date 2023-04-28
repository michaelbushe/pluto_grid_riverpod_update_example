// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:pluto_grid_riverpod_example/job_columns.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';

class JobsGrid extends ConsumerWidget {
  const JobsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Rebuilding job grid');
    final jobsStream = ref.watch(jobsStreamProvider);
    return jobsStream.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (jobEntries) {
          final List<PlutoRow> rows = jobEntries.map(rowBuilder).toList();
          return SizedBox(
            height: 600,
            child: PlutoGrid(
              //even though the rows and cells have keys,
              // the pluto grid itself need it's own key that changes on the row
              // key: ObjectKey(rows),
              noRowsWidget: const Text('You have no jobs entered.'),
              columns: createJobColumns(),
              rows: [...rows],
              configuration: const PlutoGridConfiguration(),
            ),
          );
        });
  }

  PlutoRow rowBuilder(Job job) => PlutoRow(key: ObjectKey(job), cells: {
        'id': PlutoCell(value: job.id, key: ValueKey('${job.id}-id')),
        'name': PlutoCell(value: job.name, key: ValueKey('${job.id}-name')),
        'ratePerHour':
            PlutoCell(value: job.ratePerHour, key: ValueKey('${job.id}-rate')),
        'actions': PlutoCell(value: '', key: ValueKey('${job.id}-actions')),
      });
}
