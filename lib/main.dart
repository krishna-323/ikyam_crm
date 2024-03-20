import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ikyam_crm/users/users_list.dart';
import 'class/arguments_class/argument_class.dart';
import 'class/routes.dart';
import 'customer/list_customer.dart';
import 'customer_status/customer_status.dart';
import 'dashboard/home_screen.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'master/master_list.dart';
import 'order/order_list.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Registration',
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings){
      Widget newScreen;
      // Switch case.
      switch (settings.name) {

        //-----Case 1.
      // CustomerRoutes is Abstract Class.
        case CustomerRotes.customerList:
          // CustomerListArgs Is a Class.
        CustomerListArgs customerList;

        if(settings.arguments!=null){
          customerList=settings.arguments as CustomerListArgs;
        }
        else{
         customerList=CustomerListArgs(drawerWidth: 190, selectedDestination: 1);
        }
        newScreen =CustomerList(arg: customerList);
        break;
        //------Case 2.
        case CustomerRotes.customerStatus:
        CustomerStatusArgs customerStatus;
        if(settings.arguments!=null){
          customerStatus= settings.arguments as CustomerStatusArgs;
        }
        else{
          customerStatus = CustomerStatusArgs(drawerWidth: 190, selectedDestination:1);
        }
        newScreen = CustomerStatus(args:customerStatus ,);
        break;

        // -----Case 2.
        case CustomerRotes.orderList:
        ListOrderArgs orderList;
        if(settings.arguments!=null){
          orderList= settings.arguments as ListOrderArgs;
        }
          else{
            orderList = ListOrderArgs(drawerWidth: 190, selectedDestination: 2.1);
        }
          newScreen = OrderList(args:orderList);
        break;
          //case 3.
        case CustomerRotes.masterList:
          MasterListArgs masterList;
          if(settings.arguments!=null){
            masterList= settings.arguments as MasterListArgs;
          }
          else{
          masterList=MasterListArgs(drawerWidth: 190, selectedDestination: 3.1);
          }
          newScreen= MasterList(args:masterList);
          break;
          //Case 4.
        case CustomerRotes.usersList:
          UsersListArgs userList;
          if(settings.arguments!=null){
            userList =settings.arguments as UsersListArgs;
          }
          else{
            userList =UsersListArgs(drawerWidth: 190, selectedDestination: 4.1) ;
          }
          newScreen =UserList(args:userList);
          break;

        case CustomerRotes.homeRoute:newScreen =const MyHomePage();
        break;

        default :newScreen = const InitialScreen();
      }
      return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen,
          reverseTransitionDuration: Duration.zero,transitionDuration: Duration.zero,settings: settings);
      },

      routes: {
      "/":(context)=>const InitialScreen(),
      },
      theme: ThemeData(useMaterial3: true,
      fontFamily: 'TitilliumWeb'
      ),
      );
  }
}


// Initial Screen Class.
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

