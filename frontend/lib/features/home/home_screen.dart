// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../foodfilter/screens/filter_screen.dart';
import '../favoritos/screens/favoritos_screen.dart';
import '../perfil/screens/perfil_screen.dart';
import '../negocio/screens/dashboard_screen.dart';
import '../negocio/screens/menu_gestion_screen.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _rol;
  bool _cargandoRol = true;

  @override
  void initState() {
    super.initState();
    _cargarRol();
  }

  Future<void> _cargarRol() async {
    final datos = await AuthService.obtenerDatosUsuario();
    if (mounted) {
      setState(() {
        _rol = datos?['rol'];
        _cargandoRol = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoRol) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final esDueno = _rol == 'Dueño';
    final primaryColor = Theme.of(context).primaryColor;

    final screens = esDueno
        ? const <Widget>[DashboardScreen(), MenuGestionScreen(), PerfilScreen()]
        : const <Widget>[FilterScreen(), FavoritosScreen(), PerfilScreen()];

    final navItems = esDueno
        ? const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menú',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ]
        : const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: navItems,
      ),
    );
  }
}

