import 'package:flutter/material.dart';
import 'package:pokedex_app/viewmodels/pokemon_list_viewmodel.dart';
import 'package:pokedex_app/views/screens/pokedex_screen.dart';
import 'package:pokedex_app/utils/string_utils.dart';
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
    return ChangeNotifierProvider(
      create: (_) => PokemonListViewModel()..loadPokemons('Kanto'),
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
                    children: [
                      SizedBox(
                        height: 100,
                        child: DrawerHeader(
                          decoration: BoxDecoration(color: Colors.red),
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
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Kanto Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_rounded),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Kanto');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Johto Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Johto');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Hoenn Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Hoenn');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Sinnoh Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Sinnoh');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Unova Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Unova');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Kalos Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Kalos');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Alola Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Alola');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Galar Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Galar');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Paldea Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Paldea');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
                            ),

                            Divider(height: 1, color: Colors.grey),

                            ListTile(
                              leading: Icon(Icons.map_outlined),
                              title: Row(
                                children: [
                                  Text(
                                    'Hisui Region',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Spacer(),
                                  Icon(Icons.chevron_right_outlined),
                                ],
                              ),
                              onTap: () {
                                viewModel.loadPokemons('Hisui');
                                _scrollToTop();
                                Navigator.pop(context);
                              },
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
                        tileColor:
                            Theme.of(
                                      context,
                                    ).colorScheme.surface.computeLuminance() >
                                    0.5
                                ? Colors.black12
                                : Colors.grey.shade800,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  titlePadding: EdgeInsets.all(0),
                                  title: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Settings',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    spacing: 10,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Dark Mode',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Spacer(),
                                          Switch(
                                            value: widget.isDarkMode,
                                            onChanged: widget.onThemeChanged,
                                          ),
                                        ],
                                      ),
                                      Divider(height: 1, color: Colors.grey),
                                      Row(
                                        children: [
                                          Text(
                                            'Language',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Spacer(),
                                          DropdownButton<String>(
                                            value: viewModel.selectedLanguage,
                                            items:
                                                ['English', 'Korean'].map((
                                                  String lang,
                                                ) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: lang,
                                                    child: Text(lang),
                                                  );
                                                }).toList(),
                                            onChanged: (String? newValue) {
                                              viewModel.updateLanguage(
                                                newValue!,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
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
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.surface
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search for Pokemon',
                              hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.surface
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.grey[600]
                                        : Colors.grey[300],
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface
                                                  .computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.surface
                                                  .computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ), // 내부 여백 조정
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _controller.clear();
                                  viewModel.clearSearch();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          if (notification.scrollDelta != null &&
                              notification.scrollDelta! < 0 &&
                              FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus(); // 위로 스크롤 시 키보드 닫기
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
      itemCount: viewModel.filteredPokemons.length,
      itemBuilder: (context, index) {
        var pokemon = viewModel.filteredPokemons[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokedexScreen(pokedex: pokemon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Image.network(
                  //포켓몬 번호를 url에 파싱 해줌으로써 해당 포켓몬의 이미지를 불러옴
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.getPokemonId()}.png',
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

                SizedBox(width: 20),

                //포켓몬 이름 표시해주는 것.
                Text(
                  '${pokemon.id}. ${pokemon.name.capitalize()}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Spacer(),

                Icon(Icons.chevron_right_rounded, size: 25),
              ],
            ),
          ),
        );
      },
      //ListView.separated에 list간의 구분 짓는 부분
      separatorBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(height: 1, color: Colors.grey),
          ),
    );
  }
}
