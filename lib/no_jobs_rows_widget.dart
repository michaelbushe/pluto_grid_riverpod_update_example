import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';

class NoJobsRowsWidget extends ConsumerWidget {
  const NoJobsRowsWidget({
    super.key,
  });

  static int lastRate = 99;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('You have no jobs entered.'),
            IconButton(
              iconSize: 40,
              onPressed: () async {
                var nextId = lastRate++;
                var nextIdString = '$lastRate';
                final success = await ref
                    .read(jobsRepositoryProvider)
                    .addJob(name: nextIdString, ratePerHour: nextId);
              },
              icon: const Icon(
                Icons.add_photo_alternate_rounded,
                size: 18.0,
              ),
            ),
            const SelectableText('Click to add a the first job.'),
          ],
        ),
      ),
    );
  }
}
