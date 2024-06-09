
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/Notes/NotesBloc/notes_bloc.dart';

class NotesUI extends StatefulWidget {
  const NotesUI({super.key});

  @override
  State<NotesUI> createState() => _NotesUIState();
}

class _NotesUIState extends State<NotesUI> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<NotesBloc>().add(FetchNotesEvent());
    super.initState();
  }
  var titleController = TextEditingController();
  var subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color getRandomLighterColor() {
      Random random = Random();
      int minBrightness = 150; // Minimum value to ensure lighter colors
      return Color.fromARGB(
        255,
        minBrightness + random.nextInt(256 - minBrightness),
        minBrightness + random.nextInt(256 - minBrightness),
        minBrightness + random.nextInt(256 - minBrightness),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.error.isNotEmpty) {
            return Text(
              "error occured",
              style: GoogleFonts.poppins(color: Colors.white),
            );
          } else if (state.notes.isEmpty) {
            return Center(
              child: Text(
                "No notes available. Please add a note to get started.",
                style: GoogleFonts.poppins(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Column(
                  children: [
                    ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: state.notes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                context.read<NotesBloc>().add(
                                    DeleteNotes(id: state.notes[index]['id']));
                                context
                                    .read<NotesBloc>()
                                    .add(FetchNotesEvent());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Deleted successfully!',style: GoogleFonts.poppins(color: Colors.white),),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              background: SizedBox(
                                width: 0,
                              ),
                              secondaryBackground: Container(
                                color: Colors.red.shade900,
                                child: Align(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        " Delete",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                              key: UniqueKey(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: getRandomLighterColor(),
                                    borderRadius: BorderRadius.circular(10)),
                                // height: 125,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            width: 260,
                                            child: Text(
                                              "${state.notes[index]['notes_title'] ?? ""}",
                                              // overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _showEditNoteBottomSheet(context,state.notes[index]['notes_title'],state.notes[index]['notes_subtitle'],state.notes[index]['id']);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,bottom: 15),
                                      child: Container(
                                        width: 250,
                                        child: Text(
                                          "${state.notes[index]['notes_subtitle'] ?? ""}",

                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Adding note...'),
                ),
              );
            } else if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Note added successfully!',style: GoogleFonts.poppins(color: Colors.white),),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a Note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: subtitleController,
                  decoration: InputDecoration(
                    labelText: 'Subtitle',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String title = titleController.text;
                    final String subtitle = subtitleController.text;
                    context.read<NotesBloc>().add(PostNotesEvent(
                          notes_title: title,
                          notes_subtitle: subtitle,
                        ));
                    titleController.clear();
                    subtitleController.clear();
                    context.read<NotesBloc>().add(FetchNotesEvent());
                    Navigator.pop(context);
                  },
                  child: Text('Add Note'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditNoteBottomSheet(BuildContext context,var title,var subtitle,var id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Updating Note...'),
                ),
              );
            } else if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Note Updated successfully!',style: GoogleFonts.poppins(color: Colors.white),),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit a Note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: title,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: subtitleController,
                  decoration: InputDecoration(
                    hintText: subtitle,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotesBloc>().add(UpdateNotes(
                      id:id,
                      notes_title: titleController.text.isNotEmpty ? titleController.text : title,
                      notes_subtitle: subtitleController.text.isNotEmpty ? subtitleController.text : subtitle,

                    ));
                    titleController.clear();
                    subtitleController.clear();
                    context.read<NotesBloc>().add(FetchNotesEvent());
                    Navigator.pop(context);
                  },
                  child: Text('Edit Note'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
