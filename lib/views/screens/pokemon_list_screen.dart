import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/viewmodels/pokemon_list_viewmodel.dart';
import 'package:provider/provider.dart';

class PokemonListScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const PokemonListScreen(
    this.isDarkMode, {
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      print('ScrollController is not attached to any scroll views.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PokemonRepository>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => PokemonListViewModel(repository)..loadPokemons('Kanto'),
      child: Consumer<PokemonListViewModel>(
        builder: (context, viewModel, child) {
          if (_controller.text != viewModel.searchQuery) {
            _controller.text = viewModel.searchQuery;
          }
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!FocusScope.of(context).hasFocus) return;
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                leading: Builder(
                  builder:
                      (context) => IconButton(
                        icon: Icon(Icons.list, size: 40, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                ),
                title: Center(
                  child: Image.asset('assets/pokedex_title.png', width: 140),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset('assets/pokeball_icon.png', width: 40),
                  ),
                ],
              ),
              drawer: SafeArea(
                child: Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 120,
                        decoration: viewModel.getDrawerHeaderDecoration(),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),

                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/poke_menu_title.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: Colors.grey),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Kanto Region',
                                    style: viewModel.getRegionTextColor(
                                      'Kanto',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Kanto')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Kanto',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Johto Region',
                                    style: viewModel.getRegionTextColor(
                                      'Johto',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Johto')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Johto',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Hoenn Region',
                                    style: viewModel.getRegionTextColor(
                                      'Hoenn',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Hoenn')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Hoenn',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Sinnoh Region',
                                    style: viewModel.getRegionTextColor(
                                      'Sinnoh',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Sinnoh')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Sinnoh',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Unova Region',
                                    style: viewModel.getRegionTextColor(
                                      'Unova',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Unova')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Unova',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Kalos Region',
                                    style: viewModel.getRegionTextColor(
                                      'Kalos',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Kalos')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Kalos',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Alola Region',
                                    style: viewModel.getRegionTextColor(
                                      'Alola',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Alola')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Alola',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Galar Region',
                                    style: viewModel.getRegionTextColor(
                                      'Galar',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Galar')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Galar',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Paldea Region',
                                    style: viewModel.getRegionTextColor(
                                      'Paldea',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Paldea')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Paldea',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Hisui Region',
                                    style: viewModel.getRegionTextColor(
                                      'Hisui',
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color:
                                        viewModel
                                            .getRegionTextColor('Hisui')
                                            ?.color,
                                  ),
                                ],
                              ),
                              onTap:
                                  () => viewModel.selectRegion(
                                    'Hisui',
                                    _scrollToTop,
                                    context,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.settings,
                          size: 20,
                        ), // 톱니바퀴 아이콘, 작게 설정
                        title: Text('Settings'),
                        tileColor: viewModel.getSettingsTileColor(context),
                        onTap:
                            () => viewModel.showSettingsDialog(
                              context,
                              widget.isDarkMode,
                              widget.onThemeChanged,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: viewModel.updateSearchQuery,
                            style: viewModel.getSearchTextStyle(context),
                            decoration: viewModel.getSearchDecoration(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor:
                          widget.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.white,
                      color: Colors.red,
                      onRefresh: () async {
                        // 새로고침 시 현재 지역 데이터 다시 로드
                        await viewModel.loadPokemons(viewModel.selectedRegion);
                      },
                      child:
                          viewModel.isLoading
                              ? Center(
                                child: Image.asset(
                                  'assets/pokeball_spin.gif',
                                  width: 300,
                                  height: 300,
                                ),
                              )
                              : viewModel.error != null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Error: ${viewModel.error}'),
                                    SizedBox(height: 10),
                                    Text('위로 당겨서 새로고침 해주세요'),
                                  ],
                                ),
                              )
                              : NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification
                                      is ScrollUpdateNotification) {
                                    if (notification.scrollDelta != null &&
                                        notification.scrollDelta! < 0 &&
                                        FocusScope.of(context).hasFocus) {
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // 위로 스크롤 시 키보드 닫기
                                    }
                                  }
                                  return false; // 이벤트 전파 유지
                                },
                                child: KantoPokemonList(
                                  viewModel: viewModel,
                                  scrollController: _scrollController,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: Colors.grey.shade600, // 투명한 야간 느낌
                elevation: 8.0, // Z-stack 효과 (떠 있는 느낌)
                shape: CircleBorder(),
                splashColor: Colors.red.shade300,
                hoverElevation: 10,
                child: Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: Colors.white,
                ), // 원형 버튼
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          );
        },
      ),
    );
  }
}

class KantoPokemonList extends StatelessWidget {
  final PokemonListViewModel viewModel;
  final ScrollController scrollController;

  const KantoPokemonList({
    super.key,
    required this.viewModel,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: viewModel.filteredPokemons.length,
      itemBuilder: (context, index) {
        var pokemon = viewModel.filteredPokemons[index];
        return InkWell(
          onTap: () => viewModel.navigateToDetail(context, pokemon),
          child: Padding(
            padding: viewModel.getListItemPadding(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  viewModel.getPokemonImageUrl(pokemon.getPokemonId()),
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        'assets/pokeball_error.png',
                        width: 80,
                        height: 80,
                      ),
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),

                //포켓몬 이름 표시해주는 것.
                Text(
                  '${pokemon.id}. ${pokemon.name.capitalize()}',
                  style: viewModel.getListItemStyle(),
                ),

                Spacer(),

                viewModel.buildTypeChips(pokemon.getPokemonId(), context),

                Icon(Icons.chevron_right_rounded, size: 20),
              ],
            ),
          ),
        );
      },
      //ListView.separated에 list간의 구분 짓는 부분
      separatorBuilder:
          (context, index) => Divider(height: 1, color: Colors.grey),
    );
  }
}
