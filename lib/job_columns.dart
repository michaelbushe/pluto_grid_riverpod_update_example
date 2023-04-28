import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';

import 'job.dart';

List<PlutoColumn> createJobColumns(WidgetRef ref) {
  return [
    PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text()),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Rate Per Hour',
      field: 'ratePerHour',
      type: PlutoColumnType.currency(),
    ),
    PlutoColumn(
      title: 'Actions',
      field: 'actions',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        return Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: () async {
                JobID jobID = rendererContext.row.cells["id"]?.value as JobID;
                await ref.read(jobsRepositoryProvider).deleteJob(jobId: jobID);
              },
              iconSize: 18,
              color: Colors.green,
              padding: const EdgeInsets.all(0),
            ),
          ],
        );
      },
    )
  ];
}
