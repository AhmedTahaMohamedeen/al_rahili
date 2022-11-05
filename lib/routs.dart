import 'package:bota/screens/more/monthly/monthly_screen.dart';
import 'package:bota/test_screen.dart';
import 'package:flutter/material.dart';

import 'models/album_model.dart';
import 'screens/books/all_books.dart';
import 'screens/books/books_screen.dart';
import 'screens/home.dart';
import 'screens/more/ads/ads_screen.dart';
import 'screens/more/favourites/albums_screen.dart';
import 'screens/more/favourites/favourite_screen.dart';
import 'screens/more/info/info_screen.dart';
import 'screens/more/live_stream/live_screen.dart';
import 'screens/more/mores_screen.dart';
import 'screens/more/rate/rate_screen.dart';
import 'screens/more/share/share_screen.dart';
import 'screens/more/social_media/social_screen.dart';
import 'screens/sounds/3qdia1.dart';
import 'screens/sounds/3qdia2.dart';
import 'screens/sounds/all_sounds.dart';
import 'screens/sounds/courses1.dart';
import 'screens/sounds/courses2.dart';

import 'screens/sounds/player_screen.dart';
import 'screens/sounds/sounds_screen.dart';
import 'screens/videos/all_videos_screen.dart';
import 'screens/videos/courses_screen.dart';
import 'screens/videos/droos_screen.dart';
import 'screens/videos/videos_screen0.dart';

Map<String,WidgetBuilder>routes={

  Home.route:(context)=>const Home(),
  SoundsScreen.route:(context)=>const SoundsScreen(),
  DroosVideosScreen.route:(context)=>const DroosVideosScreen(),
  VideosScreen0.route:(context)=>const VideosScreen0(),
  MoreScreen.route:(context)=>const MoreScreen(),
  BooksScreen.route:(context)=>const BooksScreen(),
  AllBookScreen.route:(context)=>const AllBookScreen(),
  AllSoundsScreen.route:(context)=>const AllSoundsScreen(title: '',catId: '',catName: ''),
  AllVideosScreen.route:(context)=>const AllVideosScreen(title: '',catId: ''),


  AdsScreen.route:(context)=>const AdsScreen(),
  FavouriteScreen.route:(context)=> FavouriteScreen(album: Album()),
  InfoScreen.route:(context)=>const InfoScreen(),
  MonthlyScreen.route:(context)=>const MonthlyScreen(),
  RateScreen.route:(context)=>const RateScreen(),
  ShareScreen.route:(context)=>const ShareScreen(),
  SocialScreen.route:(context)=>const SocialScreen(),
  CoursesScreen.route:(context)=>const CoursesScreen(),
  Courses1.route:(context)=>const Courses1(),
  Courses2.route:(context)=>const Courses2(title: '',catId: ''),
  Eqdia1.route:(context)=>const Eqdia1(),
  Eqdia2.route:(context)=>const Eqdia2(title: '',catId: ''),
  LiveScreen.route:(context)=>const LiveScreen(),
  Testo.route:(context)=>const Testo(),
  AlbumsScreen.route:(context)=>const AlbumsScreen(),
  PlayerScreen.route:(context)=> const PlayerScreen(index: 0,sounds: []),



};