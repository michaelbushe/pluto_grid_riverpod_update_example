import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';

import 'job.dart';

List<PlutoColumn> createJobColumns() {
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
        final jobId = rendererContext.row.cells["id"]?.value as JobID;
        return DeleteJobButton(jobID: jobId);
      },
    )
  ];
}

class DeleteJobButton extends ConsumerWidget {
  final JobID jobID;

  const DeleteJobButton({
    required this.jobID,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
      ),
      onPressed: () async {
        await ref.read(jobsRepositoryProvider).deleteJob(jobId: jobID);
      },
      iconSize: 18,
      color: Colors.green,
      padding: const EdgeInsets.all(0),
    );
  }
}
