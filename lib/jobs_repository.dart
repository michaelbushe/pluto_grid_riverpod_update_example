import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_grid_riverpod_example/job.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jobs_repository.g.dart';

class JobsRepository {
  const JobsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String jobPath(String jobId) => 'jobs/$jobId';
  static String jobsPath() => 'jobs';

  // create
  Future<void> addJob({required String name, required int ratePerHour}) =>
      _firestore.collection(jobsPath()).add({
        'name': name,
        'ratePerHour': ratePerHour,
      });

  // update
  Future<void> updateJob({required Job job}) =>
      _firestore.doc(jobPath(job.id)).update(job.toMap());

  // delete
  Future<void> deleteJob({required JobID jobId}) async {
    final jobRef = _firestore.doc(jobPath(jobId));
    await jobRef.delete();
  }

  // read
  Stream<Job> watchJob({required JobID jobId}) => _firestore
      .doc(jobPath(jobId))
      .withConverter<Job>(
        fromFirestore: (snapshot, _) =>
            Job.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (job, _) => job.toMap(),
      )
      .snapshots()
      .map((snapshot) => snapshot.data()!);

  Stream<List<Job>> watchJobs() => queryJobs()
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Job> queryJobs() => _firestore.collection(jobsPath()).withConverter(
        fromFirestore: (snapshot, _) =>
            Job.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (job, _) => job.toMap(),
      );

  Future<List<Job>> fetchJobs() async {
    final jobs = await queryJobs().get();
    return jobs.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
JobsRepository jobsRepository(JobsRepositoryRef ref) {
  return JobsRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Job> jobsQuery(JobsQueryRef ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.queryJobs();
}

@riverpod
Stream<List<Job>> jobsStream(JobsStreamRef ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.watchJobs();
}

@riverpod
Stream<Job> jobStream(JobStreamRef ref, JobID jobId) {
  final repository = ref.watch(jobsRepositoryProvider);
  return repository.watchJob(jobId: jobId);
}
