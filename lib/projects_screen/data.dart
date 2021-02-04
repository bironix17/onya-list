import 'package:flutter_onya_list/models/author_labels.dart';
import 'package:flutter_onya_list/models/project_card.dart';

class MyCardsDataModel{
  List<ProjectCardData> myCardsData ;
  List<ProjectCardData> allCardsData ;

  MyCardsDataModel(this.myCardsData, this.allCardsData);
}

class ProjectsDataTemp {
  static List<ProjectCardData> myCardsData = [
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg"], 0, false, 0, 1),
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg" , "assets/image/sky.jpg"], 2,true, 0, 2),
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg" , "assets/image/sky.jpg" , "assets/image/city.jpg"], 1, false, 0, 3),

 ];
  static List<ProjectCardData> allCardsData = [
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg"], 0, false, 0, 1),
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg" , "assets/image/sky.jpg"], 2,true, 0, 2),
    ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg" , "assets/image/sky.jpg" , "assets/image/city.jpg"], 1, false, 0, 3),

  ];


  static List<ProjectCardData> myCardsData1 = List.generate(4, (index) =>     ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg"], 0, false, 0, index ));

  static List<ProjectCardData> allCardsData1 = List.generate(4, (index) =>     ProjectCardData(AuthorLabels("Ivan", "builder", "Moscow"), "forest", "12 23 242 1 jule", ["assets/image/forest.jpg"], 0, false, 0, index ));



  static MyCardsDataModel getData() =>  MyCardsDataModel(myCardsData, allCardsData);
  static MyCardsDataModel getMoreData() =>  MyCardsDataModel(myCardsData1, allCardsData1);

}
