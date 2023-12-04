import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class MyLoadMoreDelegate extends LoadMoreDelegate{
  bool isGroupChat=false;
  MyLoadMoreDelegate({this.isGroupChat=false});

  final _loadMoreIndicatorSize = 33.0;

  @override
  double widgetHeight(LoadMoreStatus status) {
    return super.widgetHeight(status);
  }

  @override
  Duration loadMoreDelay() {
    return super.loadMoreDelay();
  }

  @override
  Widget buildChild(LoadMoreStatus status, {builder = DefaultLoadMoreTextBuilder.chinese}) {
    if(status == LoadMoreStatus.loading){
      /// Return circular progress widget when calling next page by load more library.
      return Container();
    }else if(status == LoadMoreStatus.idle){

    }
    else if(status == LoadMoreStatus.nomore){
      return Container();
    }else if(status == LoadMoreStatus.fail){

    }
    return Container();
  }

}