part of 'notes_bloc.dart';

@immutable
class NotesState extends Equatable {
  final bool isLoading;
  final List<dynamic> notes;
  final String error;
  const NotesState({
    this.isLoading = true,
    this.notes = const [],
    this.error = ''
});
  NotesState copyWith({List<dynamic>? notes, bool? isLoading, String? error}){
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error:  error ?? this.error

    );
  }
  List<Object?> get props => [isLoading,notes,error];
}
