part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchNotesEvent extends NotesEvent{}

class PostNotesEvent extends NotesEvent{
  // final int id;
  final String notes_title;
  final String notes_subtitle;

  const PostNotesEvent({ required this.notes_title, required this.notes_subtitle});
  @override
  // TODO: implement props
  List<Object?> get props => [ notes_title, notes_subtitle];


}

class DeleteNotes extends NotesEvent{
  final int id;

   DeleteNotes({required this.id});
}

class UpdateNotes extends NotesEvent{
  final int id;
  final String notes_title;
  final String notes_subtitle;

   const UpdateNotes({required this.id,required this.notes_title, required this.notes_subtitle});
  @override
  // TODO: implement props
  List<Object?> get props => [ notes_title, notes_subtitle,id];

}
