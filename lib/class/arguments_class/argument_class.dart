
// List Customer.
class CustomerListArgs{
  final double drawerWidth;
  final double selectedDestination;
  CustomerListArgs({required this.drawerWidth,required this.selectedDestination});
}
// customer status.
class CustomerStatusArgs{
  final double drawerWidth;
  final double selectedDestination;
  CustomerStatusArgs({required this.drawerWidth, required this.selectedDestination, });
}

// List orders.
class ListOrderArgs{
  final double drawerWidth;
  final double selectedDestination;

  // constructor.
  ListOrderArgs({required this.drawerWidth, required this.selectedDestination});
}

// Master Orders.
class MasterListArgs{
  final double drawerWidth;
  final double selectedDestination;
  MasterListArgs({required this.drawerWidth, required this.selectedDestination,});
}
//users.
class UsersListArgs{
  final double drawerWidth;
  final double selectedDestination;

  //Constructor.
  UsersListArgs({required this.drawerWidth, required this.selectedDestination,});
}