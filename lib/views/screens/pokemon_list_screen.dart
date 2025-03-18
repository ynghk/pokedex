import 'package:flutter/material.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/viewmodels/pokemon_list_viewmodel.dart';
import 'package:poke_master/views/screens/bookmark_screen.dart';
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
    create:
    (_) {
      final viewModel = Provider.of<PokemonListViewModel>(
        context,
        listen: false,
      );
      viewModel.initDarkMode(isDarkMode); // 다크 모드만 초기화
      return viewModel;
    };
    final repository = Provider.of<PokemonRepository>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = PokemonListViewModel(repository);
        viewModel
            .loadInitialPokemons(); // 초기 로딩 여기서 시작 (이 안에서 preloadTypeCache 호출됨)
        viewModel.initDarkMode(isDarkMode); // 다크 모드 초기화
        // 타입 캐시 초기화 코드 제거
        return viewModel;
      },
      child: Consumer<PokemonListViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: viewModel.unfocusKeyboard(context),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF702fc8),
                leading: Builder(
                  builder:
                      (context) => IconButton(
                        icon: Icon(Icons.list, size: 40, color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).unfocus(); // 키보드 숨기기
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                ),
                title: Center(
                  child: Image.asset('assets/pokemaster_title.png', width: 220),
                ),
                actions: [
                  Builder(
                    builder:
                        (context) => InkWell(
                          onTap: () {
                            // 키보드 숨기기
                            FocusScope.of(context).unfocus();
                            // 오른쪽 Drawer 열기
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
              drawer: SafeArea(
                child: Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 100,
                        decoration: viewModel.getDrawerHeaderDecoration(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/poke_menu_title.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.pop(context),
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
                            InkWell(
                              onTap: () {
                                // 먼저 Drawer 닫기
                                Navigator.pop(context);
                                // 그 다음 북마크 화면으로 이동
                                _navigateToBookmarks(context, isDarkMode);
                              },
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/bookmark_pokeball.png',
                                  width: 30,
                                ),
                                title: Text(
                                  'My Pokéball',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(Icons.chevron_right_rounded),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey),
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
                            Divider(height: 1, color: Colors.grey),
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
              // 오른쪽 Drawer 구현 (필터 및 정렬)
              endDrawer: SafeArea(
                child: Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drawer 헤더
                      Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF702fc8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  'assets/filter_sort_title.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey),
                      // 필터 섹션
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: [
                            // 타입 필터 섹션
                            Text(
                              'Filter by Type',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),

                            // 선택된 필터 초기화 버튼
                            if (viewModel.selectedTypes.isNotEmpty)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.clear_all,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Clear Filters',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    viewModel.clearTypeFilters();
                                  },
                                ),
                              ),

                            // 타입 필터 칩 그리드
                            Wrap(
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children:
                                  viewModel.availableTypes.map((type) {
                                    final isSelected = viewModel.selectedTypes
                                        .contains(type);
                                    final color = viewModel.getTypeColor(type);
                                    final isDarkMode =
                                        Theme.of(context).brightness ==
                                        Brightness.dark;
                                    return FilterChip(
                                      label: Text(
                                        StringCapitalize(type).capitalize(),
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? (color.computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Colors.white)
                                                  : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: color.withAlpha(70),
                                      selectedColor: color,
                                      selected: isSelected,
                                      checkmarkColor:
                                          isSelected
                                              ? (color.computeLuminance() > 0.5
                                                  ? Colors.black
                                                  : Colors.white)
                                              : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color:
                                              isDarkMode
                                                  ? (isSelected
                                                      ? Colors.white
                                                      : Colors.black)
                                                  : (isSelected
                                                      ? Colors.black
                                                      : Colors.white),
                                          width: 3.0, // 테두리 두께
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ), // 모서리 둥글기
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onSelected: (bool selected) {
                                        viewModel.toggleTypeFilter(type);
                                      },
                                    );
                                  }).toList(),
                            ),

                            SizedBox(height: 10),
                            Divider(height: 1, color: Colors.grey),
                            SizedBox(height: 10),
                            // 정렬 섹션
                            Text(
                              'Sort Options',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10),

                            // 정렬 옵션 리스트
                            _buildSortTile(
                              context,
                              viewModel,
                              'Number (Ascending)',
                              SortOption.numberAscending,
                              Icons.arrow_upward,
                            ),
                            Divider(height: 1, color: Colors.grey),
                            _buildSortTile(
                              context,
                              viewModel,
                              'Number (Descending)',
                              SortOption.numberDescending,
                              Icons.arrow_downward,
                            ),
                            Divider(height: 1, color: Colors.grey),
                            _buildSortTile(
                              context,
                              viewModel,
                              'Name (A to Z)',
                              SortOption.nameAscending,
                              Icons.sort_by_alpha,
                            ),
                            Divider(height: 1, color: Colors.grey),
                            _buildSortTile(
                              context,
                              viewModel,
                              'Name (Z to A)',
                              SortOption.nameDescending,
                              Icons.sort_by_alpha,
                            ),
                          ],
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
                      color: Color(0xFF702fc8),
                      onRefresh: () async {
                        // 새로고침 시 현재 선택된 지역 유지
                        await viewModel.loadPokemons();
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
                              : viewModel.filteredPokemons.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/pikachu_shadow.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'No Pokémon found',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Try a different search term',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : NotificationListener<ScrollNotification>(
                                onNotification: viewModel
                                    .handleScrollNotification(context),
                                child: PokemonList(
                                  viewModel: viewModel,
                                  scrollController: viewModel.scrollController,
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
                splashColor: Colors.deepPurpleAccent.shade200,
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
      onTap: () {
        // 먼저 Drawer 닫기
        Navigator.pop(context);
        // 그 다음 지역 선택 로직 실행
        viewModel.selectRegion(region, viewModel.scrollToTop, context);
      },
    );
  }

  void _navigateToBookmarks(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarkScreen(isDarkMode: isDarkMode),
      ),
    );
  }

  Widget _buildSortTile(
    BuildContext context,
    PokemonListViewModel viewModel,
    String title,
    SortOption option,
    IconData icon,
  ) {
    final isSelected = viewModel.sortOption == option;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Color(0xFF702fc8) : null,
        ),
      ),
      leading: Icon(icon, color: isSelected ? Color(0xFF702fc8) : null),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: Color(0xFF702fc8))
              : null,
      onTap: () {
        viewModel.updateSortOption(option);
        // 정렬 후 Drawer 닫기
        Navigator.pop(context);
      },
    );
  }
}

class PokemonList extends StatelessWidget {
  final PokemonListViewModel viewModel;
  final ScrollController scrollController;

  const PokemonList({
    super.key,
    required this.viewModel,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      cacheExtent: 1000,
      itemCount: viewModel.filteredPokemons.length,
      itemBuilder: (context, index) {
        var pokemon = viewModel.filteredPokemons[index];
        return InkWell(
          splashColor: Colors.transparent,
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
                  '${pokemon.id}. ${StringCapitalize(pokemon.name).capitalize()}',
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

// 첫글자를 대문자로 변환하는 클래스 - extension 충돌 방지용
class StringCapitalize {
  final String text;

  StringCapitalize(this.text);

  String capitalize() {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
