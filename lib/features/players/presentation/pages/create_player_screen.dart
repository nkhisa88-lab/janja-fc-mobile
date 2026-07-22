import 'package:fcjanja/features/players/cubit/cubit/create_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePlayerScreen extends StatefulWidget {
  const CreatePlayerScreen({super.key});

  @override
  State<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePlayerCubit, CreatePlayerState>(
      listener: (context, state) async {
        if (state is CreatePlayerFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is CreatePlayerSuccess) {
          final response = state.response;

          await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Player Created"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Activation Code",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 16),

                    SelectableText(
                      response.activationCode,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: response.activationCode),
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Activation code copied")),
                      );
                    },
                    child: const Text("Copy"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          );

          fullNameController.clear();
          phoneController.clear();

          FocusScope.of(context).requestFocus(FocusNode());
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Player")),

          body: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Player Name"),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (state is! CreatePlayerLoading) {
                      context.read<CreatePlayerCubit>().createPlayer(
                        fullName: fullNameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                      );
                    }
                  },
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: state is CreatePlayerLoading
                        ? null
                        : () {
                            context.read<CreatePlayerCubit>().createPlayer(
                              fullName: fullNameController.text.trim(),
                              phoneNumber: phoneController.text.trim(),
                            );
                          },

                    child: state is CreatePlayerLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Create Player"),
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
