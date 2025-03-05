import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/screens/pokedex_screen.dart';
import 'package:pokedex_app/services/api_service.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<PokedexEntry>> pokemons;
  late TextEditingController _controller;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    pokemons = ApiService().getKantoPokemonData();
    _controller = TextEditingController();
  }

  void onSearchChanged(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DrawerHeader(
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
                        child: Image.asset('assets/poke_menu_title.png'),
                      ),
                    ),
                  ],
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
                        setState(() {
                          pokemons = ApiService().getKantoPokemonData();
                        });
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
                        setState(() {
                          pokemons = ApiService().getJohtoPokemonData();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                trailing: Icon(Icons.settings, size: 20), // 톱니바퀴 아이콘, 작게 설정
                title: Text('Settings'),
                tileColor: Colors.black12, // 밝은 회색 배경
                onTap: () {
                  Navigator.pop(context);
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
                    decoration: InputDecoration(
                      hintText: 'Search for Pokemon',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ), // 내부 여백 조정
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            searchQuery = '';
                          });
                        },
                      ),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          //ListView의 크기를 따로 지정해주지 않으면 에러가 나기 때문에 expanded로 지정해줌
          Expanded(
            child: KantoPokemonList(
              pokemons: pokemons,
              searchQuery: searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}

class KantoPokemonList extends StatelessWidget {
  const KantoPokemonList({
    super.key,
    required this.pokemons,
    required this.searchQuery,
  });

  final Future<List<PokedexEntry>> pokemons;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokemons,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //snapshot에 데이터가 존재하지 않으면 로딩 창이 뜨도록 함
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          //에러가 났을 경우 에러 발생 문구 표시
          return Text('Error occured while fetching data');
        }
        //검색 필터링
        final filteredPokemons =
            snapshot.data!.where((p) {
              return p.name.toLowerCase().contains(
                searchQuery,
              ); //대소문자 구분 없이 검색 한 포켓몬의 필터링이 가능하게 함
            }).toList();
        return SafeArea(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: filteredPokemons.length,
            itemBuilder: (context, index) {
              var pokemon = filteredPokemons[index];
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
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
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
                        '${pokemon.id}. ${pokemon.name}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
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
          ),
        );
      },
    );
  }
}
