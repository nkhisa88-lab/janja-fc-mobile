import 'package:fcjanja/features/matches/cubit/cubit/create_match_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final opponentController = TextEditingController();
  final venueController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void dispose() {
    opponentController.dispose();
    venueController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateMatchCubit, CreateMatchState>(
      listener: (context, state) {
        if (state is CreateMatchFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is CreateMatchSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Match Created")));

          opponentController.clear();
          venueController.clear();
          dateController.clear();
          timeController.clear();

          FocusScope.of(context).unfocus();

          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Match")),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: opponentController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Opponent"),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: venueController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Venue"),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: dateController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Match Date (YYYY-MM-DD)",
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: timeController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (state is! CreateMatchLoading) {
                      context.read<CreateMatchCubit>().createMatch(
                        opponent: opponentController.text.trim(),
                        venue: venueController.text.trim(),
                        matchDate: dateController.text.trim(),
                        kickoffTime: timeController.text.trim(),
                      );
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Kickoff Time (HH:mm:ss)",
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is CreateMatchLoading
                        ? null
                        : () {
                            context.read<CreateMatchCubit>().createMatch(
                              opponent: opponentController.text.trim(),
                              venue: venueController.text.trim(),
                              matchDate: dateController.text.trim(),
                              kickoffTime: timeController.text.trim(),
                            );
                          },
                    child: state is CreateMatchLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Create Match"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
