import 'package:timeago/timeago.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/utils.dart';
import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/module/stories/item/item_presenter.dart';

class ItemTile extends StatefulWidget {
  final int itemId;

  ItemTile(this.itemId);

  @override
  ItemTileState createState() => new ItemTileState();
}

class ItemTileState extends State<ItemTile> implements ItemViewContract {
  HnItem _item;

  ItemPresenter _presenter;

  ItemTileState() {
    _presenter = new ItemPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    _presenter.loadItem(widget.itemId);
  }

  @override
  void onLoadItemComplete(HnItem item) {
    if (mounted) {
      setState(() {
        _item = item;
      });
    }
  }

  @override
  void onLoadItemError() {
    // TODO: implement onLoadItemError
  }

  void _onTapItem(HnItem item) {
    /*
    final MaterialPageRoute<Null> page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${item.title}'),
      builder: (_) => new ItemPage(item),
    );
    Navigator.of(context).push(page);
    */
  }

  Widget _buildBadge(int count, Color backgroundColor, TextTheme textTheme) {
    final TextStyle textStyle =
        textTheme.caption.copyWith(color: Colors.white, fontSize: 10.0);
    return new Container(
        margin: const EdgeInsets.only(bottom: 2.0),
        width: 25.0,
        height: 25.0,
        decoration: new BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: new Container(
            padding: new EdgeInsets.all(2.0),
            child: new Center(
                child: new Text(count.toString(), style: textStyle))));
  }

  Widget _buildText(String text, TextTheme textTheme) {
    return new Container(
        padding: new EdgeInsets.only(bottom: 5.0),
        child: new Text(
          text.length > 0 ? text : "",
          style: textTheme.caption,
        ));
  }

  Widget _buildTop(TextTheme textTheme) {
    final List<TextSpan> children = <TextSpan>[];

    if (_item.url.isNotEmpty) {
      children.add(new TextSpan(
        text: '(${parseDomain(_item.url)})',
        style: textTheme.caption,
      ));
    }

    return new RichText(
      text: new TextSpan(
        text: _item.title.length > 0 ? '${_item.title} ' : "Loading...",
        style: textTheme.body2,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextTheme textTheme = theme.textTheme;

    final TimeAgo fuzzyTime = new TimeAgo();
    final String timeAgo = fuzzyTime.format(new DateTime.fromMillisecondsSinceEpoch(_item.time * 1000));

    final List<Widget> badgeChildren = <Widget>[
      _buildBadge(_item.score, Colors.orange, textTheme),
      _buildBadge(_item.commentsCount, theme.disabledColor, textTheme),
    ];

    final Widget itemColumn = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTop(textTheme),
          _item.user.length > 0
              ? _buildText('by ${_item.user} | $timeAgo', textTheme)
              : _buildText('id ' + widget.itemId.toString(), textTheme),
        ]);

    return new InkWell(
        onTap: () => _onTapItem(_item),
        child: new Container(
          padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: new Row(children: <Widget>[
            new Expanded(
                child: new Container(
              padding: new EdgeInsets.only(right: 10.0),
              child: new Column(children: badgeChildren),
            )),
            new Expanded(
              flex: 6,
              child: itemColumn,
            ),
          ]),
        ));
  }
}
