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
        appBar: AppBar(elevation: 1.0),
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
                return RefreshIndicator(
                  onRefresh: () => context.read<MatchCubit>().loadMatches(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 150),
                      Center(
                        child: Text(
                          "No matches available.",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => context.read<MatchCubit>().loadMatches(),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;

                    // Maximum width of the match list on large screens.
                    final contentWidth = screenWidth > 1000
                        ? 900.0
                        : screenWidth;

                    // On small screens buttons are stacked.
                    final wideLayout = screenWidth >= 600;

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),

                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth < 600 ? 12 : 24,
                        vertical: 16,
                      ),

                      itemCount: state.matches.length,

                      itemBuilder: (context, index) {
                        final match = state.matches[index];

                        final completeState = context
                            .watch<CompleteMatchCubit>()
                            .state;

                        final cancelState = context
                            .watch<CancelMatchCubit>()
                            .state;

                        final completing =
                            completeState is CompleteMatchLoading &&
                            completeState.matchId == match.id;

                        final cancelling =
                            cancelState is CancelMatchLoading &&
                            cancelState.matchId == match.id;

                        final canModify =
                            match.status.toUpperCase() == "SCHEDULED";

                        return Center(
                          child: SizedBox(
                            width: contentWidth,
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),

                              child: Padding(
                                padding: EdgeInsets.all(
                                  screenWidth < 600 ? 16 : 24,
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    // MATCH TITLE
                                    Text(
                                      match.opponent,
                                      style: TextStyle(
                                        fontSize: screenWidth < 600 ? 22 : 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // MATCH INFORMATION
                                    _matchInfo(
                                      icon: Icons.location_on,
                                      label: "Venue",
                                      value: match.venue,
                                    ),

                                    const SizedBox(height: 8),

                                    _matchInfo(
                                      icon: Icons.calendar_today,
                                      label: "Date",
                                      value: match.matchDate,
                                    ),

                                    const SizedBox(height: 8),

                                    _matchInfo(
                                      icon: Icons.access_time,
                                      label: "Kickoff",
                                      value: match.kickoffTime,
                                    ),

                                    const SizedBox(height: 12),

                                    // STATUS
                                    Row(
                                      children: [
                                        const Text(
                                          "Status: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        _statusText(match.status),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    // ATTENDANCE + REPORT
                                    if (wideLayout)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _attendanceButton(
                                              context,
                                              match.id,
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: _reportButton(
                                              context,
                                              match.id,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: _attendanceButton(
                                              context,
                                              match.id,
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          SizedBox(
                                            width: double.infinity,
                                            child: _reportButton(
                                              context,
                                              match.id,
                                            ),
                                          ),
                                        ],
                                      ),

                                    const SizedBox(height: 12),

                                    // COMPLETE + CANCEL
                                    if (wideLayout)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _completeButton(
                                              context,
                                              match.id,
                                              canModify,
                                              completing,
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: _cancelButton(
                                              context,
                                              match.id,
                                              canModify,
                                              cancelling,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: _completeButton(
                                              context,
                                              match.id,
                                              canModify,
                                              completing,
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          SizedBox(
                                            width: double.infinity,
                                            child: _cancelButton(
                                              context,
                                              match.id,
                                              canModify,
                                              cancelling,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

  Widget _matchInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),

        const SizedBox(width: 10),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 16),
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

  Widget _statusText(String status) {
    Color color;

    switch (status.toUpperCase()) {
      case "COMPLETED":
        color = Colors.green;
        break;

      case "CANCELLED":
        color = Colors.red;
        break;

      default:
        color = Colors.orange;
    }

    return Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  Widget _attendanceButton(BuildContext context, int matchId) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.people),
      label: const Text("Attendance"),

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AttendancePage(matchId: matchId)),
        );
      },
    );
  }

  Widget _reportButton(BuildContext context, int matchId) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.assessment),
      label: const Text("Report"),

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AttendanceReportPage(matchId: matchId),
          ),
        );
      },
    );
  }

  Widget _completeButton(
    BuildContext context,
    int matchId,
    bool canModify,
    bool completing,
  ) {
    return ElevatedButton(
      onPressed: (!canModify || completing)
          ? null
          : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Complete Match"),
                  content: const Text(
                    "Are you sure you want to mark this match as completed?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("No"),
                    ),

                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                context.read<CompleteMatchCubit>().completeMatch(matchId);
              }
            },

      child: completing
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("Complete"),
    );
  }

  Widget _cancelButton(
    BuildContext context,
    int matchId,
    bool canModify,
    bool cancelling,
  ) {
    return ElevatedButton(
      onPressed: (!canModify || cancelling)
          ? null
          : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Cancel Match"),
                  content: const Text(
                    "Are you sure you want to cancel this match?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("No"),
                    ),

                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                context.read<CancelMatchCubit>().cancelMatch(matchId);
              }
            },

      child: cancelling
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("Cancel"),
    );
  }
}
