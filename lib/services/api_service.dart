import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';

class ApiService {
  // 관동기방 포켓몬 불러오기
  Future<List<PokedexEntry>> getKantoPokemonData({int retries = 3}) async {
    late http.Response response; // response를 루프 밖에서 선언
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 151) // 관동만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 성도지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getJohtoPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 251 && e['entry_number'] >= 152) // 성도만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 호연지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getHoennPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 386 && e['entry_number'] >= 252) // 호연만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 신오지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getSinnohPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 493 && e['entry_number'] >= 387) // 신오만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 하나지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getUnovaPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 649 && e['entry_number'] >= 494) // 하나만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 칼로스지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getKalosPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 721 && e['entry_number'] >= 650) // 칼로스만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 알로라지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getAlolaPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 809 && e['entry_number'] >= 722) // 알로라만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 가라르지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getGalarPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 898 && e['entry_number'] >= 810) // 가라르만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 히스이지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getHisuiPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 905 && e['entry_number'] >= 899) // 히스이만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  //팔데아지방 포켓몬 불러오기
  Future<List<PokedexEntry>> getPaldeaPokemonData({int retries = 3}) async {
    late http.Response response;
    for (int i = 0; i < retries; i++) {
      try {
        response = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
        );
        if (response.statusCode == 200) {
          // 성공 시 루프 종료
          break;
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // 마지막 시도에서도 실패하면 에러 던짐
          rethrow;
        }
        await Future.delayed(Duration(seconds: 1)); // 1초 대기 후 재시도
      }
    }
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 1010 && e['entry_number'] >= 906) // 팔데아만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  // 포켓몬의 정보 불러오기
  Future<PokemonDetail> getPokemonDetail(int id) async {
    final speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id'),
    );
    final pokemonResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
    );
    if (speciesResponse.statusCode == 200 &&
        pokemonResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final pokemonData = jsonDecode(pokemonResponse.body);
      final height = pokemonData['height'] as int;
      final weight = pokemonData['weight'] as int;
      final types =
          (pokemonData['types'] as List)
              .map((type) => type['type']['name'] as String)
              .toList();
      final flavorText = (speciesData['flavor_text_entries'] as List)
          .firstWhere(
            (entry) => entry['language']['name'] == 'en',
          )['flavor_text']
          .toString()
          .replaceAll('\n', ' ');

      // 일반 어빌리티와 히든 어빌리티 분리
      final regularAbilities = <String>[];
      final hiddenAbilities = <String>[];

      for (var ability in pokemonData['abilities'] as List) {
        final name = ability['ability']['name'] as String;
        final isHidden = ability['is_hidden'] as bool;

        if (isHidden) {
          hiddenAbilities.add(name.capitalize());
        } else {
          regularAbilities.add(name.capitalize());
        }
      }

      return PokemonDetail(
        height: height,
        weight: weight,
        types: types,
        flavorText: flavorText,
        regularAbilities: regularAbilities,
        hiddenAbilities: hiddenAbilities,
      );
    } else {
      throw Exception('Failed to load Pokémon detail');
    }
  }

  //포켓몬 진화 정보 불러오기
  Future<List<EvolutionStage>> getEvolutionChainForPokemon(int id) async {
    final speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id'),
    );
    if (speciesResponse.statusCode != 200) {
      throw Exception('Failed to load species');
    }

    final speciesData = jsonDecode(speciesResponse.body);
    final chainUrl = speciesData['evolution_chain']['url'];
    final chainResponse = await http.get(Uri.parse(chainUrl));
    if (chainResponse.statusCode != 200) {
      throw Exception('Failed to load evolution chain');
    }

    final chainData = jsonDecode(chainResponse.body)['chain'];
    List<EvolutionStage> stages = [];

    // 재귀적으로 파싱
    void parseChain(Map<String, dynamic> chain) {
      stages.add(EvolutionStage.fromJson(chain));
      final evolvesTo = chain['evolves_to'] as List;
      for (var next in evolvesTo) {
        parseChain(next);
      }
    }

    parseChain(chainData);
    return stages;
  }

  @override
  Future<List<EvolutionStage>> getEvolutionStages(int pokemonId) {
    return getEvolutionChainForPokemon(pokemonId);
  }
}
