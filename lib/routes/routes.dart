import 'package:flutter/material.dart';
import 'package:masterreads/models/book.dart';
import 'package:masterreads/views/home/welcomePage.dart';
import 'package:masterreads/views/login/login_screen.dart';
import 'package:masterreads/views/signUp/register_screen.dart';
import 'package:masterreads/views/forgotPassword/forgot_password.dart';
import 'package:masterreads/views/books/add_book_screen/add_book_screen.dart';
import 'package:masterreads/views/books/bookDetail.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/screens/all_book_screen/all_book_screen.dart';
import 'package:masterreads/screens/book_details_screen/book_details_screen.dart';
import 'package:masterreads/views/books/home_screen/home_screen.dart';
import 'package:masterreads/screens/pdf_screen.dart';
import '../views/user/profilePage.dart';

class AppRoutes {
  static const String routeInitial = routeWelcome;

  static const String routeLogin = "/login";
  static const String routeSignUp = "/signup";
  static const String routeForgotPassword = "/forgotPassword";
  static const String routeWelcome = "/welcomePage";
  static const String routeProfilePage = "/profilePage";
  static const String routeBookDetail = "/bookDetail";
  static const String routeBookList = "/bookList";
  static const String routeAdminHomeScreen = "/home";
  static const String routeAddBook = "/add-book";
  static const String routeAllBook = "/all-book";
  static const String routeBookInfo = "/book-details";
  static const String routePdfFile = "/pdf";

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const LoginPage(title: 'Login UI'));
        break;
      case routeSignUp:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const RegisterPage(title: 'Register UI'));
        break;
      case routeAdminHomeScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => HomeScreen());
        break;
      case routeAddBook:
        return MaterialPageRoute(
            settings: settings, builder: (_) => AddBookScreen());
        break;
      case routeAllBook:
        return MaterialPageRoute(
            settings: settings, builder: (_) => AllBookScreen());
        break;
      case routeBookInfo:
        return MaterialPageRoute(
            settings: settings, builder: (_) => BookDetailsScreen());
        break;
      case routePdfFile:
        return MaterialPageRoute(
            settings: settings, builder: (_) => PDFScreen());
        break;
      case routeBookList:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const BookList());
        break;
      case routeWelcome:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const welcomePage());
        break;

      case routeForgotPassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => ForgotPassword());
        break;

      case routeProfilePage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ProfilePage());
        break;
      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const welcomePage());
    }
  }
}
