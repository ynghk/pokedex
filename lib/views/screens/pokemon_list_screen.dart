import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/viewmodels/pokemon_list_viewmodel.dart';
import 'package:provider/provider.dart';

class PokemonListScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const PokemonListScreen(
    this.isDarkMode, {
    super.key,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PokemonRepository>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PokemonListViewModel(repository);
        viewModel.loadInitialPokemons(); // 초기 로딩 여기서 시작
        viewModel.initDarkMode(isDarkMode); // 다크 모드 초기화
        return viewModel;
      },
      child: Consumer<PokemonListViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: viewModel.unfocusKeyboard(context), // 뷰모델로 이동
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                leading: Builder(
                  builder:
                      (context) => IconButton(
                        icon: Icon(Icons.list, size: 40, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
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
                              onPressed: () => Navigator.pop(context),
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
                            _buildRegionTile(context, viewModel, 'Kanto'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Johto'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Hoenn'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Sinnoh'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Unova'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Kalos'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Alola'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Galar'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Paldea'),
                            Divider(height: 1, color: Colors.grey),
                            _buildRegionTile(context, viewModel, 'Hisui'),
                          ],
                        ),
                      ),
                      ListTile(
                        trailing: Icon(Icons.settings, size: 20),
                        title: Text('Settings'),
                        tileColor: viewModel.getSettingsTileColor(context),
                        onTap:
                            () => viewModel.showSettingsDialog(
                              context,
                              isDarkMode,
                              onThemeChanged,
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
                            controller: viewModel.textController, // 뷰모델에서 제공
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
                          Theme.of(context).scaffoldBackgroundColor,
                      color: Colors.red,
                      onRefresh: () async {
                        await viewModel.loadInitialPokemons();
                        viewModel.scrollToTop(); // 새로고침 후 맨 위로
                      },
                      child:
                          viewModel.isLoading
                              ? Center(
                                child: Image.asset(
                                  'assets/pokeball_spin.gif',
                                  width: 150,
                                  height: 150,
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
                                onNotification: viewModel
                                    .handleScrollNotification(context),
                                child: PokemonList(
                                  viewModel: viewModel,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: viewModel.scrollToTop,
                backgroundColor: Colors.grey.shade600,
                elevation: 8.0,
                shape: CircleBorder(),
                splashColor: Colors.red.shade300,
                hoverElevation: 10,
                child: Icon(
                  Icons.keyboard_double_arrow_up_rounded,
                  color: Colors.white,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegionTile(
    BuildContext context,
    PokemonListViewModel viewModel,
    String region,
  ) {
    return ListTile(
      leading: Icon(Icons.map_outlined),
      title: Row(
        children: [
          Text('$region Region', style: viewModel.getRegionTextColor(region)),
          Spacer(),
          Icon(
            Icons.chevron_right_rounded,
            color: viewModel.getRegionTextColor(region)?.color,
          ),
        ],
      ),
      onTap:
          () => viewModel.selectRegion(region, viewModel.scrollToTop, context),
    );
  }
}

class PokemonList extends StatelessWidget {
  final PokemonListViewModel viewModel;

  const PokemonList({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: viewModel.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      cacheExtent: 1000,
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
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        'assets/pokeball_error.png',
                        width: 80,
                        height: 80,
                      ),
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
