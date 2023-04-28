import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid_riverpod_example/jobs_repository.dart';
import 'package:pluto_grid_riverpod_example/main.dart';

class AddJobButton extends ConsumerWidget {
  const AddJobButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      iconSize: 40,
      onPressed: () async {
        var nextId = lastRate;
        var nextIdString = '$lastRate';
        lastRate++;
        await ref
            .read(jobsRepositoryProvider)
            .addJob(name: nextIdString, ratePerHour: nextId);
      },
      icon: const Icon(
        Icons.work,
        size: 18.0,
      ),
    );
  }
}
