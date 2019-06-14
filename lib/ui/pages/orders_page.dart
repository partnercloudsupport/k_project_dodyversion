import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_project_dodyversion/blocs/service_bloc/service_bloc.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/cards/service_card.dart';

/// This page is to show users who have bought my services
class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  ServiceBloc _mOrdersBloc = new ServiceBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: getMyOrders());
  }

  Widget getMyOrders() {
    _mOrdersBloc.dispatch(LoadAllMyOrders(value: UserRepository.mUser.uid));
    return BlocBuilder(
      bloc: _mOrdersBloc,
      builder: (BuildContext context, ServiceState state) {
        if (state is LoadingState) return Text("loading");
        if (state is LoadServicesSuccessful) {
          if (state.serviceList.length == 0)
            return Center(child: Text("You have no orders yet!"));
          return ListView.builder(
            itemCount: state.serviceList.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: ServiceCard(state.serviceList[i]),
              );
            },
          );
        }

        return Text(state.toString());
      },
    );
  }

  @override
  void dispose() {
    _mOrdersBloc.dispose();
    super.dispose();
  }
}
