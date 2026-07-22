import 'package:fcjanja/features/matches/cubit/cubit/cancel_match_cubit.dart';
import 'package:fcjanja/features/matches/cubit/cubit/complete_match_cubit.dart';
import 'package:fcjanja/features/matches/cubit/cubit/match_cubit.dart';
import 'package:fcjanja/features/response/presentation/attendance_page.dart';
import 'package:fcjanja/features/response/presentation/attendance_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerMatchesScreen extends StatelessWidget {
  const ManagerMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CompleteMatchCubit, CompleteMatchState>(
          listener: (context, state) {
            if (state is CompleteMatchSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Match completed.")));

              context.read<MatchCubit>().loadMatches();
            }

            if (state is CompleteMatchFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<CancelMatchCubit, CancelMatchState>(
          listener: (context, state) {
            if (state is CancelMatchSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Match cancelled.")));

              context.read<MatchCubit>().loadMatches();
            }

            if (state is CancelMatchFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text("Manage Matches")),
        body: BlocBuilder<MatchCubit, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MatchFailure) {
              return Center(child: Text(state.message));
            }

            if (state is MatchLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<MatchCubit>().loadMatches(),
                child: ListView.builder(
                  itemCount: state.matches.length,
                  itemBuilder: (context, index) {
                    final match = state.matches[index];
                    final completeState = context
                        .watch<CompleteMatchCubit>()
                        .state;
                    final cancelState = context.watch<CancelMatchCubit>().state;

                    final completing =
                        completeState is CompleteMatchLoading &&
                        completeState.matchId == match.id;

                    final cancelling =
                        cancelState is CancelMatchLoading &&
                        cancelState.matchId == match.id;

                    final canModify = match.status == "SCHEDULED";

                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.opponent,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Venue: ${match.venue}"),
                            Text("Date: ${match.matchDate}"),
                            Text("Kickoff: ${match.kickoffTime}"),
                            Builder(
                              builder: (_) {
                                Color color;

                                switch (match.status) {
                                  case "COMPLETED":
                                    color = Colors.green;
                                    break;
                                  case "CANCELLED":
                                    color = Colors.red;
                                    break;
                                  default:
                                    color = Colors.orange;
                                }

                                return Row(
                                  children: [
                                    const Text(
                                      "Status: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      match.status,
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text("Attendance"),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AttendancePage(matchId: match.id),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text("Report"),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AttendanceReportPage(
                                            matchId: match.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: (!canModify || completing)
                                        ? null
                                        : () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text(
                                                  "Complete Match",
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to mark this match as completed?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("No"),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text("Yes"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true &&
                                                context.mounted) {
                                              context
                                                  .read<CompleteMatchCubit>()
                                                  .completeMatch(match.id);
                                            }
                                          },
                                    child: completing
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text("Complete"),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: (!canModify || cancelling)
                                        ? null
                                        : () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text(
                                                  "Cancel Match",
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to cancel this match?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("No"),
                                                  ),
                                                  FilledButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text("Yes"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true &&
                                                context.mounted) {
                                              context
                                                  .read<CancelMatchCubit>()
                                                  .cancelMatch(match.id);
                                            }
                                          },
                                    child: cancelling
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text("Cancel"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
