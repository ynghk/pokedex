# Pokémon Pokédex

A Flutter-based Pokémon Pokédex application that provides comprehensive information about Pokémon from the Kanto region to the Hisui region. Built using the [PokéAPI](https://pokeapi.co/), this app offers a rich set of features including Pokémon details, bookmarking, filtering, sorting, and Firebase authentication for personalized functionality.

## Features

- **Comprehensive Pokémon Data**: Includes all Pokémon from Kanto to Hisui regions.
- **Detailed Pokémon Pages**:
  - Official Pokémon images (including Shiny variants).
  - Type, height, weight, abilities, hidden abilities, description, and evolution chain.
- **Bookmark Functionality**:
  - Save favorite or frequently viewed Pokémon for quick access.
  - Requires email-based Firebase authentication to use.
- **Search Across Regions**:
  - Search for any Pokémon across all regions without switching region tabs.
- **Filtering and Sorting**:
  - Filter Pokémon by type to view only those of interest.
  - Sort Pokémon by:
    - Pokédex number (ascending/descending).
    - Alphabetical order (ascending/descending).
- **Dark Mode Support**:
  - Toggle between light and dark themes in the settings.
- **Firebase Authentication**:
  - Email login required only for bookmarking; browsing the Pokédex is open to all users.
- **Responsive Design**:
  - Optimized for both iOS and Android platforms.

## Screenshots
<img width="200" alt="Group 1136" src="https://github.com/user-attachments/assets/bb66547e-261e-475f-bed9-55901776344f" />
<img width="200" alt="Group 1137" src="https://github.com/user-attachments/assets/6c821d08-b304-46f0-8617-93e3d4b21b83" />
<img width="200" alt="Group 1145" src="https://github.com/user-attachments/assets/66ffddb0-2a0b-4e46-9217-b77911b65b58" />
<img width="200" alt="Group 1141" src="https://github.com/user-attachments/assets/8cbc4bf7-7a68-4357-b303-1d9a69cd076a" />
<img width="200" alt="Group 1138" src="https://github.com/user-attachments/assets/3482f9d9-d9b7-4fce-882e-2704c27656be" />
<img width="200" alt="Group 1140" src="https://github.com/user-attachments/assets/ce73fcdc-cc23-4937-a309-1634385b8d61" />
<img width="200" alt="Group 1143" src="https://github.com/user-attachments/assets/82137e81-8fa1-409c-bae5-192dc0f3f80a" />
<img width="200" alt="Group 1147" src="https://github.com/user-attachments/assets/c7367d6c-88cd-493c-a2ba-a3265dc5e4ce" />
<img width="200" alt="Group 1152" src="https://github.com/user-attachments/assets/15b0558e-bb7d-487c-8374-671b54474c47" />
<img width="200" alt="Group 1150" src="https://github.com/user-attachments/assets/040f2803-5f1d-4bce-94ae-953ba11254d7" />

![Intro](https://github.com/user-attachments/assets/d583feab-194f-4a7f-a43e-940d68ea55ee)
![pokemonDetail](https://github.com/user-attachments/assets/fccf012f-2fea-42c1-9522-70a2e8de595a)
![bookmark](https://github.com/user-attachments/assets/008db8a2-8ae9-43e5-8d6f-5ce0b462e784)
![tyoe](https://github.com/user-attachments/assets/ee94fdaa-2373-4f92-b93d-38fe27ab8b89)
![bookmarksort](https://github.com/user-attachments/assets/549c4e9e-b326-431f-a2c0-b43e9917d60e)
![darkmode](https://github.com/user-attachments/assets/8a5a0a3e-c30e-40a0-a6d5-3f4f306220d3)

## Technologies Used

- **Flutter**: Cross-platform mobile app framework.
- **Dart**: Programming language for Flutter.
- **Architectural pattern**: MVVM
- **PokéAPI**: Provides Pokémon data ([https://pokeapi.co/](https://pokeapi.co/)).
- **Firebase**:
  - Authentication: Email-based login.
  - Firestore: Bookmark feature.
- **CocoaPods**: Dependency management for iOS.
- **Other Packages**:
  - provider
