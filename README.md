# iTunesMedia
Demo Project for iTunes Media with iOS18 Tab View

iPad|iPhone
--|--
<img src="https://github.com/user-attachments/assets/db42e03c-9886-4efd-ad3c-c56288c35fff" width=700 />|<img src="https://github.com/user-attachments/assets/edb254bd-3065-4e0c-8143-ed66c2c7220d" width=228/>

# Description

iTunesMedia is a demo app which provides functionality for searching and displaying iTunes Media. It uses the open Apple API ‘itunes.apple.com/search', and searches through the categories: 
ebooks, albums, songs, podcasts, tv shows, tv episodes, movies, iPhone apps, iPad apps, and mac apps. Every time a new search term is entered, the app will search all categories for the term and display the results. The results limit is set by the app to retrieve 50 items on each search category, and when in details list mode for a category, more results are automatically fetched when the user scrolls to the bottom of the list using the API paging facility.  When the app is re-started, the last search term queries is used to load the startup content.

This is a universal app, targeting iPhone and iPad and requires iOS 18 in order to use the new Tab View with sidebar mode on iPads. On iPhones the app works in both portrait and landscape modes.

Dark mode and dynamic text are fully supported.  The app is written using SwiftUI. Testings is implemented using the new ‘Swift Testing’ framework introduced with Xcode 16.

# API Documentation

Documentation for the Apple API can be found here:

https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1

The Search API from Apple is currently limited to approximately 20 calls per minute (subject to change) for non-affiliated users.

# Routing

The app integrates my own routing library ‘Routing’ which enables SwiftUI navigation stack routing that can be handled cleanly in view models using the MVVM or MVVM-C patterns, as well as handled directly in views themselves.  This library lets the view models and coordinators control all screen flows, including push navigation, sheet and full screen overlays, and custom popups.  Each overlay will get their own navigation stack so that full navigation flows can be handled within the overlay.  Popups can be presented with or without their own navigation stacks.  The library allows complex navigation flows to be handled cleanly without cluttering the view code and can conform to MVVM-C design patterns.
