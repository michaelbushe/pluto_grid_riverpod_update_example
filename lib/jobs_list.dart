// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';
import 'package:pluto_grid_riverpod_example/list_items_builder.dart';

class JobsList extends ConsumerWidget {
  const JobsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Rebuilding job grid');
    final jobsStream = ref.watch(jobsStreamProvider);
    return ListItemsBuilder<Job>(
      data: jobsStream,
      itemName: 'Jobs',
      itemBuilder: (context, job) => Text(job.name),
    );
  }
}
