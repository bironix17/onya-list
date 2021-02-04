

import 'package:flutter_onya_list/common/enams.dart';

abstract class ProjectsEvent{}

class UpdateEvent extends ProjectsEvent{}

class AddButtonClickEvent extends ProjectsEvent{}

class LoadCardsEvent extends ProjectsEvent{

}

class EndDrawerShowEvent extends ProjectsEvent{}

class SearchCardsEvent extends ProjectsEvent{
  String request;
  SearchCardsEvent(this.request);
}

 class UpvoteClickEvent extends ProjectsEvent{
    int cardDataId;
    UpvoteClickEvent(this.cardDataId);
}

class UpvoteServerRepliedEvent extends ProjectsEvent{
  int cardDataId;
  int votes;

  UpvoteServerRepliedEvent(this.cardDataId, this.votes);
}

 class CommentClickEvent extends ProjectsEvent{
   int cardDataId;
 }

 class CardClickEvent extends ProjectsEvent{
   int cardDataId;
 }

class EndDrawerClickItemEvent extends ProjectsEvent{
  FiltersTypes filterType;

  EndDrawerClickItemEvent(this.filterType);
}

 class EndDrawerClearItemsEvent extends ProjectsEvent{
 }

 class CloseEndDrawer extends ProjectsEvent{}

 class LoadMoreCardsEvent extends ProjectsEvent{
   TabNames tabName;

   LoadMoreCardsEvent(this.tabName);
}


class LoadedMoreCardsEvent extends ProjectsEvent{
  TabNames tabName;

  LoadedMoreCardsEvent(this.tabName);
}


