import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';

class DropDown extends StatefulWidget {
  late final String labelText;
  late final String placeHolderText;
  TextEditingController? controller;
  late final List<String> currentList;
  Function(String) onChange;
  late bool showError;

  late String? preSelected;

  final bool removeText;

  final bool enabled;

  final bool padding;

  DropDown(
      {required this.labelText,
      required this.placeHolderText,
      this.controller,
      required this.currentList,
      required this.onChange,
      required this.showError,
      this.preSelected = '',
      this.padding = true,
      this.enabled = true,
      this.removeText = false});

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String searchField = "";

  late String selectedString = "";

  @override
  void initState() {
    super.initState();
    if (this.widget.preSelected != null) {
      selectedString = widget.preSelected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preSelected == 'resetme') {
      selectedString = '';
      widget.preSelected = '';
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: widget.padding
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            : EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (!widget.enabled) {
              return;
            }
            showDialog(
              context: context,
              builder: (context) {
                List<String> listToShow;
                if (searchField.isNotEmpty) {
                  listToShow = widget.currentList
                      .where(
                        (e) => e.toLowerCase().contains(
                              searchField.toLowerCase(),
                            ),
                      )
                      .toList();
                } else {
                  listToShow = widget.currentList;
                }
                searchField = "";

                return StatefulBuilder(
                  builder: (context, setState) {
                    return SimpleDialog(
                      insetPadding: const EdgeInsets.symmetric(vertical: 80.0),
                      contentPadding:
                          const EdgeInsets.fromLTRB(24.0, 12.0, 5.0, 12.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.placeHolderText,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: widget.controller,
                            maxLines: 1,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (v) {
                              setState(
                                () {
                                  searchField = v;
                                  if (searchField.isNotEmpty) {
                                    listToShow = widget.currentList
                                        .where(
                                          (e) => e.toLowerCase().contains(
                                                searchField.toLowerCase(),
                                              ),
                                        )
                                        .toList();
                                  } else {
                                    listToShow = widget.currentList;
                                  }
                                },
                              );
                            },
                          ),
                          const Divider(
                            height: 4,
                            thickness: 1,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                      children: [
                        listToShow.isEmpty
                            ? const Center(
                                child: Text('No record found'),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width - 128,
                                height:
                                    MediaQuery.of(context).size.height / 4.5,
                                child: CupertinoScrollbar(
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return
                                          // for (int index = 0;
                                          // index < listToShow.length;
                                          // index++)
                                          listToShow[index] != ""
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);

                                                        selectedString =
                                                            listToShow[index];

                                                        widget.onChange(
                                                            selectedString);
                                                      },
                                                      child: Text(
                                                        listToShow[index],
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 12,
                                                      thickness: 1,
                                                      color: Colors.grey[50],
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                    },
                                    itemCount: listToShow.length,
                                  ),
                                )
                                // Scrollbar(
                                //   thumbVisibility: true,
                                //   trackVisibility: true,
                                //   controller: ScrollController(
                                //       initialScrollOffset: 0.0),
                                //   child: ListView(
                                //       primary:false,
                                //       children: [
                                //     for (int index = 0;
                                //         index < listToShow.length;
                                //         index++)
                                //       listToShow[index] != ""
                                //           ? Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.stretch,
                                //               children: [
                                //                 GestureDetector(
                                //                   onTap: () {
                                //                     Navigator.pop(context);
                                //
                                //                     selectedString =
                                //                         listToShow[index];
                                //
                                //                     widget.onChange(
                                //                         selectedString);
                                //                   },
                                //                   child: Text(
                                //                     listToShow[index],
                                //                     style: const TextStyle(
                                //                         fontSize: 16),
                                //                   ),
                                //                 ),
                                //                 Divider(
                                //                   height: 12,
                                //                   thickness: 1,
                                //                   color: Colors.grey[50],
                                //                 ),
                                //               ],
                                //             )
                                //           : Container()
                                //   ]),
                                // ),
                                ),
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: (selectedString.isEmpty && widget.preSelected!.isEmpty)
                    ? Text(
                        widget.placeHolderText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      )
                    : Text(
                        selectedString.isEmpty
                            ? widget.preSelected!
                            : selectedString,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
