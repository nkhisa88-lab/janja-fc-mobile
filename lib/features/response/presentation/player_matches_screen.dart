import 'package:fcjanja/features/matches/cubit/cubit/match_cubit.dart';
import 'package:fcjanja/features/response/cubit/cubit/respond_match_cubit.dart';
import 'package:fcjanja/features/response/presentation/attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerMatchesScreen extends StatelessWidget {
  const PlayerMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RespondMatchCubit, RespondMatchState>(
      listener: (context, state) {
       if (state is RespondMatchSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Response submitted successfully."),
    ),
  );

  context.read<MatchCubit>().loadMatches();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AttendancePage(
        matchId: state.matchId,
      ),
    ),
  );
}

        if (state is RespondMatchFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          context.read<RespondMatchCubit>().reset();
        }
      },

      child: Scaffold(
        appBar: AppBar(title: const Text("Upcoming Matches")),

        body: BlocBuilder<MatchCubit, MatchState>(
          builder: (context, state) {
            if (state is MatchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MatchFailure) {
              return Center(child: Text(state.message));
            }

            if (state is MatchLoaded) {
              if (state.matches.isEmpty) {
                return const Center(child: Text("No upcoming matches"));
              }

              return ListView.builder(
                itemCount: state.matches.length,
                itemBuilder: (context, index) {
                  final match = state.matches[index];

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
                          Text("Status: ${match.status}"),

                          const SizedBox(height: 20),

                          BlocBuilder<RespondMatchCubit, RespondMatchState>(
                            builder: (context, respondState) {
                              final loading =
                                  respondState is RespondMatchLoading &&
                                  respondState.matchId == match.id;

                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: loading
                                          ? null
                                          : () {
                                              context
                                                  .read<RespondMatchCubit>()
                                                  .respond(
                                                    matchId: match.id,
                                                    status: "AVAILABLE",
                                                  );
                                            },
                                      child: loading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text("AVAILABLE"),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: loading
                                          ? null
                                          : () {
                                              context
                                                  .read<RespondMatchCubit>()
                                                  .respond(
                                                    matchId: match.id,
                                                    status: "UNAVAILABLE",
                                                  );
                                            },
                                      child: const Text("UNAVAILABLE"),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
