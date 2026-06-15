# Travel Journal

Aplikacja mobilna tworzona we Flutterze do prowadzenia dziennika podróży.

## Cel projektu

Travel Journal umożliwia:

- przeglądanie krajów świata pobieranych z REST Countries API,
- oznaczanie odwiedzonych krajów,
- prowadzenie dziennika podróży,
- dodawanie zdjęć z podróży,
- przeglądanie odwiedzonych miejsc na mapie,
- synchronizację danych między urządzeniami.

## Technologie

### Główne

- Flutter
- flutter_bloc
- get_it
- dio
- firebase_auth
- cloud_firestore
- Hive
- flutter_map
- image_picker

### Dodatkowe

- freezed
- json_serializable
- fl_chart

## Źródło danych

Dane o krajach pobierane są z REST Countries API.

Przykładowe dane:

- nazwa kraju,
- stolica,
- flaga,
- populacja,
- region,
- współrzędne geograficzne.

## Aktualny zakres

Na obecnym etapie projekt zawiera:

- początkowy szkielet aplikacji,
- podstawowy motyw light/dark,
- konfigurację dependency injection przez `get_it`,
- klienta HTTP przez `dio`,
- ekrany logowania i rejestracji przez Firebase Auth,
- ekran główny z dolną nawigacją,
- ekran krajów,
- pobieranie krajów z API,
- wyszukiwanie krajów,
- lokalną paginację listy,
- bottom sheet ze szczegółami kraju,
- testowy przycisk oznaczenia kraju jako odwiedzonego.

## Struktura projektu

```txt
lib/
  core/
    di/
    network/
    theme/

  features/
    auth/
      data/
      presentation/

    home/
      presentation/

    countries/
      data/
      logic/
      presentation/

    map/
      presentation/

    account/
      presentation/