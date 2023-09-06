import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerBookingPage.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:new_cross_app/Calendar/RatePage.dart';
import 'package:new_cross_app/Calendar/Tradie/TradieProfilePage.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Profile/profile.dart';
import 'package:new_cross_app/Routes/route_const.dart';
//import 'package:new_cross_app/Sign_up/signup.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
import 'package:new_cross_app/chat/screens/search_page.dart';
import 'package:new_cross_app/stripe/screens/mainStripe2.dart';
//import 'package:new_cross_app/main.dart';

import '../Calendar/Consumer/TradieDemo.dart';
import '../Profile/customer_info_edit.dart';
import '../Profile/profile_home.dart';
import '../Profile/customer_info_edit.dart';
import '../stripe/screens/rating_new.dart';
import 'ErrorPage.dart';
import '../Home Page/home.dart';
import '../chat/screens/chat_screen.dart';
import '../stripe/check_out.dart';

class MyRouter {
  GoRouter router = GoRouter(
      routes: [
        GoRoute(
          name: RouterName.homePage,
          path: '/home/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(child: Home(state.params['userId']!));
          },
        ),
        GoRoute(
          name: RouterName.GuestHome,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(child: Home.G());
          },
        ),
        GoRoute(
          name: RouterName.profilePage,
          path: '/profile/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                // child: Profile(userId: state.params['userId']!));
                child: ProfileHome(userId: state.params['userId']!));
          },
        ),
        GoRoute(
          name: RouterName.Login,
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginPage());
          },
        ),
        GoRoute(
          name: RouterName.SignUp,
          path: '/signUp',
          pageBuilder: (context, state) {
            // return MaterialPage(child: Signup());
            return MaterialPage(child: SignupComstomer());
          },
        ),
        GoRoute(
          name: RouterName.CalendarTradie,
          path: '/calendarT/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: TradieProfilePage(
              tradie: state.params['userId']!,
            ));
          },
        ),
        GoRoute(
          name: RouterName.CalendarConsumer,
          path: '/calendarC/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: ConsumerProfilePage(
              consumer: state.params['userId']!,
            ));
          },
        ),
        GoRoute(
          name: RouterName.chat,
          path: '/chat/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: ChatRoom(
              userId: state.params['userId']!,
            ));
          },
        ),
        GoRoute(
          name: RouterName.ChatSearch,
          path: '/chatSearch/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: Search(
              userId: state.params['userId']!,
            ));
          },
        ),
        GoRoute(
          name: RouterName.ChatRoom,
          path: '/chatRoom/:userId/:chatRoomId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: Chat(
              userId: state.params['userId']!,
              chatRoomId: state.params['chatRoomId']!,
            ));
          },
        ),
        GoRoute(
          name: RouterName.TradieDemo,
          path: '/tradieSelection/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: TradieDemo(userId: state.params['userId']!));
          },
        ),
        GoRoute(
          name: RouterName.Booking,
          path: '/booking/:userId/:tradieId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: ConsumerBooking(
                    userId: state.params['userId']!,
                    tradie: state.params['tradieId']!));
          },
        ),
        GoRoute(
          name: RouterName.Checkout,
          path: '/checkout/:bookingId/:userId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: StripeApp(
                    bookingId: state.params['bookingId']!,
                    userId: state.params['userId']!));
          },
        ),
        GoRoute(
          name: RouterName.Pay,
          path: '/Pay/:bookingId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: StripePay(bookingId: state.params['bookingId']!));
          },
        ),
        GoRoute(
          name: RouterName.Rate,
          path: '/rate/:bookingId',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: Rating(bookingId: state.params['bookingId']!));
          },
        ),
        GoRoute(
          name: RouterName.BookingEditor,
          path: '/bookingEditor',
          pageBuilder: (context, state) {
            return MaterialPage(
                child: BookingEditor());
          },
        ),
        GoRoute(
          name: RouterName.AppointmentEditor,
          path: '/appointmentEditor',
          pageBuilder: (context, state) {
            return const MaterialPage(
                child: AppointmentEditor());
          },
        ),
      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(child: ErrorPage());
      });
}
