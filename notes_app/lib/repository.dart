import 'package:dio/dio.dart';

class NotesRepository{
Dio dioClient = Dio();
Future fetchNotes() async {
  try {
    final response = await dioClient.get("http://127.0.0.1:3000/notes");
    if (response.statusCode == 200) {
      print(response.statusCode);
      return response;
    }
  } catch (e) {
    return e;
  }
}

Future postNotes({var id,var notes_title,var notes_subtitle})async{
  try{
    Map data = {
      'id':id,
      'notes_title':notes_title,
      'notes_subtitle':notes_subtitle
    };
    final response = await dioClient.post("http://127.0.0.1:3000/notes",data: data);
    if (response.statusCode == 200) {
      print(response.statusCode);
      return response;
    }
  }catch(e){
    return e;
  }
}


Future deleteNotes({var id}) async {
  try {
    final response = await dioClient.delete("http://127.0.0.1:3000/notes/${id}");
    if (response.statusCode == 200) {
      print(response.statusCode);
      return response;
    }
  } catch (e) {
    return e;
  }
}

Future updateNotes({var id,var notes_title,var notes_subtitle})async{
  try{
    Map data = {
      'notes_title':notes_title,
      'notes_subtitle':notes_subtitle
    };
    final response = await dioClient.put("http://127.0.0.1:3000/notes/${id}",data: data);

    if (response.statusCode == 200) {
      print(response.statusCode);
      return response;
    }
  }catch(e){
    return e;
  }
}
}