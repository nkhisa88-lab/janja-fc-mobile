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

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null) return;

    setState(() {
      selectedDate = pickedDate;

      dateController.text =
          "${pickedDate.year.toString().padLeft(4, '0')}-"
          "${pickedDate.month.toString().padLeft(2, '0')}-"
          "${pickedDate.day.toString().padLeft(2, '0')}";
    });
  }

  Future<void> selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedTime = pickedTime;

      timeController.text =
          "${pickedTime.hour.toString().padLeft(2, '0')}:"
          "${pickedTime.minute.toString().padLeft(2, '0')}:00";
    });
  }

  void createMatch() {
    if (opponentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the opponent.")),
      );
      return;
    }

    if (venueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter the venue.")));
      return;
    }

    if (dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a match date.")),
      );
      return;
    }

    if (timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a kickoff time.")),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Match Created")));

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

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: opponentController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Opponent",
                    prefixIcon: Icon(Icons.sports_soccer),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: venueController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Venue",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: dateController,
                  readOnly: true,
                  onTap: selectDate,
                  decoration: const InputDecoration(
                    labelText: "Match Date",
                    hintText: "Select match date",
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: timeController,
                  readOnly: true,
                  onTap: selectTime,
                  decoration: const InputDecoration(
                    labelText: "Kickoff Time",
                    hintText: "Select kickoff time",
                    prefixIcon: Icon(Icons.access_time),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is CreateMatchLoading ? null : createMatch,
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
