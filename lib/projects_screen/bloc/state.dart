
import 'package:flutter_onya_list/models/project_card.dart';

import '../../common/enams.dart';

abstract class ProjectsState{
  Map<FiltersTypes, bool> filtersClicked;

  ProjectsState(this.filtersClicked);
}

//class InitState extends ProjectState{}

class LoadState extends ProjectsState{
  LoadState(filtersClicked) : super(filtersClicked);
}

class NormalState extends ProjectsState{
  Map<TabNames ,List<ProjectCardData>> projectsCardsData;

  NormalState(this.projectsCardsData, filtersClicked) : super(filtersClicked);
}

class ErrorState extends ProjectsState{


  ErrorState(filtersClicked) : super(filtersClicked);
}
