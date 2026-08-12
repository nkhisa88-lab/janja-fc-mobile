import 'package:fcjanja/features/matches/cubit/cubit/create_match_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    opponentController.dispose();
    venueController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;

        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;

        timeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:'
            '${picked.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }

  void createMatch() {
    if (opponentController.text.trim().isEmpty ||
        venueController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    context.read<CreateMatchCubit>().createMatch(
      opponent: opponentController.text.trim(),
      venue: venueController.text.trim(),
      matchDate: dateController.text.trim(),
      kickoffTime: timeController.text.trim(),
    );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Match created successfully.")),
          );

          opponentController.clear();
          venueController.clear();
          dateController.clear();
          timeController.clear();

          selectedDate = null;
          selectedTime = null;

          FocusScope.of(context).unfocus();

          Navigator.pop(context);
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Match")),

          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final horizontalPadding = width < 600 ? 20.0 : 40.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: [
                          Text(
                            "Create New Match",
                            style: TextStyle(
                              fontSize: width < 600 ? 24 : 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Enter the match details below.",
                            style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 30),

                          TextField(
                            controller: opponentController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Opponent",
                              prefixIcon: Icon(Icons.sports_soccer),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: venueController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Venue",
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: dateController,
                            readOnly: true,
                            onTap: selectDate,
                            decoration: const InputDecoration(
                              labelText: "Match Date",
                              hintText: "Select match date",
                              prefixIcon: Icon(Icons.calendar_today),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller: timeController,
                            readOnly: true,
                            onTap: selectTime,
                            decoration: const InputDecoration(
                              labelText: "Kickoff Time",
                              hintText: "Select kickoff time",
                              prefixIcon: Icon(Icons.access_time),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: state is CreateMatchLoading
                                  ? null
                                  : createMatch,

                              child: state is CreateMatchLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Create Match",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
