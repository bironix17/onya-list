
import 'package:flutter_onya_list/models/author_labels.dart';

class ProjectCardData{
  AuthorLabels authorLabels;
  String cardName;
  String date; // TODO пока что так
  List<String> imagePaths;
  int votes;
  bool clicked;
  int comments;
  bool loadingVotes = false;

  int id;

  ProjectCardData(this.authorLabels, this.cardName, this.date, this.imagePaths,
      this.votes, this.clicked, this.comments, this.id);
}