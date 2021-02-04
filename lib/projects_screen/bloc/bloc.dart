import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/common/enams.dart';
import 'package:flutter_onya_list/list/data.dart';
import 'package:flutter_onya_list/models/project_card.dart';
import 'package:flutter_onya_list/projects_screen/bloc/event.dart';
import 'package:flutter_onya_list/projects_screen/bloc/state.dart';
import 'package:flutter_onya_list/projects_screen/data.dart';
import 'package:rxdart/rxdart.dart';



class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState>{

  ProjectsBloc() : super(LoadState(_filtersClicked));

  Map<TabNames, List<ProjectCardData>> projectCardData  = {};

  static Map<FiltersTypes, bool> _filtersClicked =
      Map.fromEntries(FiltersTypes.values.map((e) => MapEntry(e, false)));

  Stream<Transition<ProjectsEvent, ProjectsState>>
  transformEvents(events, transitionFn) {
    final nonDebounceStream =
    events.where((event) => event is! SearchCardsEvent);

    final debounceStream = events
        .where((event) => event is SearchCardsEvent)
        .debounceTime(Duration(milliseconds: 3000));

    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }


  LoadingNow isLoadingNowTabCards = LoadingNow.NotLoading;

  @override
  Stream<ProjectsState> mapEventToState(ProjectsEvent event) async*{

    if (event is LoadMoreCardsEvent) {
      if (isLoadingNowTabCards == LoadingNow.NotLoading) {
        isLoadingNowTabCards = LoadingNow.Loading;
        Future.delayed(Duration(seconds: 1),()=>add(LoadedMoreCardsEvent(event.tabName)));
      }
    }

    if (event is LoadedMoreCardsEvent) {
      MyCardsDataModel tempData = ProjectsDataTemp.getMoreData();

      final tempDataInMap = {
        TabNames.myProjects: tempData.myCardsData,
        TabNames.allProjects: tempData.allCardsData
      };

      projectCardData[event.tabName].addAll(tempDataInMap[event.tabName]);
      isLoadingNowTabCards = LoadingNow.NotLoading;
      yield NormalState(projectCardData, _filtersClicked);
    }

    if (event is LoadCardsEvent) {
      MyCardsDataModel tempData = ProjectsDataTemp.getData();
      projectCardData = {
        TabNames.myProjects: tempData.myCardsData,
        TabNames.allProjects: tempData.allCardsData
      };
      yield NormalState(projectCardData, _filtersClicked);
    }


    if (event is EndDrawerClickItemEvent){

      List<FiltersTypes> radioFilters= [FiltersTypes.MostRecent, FiltersTypes.MostPopular, FiltersTypes.MostComments];
      _filtersClicked[event.filterType] = !_filtersClicked[event.filterType];

      if (radioFilters.contains(event.filterType)){
        radioFilters.where((element) => element.index != event.filterType.index).forEach((element) {_filtersClicked[element] = false;});
      }

      yield NormalState(projectCardData, _filtersClicked);
    }//  без бизнес логики


    if (event is EndDrawerClearItemsEvent){
      _filtersClicked.forEach((FiltersTypes key,bool value) { _filtersClicked[key] = false;});
      yield NormalState(projectCardData, _filtersClicked);
    }//  без бизнес логики


    if (event is UpvoteClickEvent){

      int votesProjectCard; // типа ща будет запрос к серваку
      int userVote = 0;

      projectCardData.forEach((TabNames key, List<ProjectCardData> value) {
        value.where((ProjectCardData element) => element.id == event.cardDataId).forEach((e) {

          userVote = e.clicked ? -1 : 1;
          e.loadingVotes = true;

          votesProjectCard = e.votes + userVote; // типа ответ от сервера
        });
        });

      Future.delayed(Duration(seconds: 1),()=>add(UpvoteServerRepliedEvent(event.cardDataId, votesProjectCard)));
      yield NormalState(projectCardData, _filtersClicked);
    }


    if (event is UpvoteServerRepliedEvent){

      projectCardData.forEach((TabNames key, List<ProjectCardData> value) {
        value.where((ProjectCardData element) => element.id == event.cardDataId).forEach((e) {

          e.loadingVotes = false;
          e.clicked = !e.clicked;
          e.votes = event.votes;

        });
      });

      yield NormalState(projectCardData, _filtersClicked);
    }


    if (event is CloseEndDrawer){
     // print("ZZZZZZZZZZZZZZZZZZZZZZZZZZ");
    }


    if (event is SearchCardsEvent) {

      if (event.request.isEmpty)
        yield NormalState(projectCardData, _filtersClicked);
      else
        yield NormalState(
            projectCardData.map((TabNames key, List<ProjectCardData> value) =>
                MapEntry<TabNames, List<ProjectCardData>>(
                    key,
                    value
                        .where((element) =>
                            element.cardName.contains(event.request))
                        .toList())),
            _filtersClicked);
    }
  }

}