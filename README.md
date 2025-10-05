# Chargerrr - EV Charging Station Finder

A Flutter mobile app to help electric vehicle owners find nearby charging stations. This project was built as part of a Flutter development assessment.

## What We Built

This is a complete EV charging station finder app with the following features:

- **User Authentication** – Sign up and login system using Supabase
- **Interactive Map** – Find charging stations on a map with your current location
- **Station Details** – View charging station information like availability, pricing, and amenities
- **Real-time Data** – Station data is stored and retrieved from Supabase database
- **Location Services** – Get your current location and calculate distances to stations
- **Search and Favorites** – Search for stations and save your favorites
- **Clean UI** – Modern, user-friendly interface

## Tech Stack

- **Flutter** – Cross-platform mobile development
- **GetX** – State management and navigation
- **Supabase** – Backend database and authentication
- **Flutter Map** – Interactive maps
- **Geolocator** – Location services

## How to Download and Use

### Option 1: Download APK

- Go to the Releases page
- Download the latest `app-release.apk` file
- On your Android phone, enable "Install from Unknown Sources" in Settings
- Install the APK and open the app

### Option 2: Build from Source

- Install Flutter by following the official installation guide
- Clone this repository
- Run `flutter pub get`
- Run `flutter run` to launch the app

## Using the App

- Sign up and create an account
- Allow location access to find nearby stations
- Explore the map to browse charging stations
- Tap on stations to view details
- Use the navigation option to get directions
- Save your favorite stations for quick access

## Project Structure
lib/
├── core/           # App constants and utilities
├── domain/         # Business models and entities
├── services/       # Data services (Supabase, Location)
├── presentation/   # UI screens and widgets
└── routes/         # App navigation

## Database Setup

The app uses Supabase for backend services.

Tables include:
- User profiles and authentication
- Charging station data
- User favorites and preferences

## Future Improvements

- Real-time station availability updates
- Booking and payment integration
- User reviews and ratings
- Route planning with multiple stops

---

Built with Flutter for the EV charging community in India.