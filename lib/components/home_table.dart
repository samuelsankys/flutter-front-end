import 'package:flutter/material.dart';
import 'package:flutter_front_end/constants.dart';
import 'package:flutter_front_end/data/http/http_client.dart';
import 'package:flutter_front_end/data/models/characters_model.dart';
import 'package:flutter_front_end/data/models/characters_response_model.dart';
import 'package:flutter_front_end/data/repositories/character_repository.dart';
import 'package:number_paginator/number_paginator.dart';

class TableWidget extends StatefulWidget {
  final TextEditingController searchController;
  const TableWidget({Key? key, required this.searchController})
      : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final NumberPaginatorController numberPaginatorController =
      NumberPaginatorController();

  final IHttpClient httpClient = HttpClient();
  final ICharacterRepository characterRepository =
      CharacterRepository(client: HttpClient());
  int _totalResults = 0;
  int _totalPages = 1;
  int _resultsPerPage = 4;
  int _currentPage = 0;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() async {
    final searchText = widget.searchController.text.trim();
    if (searchText.length > 2) {
      setState(() {
        _searchQuery = searchText;
      });
    } else {
      setState(() {
        _searchQuery = '';
      });
    }
  }

  void _updatePagination(int totalResults) {
    int totalPages = (totalResults / _resultsPerPage).ceil();
    totalPages = totalPages < 1 ? 1 : totalPages;
    if (_totalResults != totalResults || _totalPages != totalPages) {
      setState(() {
        _totalResults = totalResults;
        _totalPages = totalPages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidthScreen = MediaQuery.of(context).size.width;
    final bool useMobileLayout = sizeWidthScreen < 600;
    final bool useTabletLayout = sizeWidthScreen < 820 && sizeWidthScreen > 600;
    return Column(
      children: [
        headTable(),
        SizedBox(
          height: useMobileLayout ? 376 : 336,
          child: FutureBuilder<CharactersResponse>(
            future: fetchCharacters(
                search: _searchQuery,
                limit: _resultsPerPage,
                offset: _currentPage),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Personagens não encontrado'),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.count,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(snapshot.data!.results[index], index);
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(top: 18, left: 30, right: 30, bottom: 24),
            width: useMobileLayout ? sizeWidthScreen : sizeWidthScreen * .25,
            child: Align(
                alignment: Alignment.topCenter,
                child: NumberPaginator(
                  initialPage: 0,
                  controller: numberPaginatorController,
                  numberPages: _totalPages,
                  onPageChange: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  config: NumberPaginatorUIConfig(
                    mode: ContentDisplayMode.numbers,
                    height: useMobileLayout ? 35 : 32,
                    buttonShape: const CircleBorder(
                      eccentricity: BorderSide.strokeAlignOutside,
                      side: BorderSide(
                        color: kPrimaryColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                    buttonSelectedForegroundColor: Colors.white,
                    buttonUnselectedForegroundColor: kPrimaryColor,
                    buttonUnselectedBackgroundColor: Colors.white,
                    buttonSelectedBackgroundColor: kPrimaryColor,
                    buttonTextStyle: const TextStyle(
                      fontSize: 18,
                      height: 1.1,
                    ),
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 0),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: useMobileLayout ? 40 : 12),
                  ),
                  nextButtonContent: const Icon(Icons.arrow_right_sharp),
                  prevButtonContent: const Icon(Icons.arrow_left_sharp),
                )),
          ),
        )
      ],
    );
  }

  Future<CharactersResponse> fetchCharacters({search, limit, offset}) async {
    String query = '';
    if (search != null && search != '' && search != {}) {
      String encodedSearch = Uri.encodeComponent(search);
      query += '&name=$search';
    }
    if (limit != null) {
      query += '&limit=$limit';
    }
    if (offset != null) {
      query += '&offset=$offset';
    }
    final CharactersResponse response =
        await characterRepository.getCharacters(query);
    _updatePagination(response.total);
    return response;
  }

  Widget _buildRow(Character character, int idx) {
    const _biggerFont = TextStyle(
      fontSize: 21,
      height: 1.1,
    );

    double widthQuery = MediaQuery.of(context).size.width - 84;
    var sizeWidthScreen = MediaQuery.of(context).size.width;
    final bool useMobileLayout = sizeWidthScreen < 600;
    final bool useTabletLayout = sizeWidthScreen < 820 && sizeWidthScreen > 600;

    return useMobileLayout
        ? Container(
            height: useMobileLayout ? 94 : 112,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: kOver,
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: widthQuery,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            character.thumbnail!.path +
                                '.' +
                                character.thumbnail!.extension),
                        radius: 29,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        width: 100,
                        child: Text(
                          character.name,
                          style: _biggerFont,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: 112,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: kOver,
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  width: widthQuery * .25 + 10,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            character.thumbnail!.path +
                                '.' +
                                character.thumbnail!.extension),
                        radius: 29,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        width: 100,
                        child: Text(
                          character.name,
                          style: _biggerFont,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: widthQuery * .25 + 10,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            (character.series?.items?.length ?? 0).clamp(0, 3),
                        itemBuilder: (BuildContext context, int index) {
                          final itemName = character.series?.items?[index].name;
                          return Text(
                            itemName ?? '',
                            style: _biggerFont,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: widthQuery * .5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: (character.events?.items?.length ?? 0)
                              .clamp(0, 4),
                          itemBuilder: (BuildContext context, int index) {
                            final itemName =
                                character.events?.items?[index].name;
                            return Text(
                              itemName ?? '',
                              style: _biggerFont,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Container headTable() {
    double widthQuery = MediaQuery.of(context).size.width - 84;
    var sizeWidthScreen = MediaQuery.of(context).size.width;
    final bool useMobileLayout = sizeWidthScreen < 600;
    final bool useTabletLayout = sizeWidthScreen < 820 && sizeWidthScreen > 600;

    return useMobileLayout
        ? Container(
            margin: EdgeInsets.only(top: useMobileLayout ? 12 : 34),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 37,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 4),
                    width: sizeWidthScreen,
                    color: kPrimaryColor,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Personagem",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 34),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 37,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 4),
                    width: widthQuery * .25,
                    color: kPrimaryColor,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Personagem",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                Container(
                    height: 37,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 4),
                    width: widthQuery * .25,
                    color: kPrimaryColor,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Séries",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )),
                Expanded(
                  child: Container(
                      height: 37,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9.0, vertical: 4),
                      width: widthQuery * .50,
                      color: kPrimaryColor,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Eventos",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          );
  }
}
