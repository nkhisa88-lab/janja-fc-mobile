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
            const SnackBar(content: Text("Response submitted successfully.")),
          );

          context.read<MatchCubit>().loadMatches();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttendancePage(matchId: state.matchId),
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
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            if (state is MatchLoaded) {
              if (state.matches.isEmpty) {
                return const Center(
                  child: Text(
                    "No upcoming matches",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  // Phone
                  final horizontalPadding = screenWidth < 600 ? 12.0 : 24.0;

                  // Prevent cards from becoming excessively wide
                  final maxContentWidth = screenWidth > 900
                      ? 850.0
                      : screenWidth;

                  return RefreshIndicator(
                    onRefresh: () {
                      return context.read<MatchCubit>().loadMatches();
                    },

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),

                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 16,
                      ),

                      itemCount: state.matches.length,

                      itemBuilder: (context, index) {
                        final match = state.matches[index];

                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: maxContentWidth,
                            ),

                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),

                              child: Padding(
                                padding: EdgeInsets.all(
                                  screenWidth < 600 ? 16 : 24,
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      match.opponent,
                                      style: TextStyle(
                                        fontSize: screenWidth < 600 ? 22 : 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    _MatchInfoRow(
                                      icon: Icons.location_on,
                                      label: "Venue",
                                      value: match.venue,
                                    ),

                                    const SizedBox(height: 8),

                                    _MatchInfoRow(
                                      icon: Icons.calendar_today,
                                      label: "Date",
                                      value: match.matchDate,
                                    ),

                                    const SizedBox(height: 8),

                                    _MatchInfoRow(
                                      icon: Icons.access_time,
                                      label: "Kickoff",
                                      value: match.kickoffTime,
                                    ),

                                    const SizedBox(height: 8),

                                    _MatchInfoRow(
                                      icon: Icons.info_outline,
                                      label: "Status",
                                      value: match.status,
                                    ),

                                    const SizedBox(height: 24),

                                    BlocBuilder<
                                      RespondMatchCubit,
                                      RespondMatchState
                                    >(
                                      builder: (context, respondState) {
                                        final loading =
                                            respondState
                                                is RespondMatchLoading &&
                                            respondState.matchId == match.id;

                                        return LayoutBuilder(
                                          builder: (context, buttonConstraints) {
                                            final smallScreen =
                                                buttonConstraints.maxWidth <
                                                450;

                                            if (smallScreen) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 48,
                                                    child: ElevatedButton(
                                                      onPressed: loading
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                    RespondMatchCubit
                                                                  >()
                                                                  .respond(
                                                                    matchId:
                                                                        match
                                                                            .id,
                                                                    status:
                                                                        "AVAILABLE",
                                                                  );
                                                            },
                                                      child: loading
                                                          ? const SizedBox(
                                                              width: 18,
                                                              height: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            )
                                                          : const Text(
                                                              "AVAILABLE",
                                                            ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 12),

                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 48,
                                                    child: ElevatedButton(
                                                      onPressed: loading
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                    RespondMatchCubit
                                                                  >()
                                                                  .respond(
                                                                    matchId:
                                                                        match
                                                                            .id,
                                                                    status:
                                                                        "UNAVAILABLE",
                                                                  );
                                                            },
                                                      child: const Text(
                                                        "UNAVAILABLE",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }

                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 48,
                                                    child: ElevatedButton(
                                                      onPressed: loading
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                    RespondMatchCubit
                                                                  >()
                                                                  .respond(
                                                                    matchId:
                                                                        match
                                                                            .id,
                                                                    status:
                                                                        "AVAILABLE",
                                                                  );
                                                            },
                                                      child: loading
                                                          ? const SizedBox(
                                                              width: 18,
                                                              height: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            )
                                                          : const Text(
                                                              "AVAILABLE",
                                                            ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                Expanded(
                                                  child: SizedBox(
                                                    height: 48,
                                                    child: ElevatedButton(
                                                      onPressed: loading
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                    RespondMatchCubit
                                                                  >()
                                                                  .respond(
                                                                    matchId:
                                                                        match
                                                                            .id,
                                                                    status:
                                                                        "UNAVAILABLE",
                                                                  );
                                                            },
                                                      child: const Text(
                                                        "UNAVAILABLE",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MatchInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MatchInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),

        const SizedBox(width: 10),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
