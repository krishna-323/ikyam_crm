import 'package:flutter/material.dart';
import '../class/arguments_class/argument_class.dart';
import '../class/routes.dart';
import 'static_files/static_colors.dart';


class CustomDrawer extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CustomDrawer(this.drawerWidth, this.selectedDestination, {Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late double drawerWidth;

  late double _selectedDestination;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drawerWidth = widget.drawerWidth;
    _selectedDestination = widget.selectedDestination;

    // Home.
    if(_selectedDestination==0){
      homeHovered=true;
    }
    //customer status hovered.
    if(_selectedDestination==1){
      customerStatusHovered = true;
    }
    // Customers.
    if(_selectedDestination == 1.1){
      customerHover=false;
      customerExpand=true;
    }
    // Orders
    if(_selectedDestination==2.1){
      orderHover=false;
      orderExpand=true;
    }
    // Master.
    if(_selectedDestination==3.1){
      masterHover=false;
      masterExpand=true;
    }

    // users.
    if(_selectedDestination==4.1){
      userHover=false;
      userExpand=true;
    }
  }

  @override
  dispose(){
    super.dispose();
  }

  // home.
  bool homeHovered=false;

  // customer status.
  bool customerStatusHovered = false;

  // Customer.
  bool customerHover = false;
  bool customerExpand=false;
  // order.
  bool orderHover=false;
  bool orderExpand=false;
  // master.
  bool masterHover=false;
  bool masterExpand=false;
  // Users.
  bool userHover=false;
  bool userExpand=false;


  // Bool For Hover Color.
  bool customerCreationColor=false;
  bool orderCreationColor=false;
  bool masterCreationColor=false;
  bool userCreationColor=false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // stream: bloc.getStream,
        //initialData: bloc.loginData,
        builder: (context, AsyncSnapshot snapshot) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: drawerWidth,
            child: Scaffold(
              //  backgroundColor: Colors.white,
              body: Drawer(
                backgroundColor: Colors.white,
                child: ListView(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const SizedBox(height: 10,),

                    //Home.
                    drawerWidth==60?InkWell(
                      hoverColor: mHoverColor,
                      onTap: (){
                        setState(() {
                          drawerWidth = 190;
                        });
                      },
                      child: SizedBox(height: 40,
                        child: Icon(Icons.home,
                          color: _selectedDestination == 0 ? Colors.blue: Colors.black54,),
                      ),
                    ): MouseRegion(
                      onHover: (event){
                        setState((){
                          //homeHovered=true;
                        });
                      },
                      onExit: (event){
                        setState(() {
                          //homeHovered=false;
                        });

                      },
                      child: Container(
                        color: homeHovered?mHoverColor:Colors.transparent,
                        child: ListTileTheme(
                          contentPadding: const EdgeInsets.only(left: 0),
                          child: ListTile(
                            onTap: () {
                              // Navigator.pushReplacementNamed(
                              //   context,
                              //   CustomerRotes.customerList,
                              //   arguments: CustomerListArgs(
                              //       selectedDestination: 0,
                              //       drawerWidth: widget.drawerWidth),
                              // );
                              Navigator.pushReplacementNamed(context, "/home");
                            },
                            leading: const SizedBox(width: 40,child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(Icons.home),
                            ),),
                            title:    Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                drawerWidth == 60 ? '' : 'Home',
                                style: const TextStyle(fontSize: 14,color: Colors.black),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///Customer Status Draggable.
                    drawerWidth==60?InkWell(
                      hoverColor: mHoverColor,
                      onTap: (){
                        setState(() {
                          drawerWidth = 190;
                        });
                      },
                      child: SizedBox(height: 40,
                        child: Icon(Icons.person,
                          color: _selectedDestination == 1? Colors.blue: Colors.black54,),
                      ),
                    ): MouseRegion(
                      onHover: (event){
                        setState((){
                         // customerStatusHovered=true;

                        });
                      },
                      onExit: (event){
                        setState(() {
                          //customerStatusHovered=false;
                        });

                      },
                      child: Container(
                        color: customerStatusHovered? mHoverColor:Colors.transparent,
                        child: ListTileTheme(
                          contentPadding: const EdgeInsets.only(left: 0),
                          child: ListTile(
                            onTap: () {
                              //Board View Navigator.
                              Navigator.pushReplacementNamed(
                                context,
                                CustomerRotes.customerList,
                                arguments: CustomerListArgs(
                                    selectedDestination: 1,
                                    drawerWidth: widget.drawerWidth),
                              );
                              // Navigator.pushReplacementNamed(context, "/home");
                             // Navigator.pushReplacementNamed(context, "/customerList");
                            },
                            leading: const SizedBox(width: 40,child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Icon(Icons.person),
                            ),),
                            title:    Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                drawerWidth == 60 ? '' : 'Customers',
                                style:  TextStyle(fontSize: 14, color: Colors.black)
                                    //color:_selectedDestination==1?(customerCreationColor==true? Colors.black:Colors.white):Colors.black),

                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Customer Details Creation.
                    // drawerWidth==60?InkWell(
                    //   hoverColor: mHoverColor,
                    //   onTap: (){
                    //     setState(() {
                    //       drawerWidth = 190;
                    //     });
                    //   },
                    //   child: SizedBox(height: 40,
                    //     child: Icon(Icons.person,
                    //       color: _selectedDestination == 1.1
                    //           ? Colors.blue: Colors.black54,),
                    //   ),
                    // ): MouseRegion(
                    //   onHover: (event) {
                    //     setState(() {
                    //       if (customerExpand == false) {
                    //         customerHover = true;
                    //       }
                    //     });
                    //   },
                    //   onExit: (event) {
                    //     setState(() {
                    //       customerHover = false;
                    //     });
                    //   },
                    //   child: Container(
                    //     color: customerHover ? mHoverColor : Colors.transparent,
                    //     child: ListTileTheme(
                    //       contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                    //       child: Theme(
                    //         data: ThemeData().copyWith(dividerColor: Colors.transparent),
                    //         child: ExpansionTile(
                    //           onExpansionChanged: (value) {
                    //             setState(() {
                    //               if (value) {
                    //                 customerExpand = true;
                    //                 customerHover = false;
                    //               } else {
                    //                 customerExpand = false;
                    //               }
                    //             });
                    //           },
                    //           initiallyExpanded: _selectedDestination == 1.1,
                    //           trailing: Padding(
                    //             padding: const EdgeInsets.only(right: 10.0),
                    //             child: Icon(
                    //               Icons.keyboard_arrow_down,
                    //               color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                    //             ),
                    //           ),
                    //           title: Text(drawerWidth == 60 ? '' : "Customer", style: const TextStyle(fontSize: 16)),
                    //           leading: const SizedBox(
                    //             width: 40, // Set a specific width here, adjust as needed
                    //             child: Icon(Icons.person,),
                    //           ),
                    //           children: <Widget>[
                    //             MouseRegion(
                    //               onEnter: (val){
                    //                 setState(() {
                    //                   customerCreationColor=true;
                    //                 });
                    //               },
                    //               onExit:(val){
                    //                 setState(() {
                    //                   customerCreationColor=false;
                    //                 });
                    //               },
                    //               child: ListTile(
                    //                 hoverColor: mHoverColor,
                    //                 selectedTileColor: Colors.blue,
                    //                 selectedColor: Colors.black,
                    //                 title: Center(
                    //                   child: Align(
                    //                     alignment: Alignment.topLeft,
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(left: 15.0),
                    //                       child: Text(drawerWidth == 60 ? '' : 'Customer Creation',
                    //                         style: TextStyle(color:_selectedDestination==1.1?(customerCreationColor==true? Colors.black:Colors.white):Colors.black),),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 selected: _selectedDestination == 1.1,
                    //                 onTap: () {
                    //                   setState(() {
                    //                     _selectedDestination = 1.1;
                    //                   });
                    //                   Navigator.pushReplacementNamed(
                    //                     context,
                    //                     CustomerRotes.customerList,
                    //                     arguments: CustomerListArgs(
                    //                         selectedDestination: 1.1,
                    //                         drawerWidth: widget.drawerWidth),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                     /// Orders Placed.
                    drawerWidth==60?InkWell(
                      hoverColor: mHoverColor,
                      onTap: (){
                        setState(() {
                          drawerWidth = 190;
                        });
                      },
                      child: SizedBox(height: 40,
                        child: Icon(Icons.production_quantity_limits,
                          color: _selectedDestination == 2.1
                              ? Colors.blue: Colors.black54,),
                      ),
                    ): MouseRegion(
                      onHover: (event) {
                        setState(() {
                          if (orderExpand == false) {
                            orderHover = true;
                          }
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          orderHover = false;
                        });
                      },
                      child: Container(
                        color: orderHover ? mHoverColor : Colors.transparent,
                        child: ListTileTheme(
                          contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                          child: Theme(
                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              onExpansionChanged: (value) {
                                setState(() {
                                  if (value) {
                                    orderExpand = true;
                                    orderHover = false;
                                  } else {
                                    orderExpand = false;
                                  }
                                });
                              },
                              initiallyExpanded: _selectedDestination == 2.1,
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                                ),
                              ),
                              title: Text(drawerWidth == 60 ? '' : "Order", style: const TextStyle(fontSize: 16)),
                              leading: const SizedBox(
                                width: 40, // Set a specific width here, adjust as needed
                                child: Icon(Icons.production_quantity_limits,),
                              ),
                              children: <Widget>[
                                MouseRegion(
                                  onEnter: (val){
                                    setState(() {
                                      orderCreationColor=true;
                                    });
                                  },
                                  onExit:(val){
                                    setState(() {
                                      orderCreationColor=false;
                                    });
                                  },
                                  child: ListTile(
                                    hoverColor: mHoverColor,
                                    selectedTileColor: Colors.blue,
                                    selectedColor: Colors.black,
                                    title: Center(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(drawerWidth == 60 ? '' : 'Order Creation',
                                            style: TextStyle(color:_selectedDestination==2.1?(orderCreationColor==true? Colors.black:Colors.white):Colors.black),),
                                        ),
                                      ),
                                    ),
                                    selected: _selectedDestination == 2.1,
                                    onTap: () {
                                      setState(() {
                                        _selectedDestination = 2.1;
                                      });

                                      Navigator.pushReplacementNamed(
                                        context,
                                        CustomerRotes.orderList,
                                        arguments: ListOrderArgs(
                                            selectedDestination: 2.1,
                                            drawerWidth: widget.drawerWidth),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Master.
                    // drawerWidth==60?InkWell(
                    //   hoverColor: mHoverColor,
                    //   onTap: (){
                    //     setState(() {
                    //       drawerWidth = 190;
                    //     });
                    //   },
                    //   child: SizedBox(height: 40,
                    //     child: Icon(Icons.person_outline_outlined,
                    //       color: _selectedDestination == 3.1
                    //           ? Colors.blue: Colors.black54,),
                    //   ),
                    // ): MouseRegion(
                    //   onHover: (event) {
                    //     setState(() {
                    //       if (masterExpand == false) {
                    //         masterHover = true;
                    //       }
                    //     });
                    //   },
                    //   onExit: (event) {
                    //     setState(() {
                    //       masterHover = false;
                    //     });
                    //   },
                    //   child: Container(
                    //     color: masterHover ? mHoverColor : Colors.transparent,
                    //     child: ListTileTheme(
                    //       contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                    //       child: Theme(
                    //         data: ThemeData().copyWith(dividerColor: Colors.transparent),
                    //         child: ExpansionTile(
                    //           onExpansionChanged: (value) {
                    //             setState(() {
                    //               if (value) {
                    //                 masterExpand = true;
                    //                 masterHover = false;
                    //               } else {
                    //                 masterExpand = false;
                    //               }
                    //             });
                    //           },
                    //           initiallyExpanded: _selectedDestination == 3.1,
                    //           trailing: Padding(
                    //             padding: const EdgeInsets.only(right: 10.0),
                    //             child: Icon(
                    //               Icons.keyboard_arrow_down,
                    //               color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                    //             ),
                    //           ),
                    //           title: Text(drawerWidth == 60 ? '' : "Master", style: const TextStyle(fontSize: 16)),
                    //           leading: const SizedBox(
                    //             width: 40, // Set a specific width here, adjust as needed
                    //             child: Icon(Icons.person_outline_outlined,),
                    //           ),
                    //           children: <Widget>[
                    //             MouseRegion(
                    //               onEnter: (val){
                    //                 setState(() {
                    //                   masterCreationColor=true;
                    //                 });
                    //               },
                    //               onExit:(val){
                    //                 setState(() {
                    //                   masterCreationColor=false;
                    //                 });
                    //               },
                    //               child: ListTile(
                    //                 hoverColor: mHoverColor,
                    //                 selectedTileColor: Colors.blue,
                    //                 selectedColor: Colors.black,
                    //                 title: Center(
                    //                   child: Align(
                    //                     alignment: Alignment.topLeft,
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(left: 15.0),
                    //                       child: Text(drawerWidth == 60 ? '' : 'Master Data',
                    //                         style: TextStyle(color:_selectedDestination==3.1?(masterCreationColor==true? Colors.black:Colors.white):Colors.black),),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 selected: _selectedDestination == 3.1,
                    //                 onTap: () {
                    //                   setState(() {
                    //                     _selectedDestination = 3.1;
                    //                   });
                    //
                    //                   Navigator.pushReplacementNamed(
                    //                     context,
                    //                     // Abstract Class For Routes Name.
                    //                     CustomerRotes.masterList,
                    //                     // Arguments Class.
                    //                     arguments: MasterListArgs(
                    //                         selectedDestination: 3.1,
                    //                         drawerWidth: widget.drawerWidth),
                    //                   );
                    //
                    //                 },
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                     /// Users.
                    drawerWidth==60?InkWell(
                      hoverColor: mHoverColor,
                      onTap: (){
                        setState(() {
                          drawerWidth = 190;
                        });
                      },
                      child: SizedBox(height: 40,
                        child: Icon(Icons.supervised_user_circle_sharp,
                          color: _selectedDestination == 4.1
                              ? Colors.blue: Colors.black54,),
                      ),
                    ): MouseRegion(
                      onHover: (event) {
                        setState(() {
                          if (userExpand == false) {
                            userHover = true;
                          }
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          userHover = false;
                        });
                      },
                      child: Container(
                        color: userHover ? mHoverColor : Colors.transparent,
                        child: ListTileTheme(
                          contentPadding: const EdgeInsets.only(left: 10), // Remove default padding
                          child: Theme(
                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              onExpansionChanged: (value) {
                                setState(() {
                                  if (value) {
                                    userExpand = true;
                                    userHover = false;
                                  } else {
                                    userExpand = false;
                                  }
                                });
                              },
                              initiallyExpanded: _selectedDestination == 4.1,
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                                ),
                              ),
                              title: Text(drawerWidth == 60 ? '' : "Users", style: const TextStyle(fontSize: 16)),
                              leading: const SizedBox(
                                width: 40, // Set a specific width here, adjust as needed
                                child: Icon(Icons.supervised_user_circle_sharp,),
                              ),
                              children: <Widget>[
                                MouseRegion(
                                  onEnter: (val){
                                    setState(() {
                                      userCreationColor=true;
                                    });
                                  },
                                  onExit:(val){
                                    setState(() {
                                      userCreationColor=false;
                                    });
                                  },
                                  child: ListTile(
                                    hoverColor: mHoverColor,
                                    selectedTileColor: Colors.blue,
                                    selectedColor: Colors.black,
                                    title: Center(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: Text(drawerWidth == 60 ? '' : 'Users Management',
                                            style: TextStyle(color:_selectedDestination==4.1?(userCreationColor==true? Colors.black:Colors.white):Colors.black),),
                                        ),
                                      ),
                                    ),
                                    selected: _selectedDestination == 4.1,
                                    onTap: () {
                                      setState(() {
                                        _selectedDestination = 4.1;
                                      });

                                      Navigator.pushReplacementNamed(
                                        context,
                                        // Abstract Class For Routes Name.
                                        CustomerRotes.usersList,
                                        // Arguments Class.
                                        arguments: UsersListArgs(
                                            selectedDestination: 4.1,
                                            drawerWidth: widget.drawerWidth),
                                      );

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              bottomNavigationBar: SizedBox(
                height: 30,
                width: 50,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        if (drawerWidth == 60) {
                          drawerWidth = 190;
                        } else {
                          drawerWidth = 60;
                        }
                      });
                    },
                    child:
                    Align(alignment:Alignment.center,child: Text(drawerWidth == 60 ? ">" : "<"))),
              ),
            ),
          );
        }
    );
  }
}






