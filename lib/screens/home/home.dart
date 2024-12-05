import 'package:assignment_2_offline_capabilities_with_local_storage/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/custom_shape/container/rounded_container.dart';
import '../../providers/connectivity_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _fetchUsers () async {
    final isConnected = context.read<ConnectivityProvider>().isConnected;
    await context.read<UserProvider>().fetchUsers(isConnected: isConnected);
  }

  @override
  void initState() {
    final connectivity = context.read<ConnectivityProvider>();
    connectivity.onConnectedCallback = () async {
      await _fetchUsers();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isConnected = context.read<ConnectivityProvider>().isConnected;
      if (isConnected) {
        _fetchUsers();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('USER INFO', style: TextStyle(fontSize: 18),),),
      body: Stack(
        children: [
          /// -- Background Container Design
          Positioned(
            top: -150.0,
            right: -250.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            top: 100.0,
            right: -300.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -150.0,
            left: -250.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              radius: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: 100.0,
            left: -300.0,
            child: YRoundedContainer(
              height: 400.0,
              width: 400.0,
              radius: 400.0,
              backgroundColor: const Color(0xFF4868FF).withOpacity(0.1),
            ),
          ),

          /// -- Internet Connection Container & Showing Data
          RefreshIndicator(
            onRefresh: () async {
              await _fetchUsers();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ConnectivityProvider>(
                  builder: (context, provider, child) {
                    if (!provider.isConnected) {
                      return Container(
                        width: double.infinity,
                        color: Colors.red.withOpacity(0.9),
                        padding: const EdgeInsets.all(6.0),
                        child: const Text(
                          "No Internet Connection",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                /// - Showing Data in the ListView.builder
                Expanded(
                  child: Consumer<UserProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (provider.users.isEmpty) {
                        return const Center(
                            child: Text('No posts available.'));
                      }
                      return ListView.builder(
                        itemCount: provider.users.length,
                        itemBuilder: (_, index) {
                          final user = provider.users[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                    child: Text(user.id.toString())),
                                title: Text(user.name),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Username: ${user.username}'),
                                    Text('E-mail: ${user.email}'),
                                    Text('Phone: ${user.phone}'),
                                    Text('Website: ${user.website}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
