import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CustomTextFieldTags<T> extends StatefulWidget {
  ///[tagsStyler] must not be [null]
  final TagsStyler tagsStyler;

  ///[textFieldStyler] must not be [null]
  final TextFieldStyler textFieldStyler;

  ///[suggestionList] must not be [null]
  final List<T> suggestionList;

  final Function(List<T> tagList) tagList;

  ///[onTag] must not be [null] and should be implemented
  final void Function(String tag) onTag;

  ///[onDelete] must not be [null]
  final void Function(String tag) onDelete;

  ///[initialTags] are optional initial tags you can enter
  final List<String> initialTags;

  const CustomTextFieldTags({
    Key key,
    @required this.tagsStyler,
    @required this.textFieldStyler,
    @required this.onTag,
    @required this.onDelete,
    @required this.suggestionList,
    this.tagList,
    this.initialTags,
  })  : assert(tagsStyler != null && textFieldStyler != null,
            'tagsStyler and textFieldStyler should not be null'),
        assert(onDelete != null && onTag != null,
            'onDelete and onTag should not be null'),
        super(key: key);

  @override
  TextFieldTagsState createState() => TextFieldTagsState();
}

class TextFieldTagsState extends State<CustomTextFieldTags> {
  List<String> tagsStringContent = [];
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool showPrefixIcon = false;
  double _deviceWidth;

  @override
  void initState() {
    super.initState();
    if (widget.initialTags != null && widget.initialTags.isNotEmpty) {
      showPrefixIcon = true;
      tagsStringContent = widget.initialTags;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceWidth = MediaQuery.of(context).size.width;
  }

  // @override
  // void didUpdateWidget(covariant CustomTextFieldTags oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (!listEquals(widget.suggestionList, oldWidget.suggestionList)) {
  //     if (widget.initialTags != null && widget.initialTags.isNotEmpty) {
  //       _showPrefixIcon = true;
  //       _tagsStringContent = widget.initialTags;
  //     } else {
  //       _tagsStringContent = [];
  //       _showPrefixIcon = false;
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
  }

  List<Widget> get _getTags {
    List<Widget> _tags = [];
    for (var i = 0; i < tagsStringContent.length; i++) {
      String tagText = widget.tagsStyler.showHashtag
          ? "#${tagsStringContent[i]}"
          : tagsStringContent[i];
      var tag = Container(
        padding: widget.tagsStyler.tagPadding,
        decoration: widget.tagsStyler.tagDecoration,
        margin: widget.tagsStyler.tagMargin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: widget.tagsStyler.tagTextPadding,
              child: Text(
                tagText,
                style: widget.tagsStyler.tagTextStyle,
              ),
            ),
            Padding(
              padding: widget.tagsStyler.tagCancelIconPadding,
              child: GestureDetector(
                onTap: () {
                  if (widget.onDelete != null)
                    widget.onDelete(tagsStringContent[i]);

                  if (tagsStringContent.length == 1 && showPrefixIcon) {
                    setState(() {
                      tagsStringContent.remove(tagsStringContent[i]);
                      showPrefixIcon = false;
                    });
                  } else {
                    setState(() {
                      tagsStringContent.remove(tagsStringContent[i]);
                    });
                  }
                },
                child: widget.tagsStyler.tagCancelIcon,
              ),
            ),
          ],
        ),
      );
      _tags.add(tag);
    }
    return _tags;
  }

  void _animateTransition() {
    var _pw = _deviceWidth;
    if (tagsStringContent.isNotEmpty)
      _scrollController.animateTo(
        _pw + _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 3),
        curve: Curves.easeOut,
      );
  }

  String validator(String value) {
    if (tagsStringContent.isEmpty) return 'Please provide a value';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Autocomplete(optionsBuilder: (textEditingValue) {
        return widget.suggestionList.map((e) => e.toString()).where((element) =>
            element
                .toString()
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()) &&
            !tagsStringContent
                .map((x) => x.toLowerCase())
                .contains(element.toLowerCase()));
      }, displayStringForOption: (option) {
        return option;
      }, onSelected: (option) {
        formKey.currentState.reset();
        setState(() {
          showPrefixIcon = true;
          _animateTransition();
        });
        if (!tagsStringContent.contains(option)) {
          tagsStringContent.add(option);
          widget.tagList(tagsStringContent);
          widget.onTag(option.toString());
        }
      },

          // optionsViewBuilder: (context, onSelected, options) {
          //   return Container(
          //     height: 100,
          //     child: Card(
          //       child: Container(
          //         height: 100,
          //         child: SingleChildScrollView(
          //           child: Column(
          //             children: options
          //                 .map((e) => ListTile(
          //                       title: Text(e),
          //                     ))
          //                 .toList(),
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
        // textEditingController.clear();
        return Form(
          key: formKey,
          child: TextFormField(
            // onTap: () {
            //   FocusScope.of(context).unfocus();
            //    TextEditingController().clear();
            // },
            controller: textEditingController,
            focusNode: focusNode,
            autocorrect: false,
            cursorColor: widget.textFieldStyler.cursorColor,
            style: widget.textFieldStyler.textStyle,
            decoration: InputDecoration(
              contentPadding: widget.textFieldStyler.contentPadding,
              isDense: widget.textFieldStyler.isDense,
              helperText: widget.textFieldStyler.helperText,
              helperStyle: widget.textFieldStyler.helperStyle,
              hintText:
                  !showPrefixIcon ? widget.textFieldStyler.hintText : null,
              hintStyle:
                  !showPrefixIcon ? widget.textFieldStyler.hintStyle : null,
              filled: widget.textFieldStyler.textFieldFilled,
              fillColor: widget.textFieldStyler.textFieldFilledColor,
              enabled: widget.textFieldStyler.textFieldEnabled,
              border: widget.textFieldStyler.textFieldBorder,
              focusedBorder: widget.textFieldStyler.textFieldFocusedBorder,
              disabledBorder: widget.textFieldStyler.textFieldDisabledBorder,
              enabledBorder: widget.textFieldStyler.textFieldEnabledBorder,
              prefixIcon: showPrefixIcon
                  ? ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: _deviceWidth * 0.725),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getTags,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            onFieldSubmitted: (value) {
              log(value);
              var val = value.trim().toLowerCase();
              if (value.length > 0) {
                if (!tagsStringContent.contains(val)) {
                  widget.onTag(val);
                  if (!showPrefixIcon) {
                    setState(() {
                      tagsStringContent.add(val);
                      showPrefixIcon = true;
                    });
                  } else {
                    setState(() {
                      tagsStringContent.add(val);
                    });
                  }
                  this._animateTransition();
                }
              }
            },
            onChanged: (value) {
              if (tagsStringContent.contains(value)) {
                textEditingController.clear();
              }
            },
          ),
        );
      }),
    );
  }
}
