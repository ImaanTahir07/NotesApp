import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {

  NotesBloc() : super(NotesState()) {
    on<FetchNotesEvent>(fetchNotesList);
    on<PostNotesEvent>(postNotes);
    on<DeleteNotes>(deleteNotes);
    on<UpdateNotes>(updateNotes);
  }

  FutureOr<void> fetchNotesList(FetchNotesEvent event, Emitter<NotesState> emit) async{
    print("object");
    emit(state.copyWith(isLoading: true, error: ''));
    final response = await NotesRepository().fetchNotes();
    if(response.statusCode==200){
      print("API hitted");
      print(response.data);
      emit(state.copyWith(notes: response.data,isLoading: false ));
    }else{
      print(response.statusCode);
      emit(state.copyWith(isLoading: false,error: "unable to load notes" ));
    }


  }

  FutureOr<void> postNotes(PostNotesEvent event, Emitter<NotesState> emit) async{
    emit(state.copyWith(isLoading: true));
    final response = await NotesRepository().postNotes( notes_subtitle: event.notes_subtitle, notes_title: event.notes_title);

    if(response.statusCode==200){
      emit(state.copyWith(isLoading: false));
      print("Notes Posted");

    }else{
      emit(state.copyWith(isLoading: false, error: "Unable to post notes to DB"));
    }
  }

  FutureOr<void> deleteNotes(DeleteNotes event, Emitter<NotesState> emit) async{
    emit(state.copyWith(isLoading: true));
    final response = await NotesRepository().deleteNotes(id: event.id);
    if(response.statusCode==200){
      emit(state.copyWith(isLoading: false));
    }else{
      emit(state.copyWith(isLoading: false,error: "Unable to Delete the note"));
    }
  }

  FutureOr<void> updateNotes(UpdateNotes event, Emitter<NotesState> emit) async{
    emit(state.copyWith(isLoading: true));
    final response = await NotesRepository().updateNotes(notes_subtitle: event.notes_subtitle, notes_title: event.notes_title,id: event.id);
    if(response.statusCode == 200){
      print(response.statusCode);
      print("Notes Updated!");
      emit(state.copyWith(isLoading: false));
    }else{
      emit(state.copyWith(isLoading: false));
      print("error occured");
    }
  }
}
