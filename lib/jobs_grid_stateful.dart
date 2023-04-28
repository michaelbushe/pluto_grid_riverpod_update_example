// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:pluto_grid_riverpod_example/job_columns.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';

class JobsGridStateful extends ConsumerStatefulWidget {
  const JobsGridStateful({super.key});

  static const plutoStatefulGridKey =
      GlobalObjectKey('jobs pluto stateful grid');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return JobsGridStatefulState();
  }
}

class JobsGridStatefulState extends ConsumerState<JobsGridStateful> {
  @override
  Widget build(BuildContext context) {
    print('Rebuilding job grid');
    final jobsStream = ref.watch(jobsStreamProvider);
    return jobsStream.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (jobEntries) {
          print('When job stateful grid');
          final List<PlutoRow> rows = jobEntries.map(rowBuilder).toList();
          return SizedBox(
            height: 600,
            child: PlutoGrid(
              key: JobsGridStateful.plutoStatefulGridKey,
              noRowsWidget: const Text('You have no jobs entered.'),
              columns: createJobColumns(),
              rows: rows,
              configuration: const PlutoGridConfiguration(),
            ),
          );
        });
  }

  PlutoRow rowBuilder(Job job) => PlutoRow(cells: {
        'id': PlutoCell(value: job.id),
        'name': PlutoCell(value: job.name),
        'ratePerHour': PlutoCell(value: job.ratePerHour),
        'actions': PlutoCell(value: ''),
      });
}
