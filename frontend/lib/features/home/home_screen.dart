// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../foodfilter/screens/filter_screen.dart';
import '../favoritos/screens/favoritos_screen.dart';
import '../perfil/screens/perfil_screen.dart';
import '../negocio/screens/dashboard_screen.dart';
import '../negocio/screens/menu_gestion_screen.dart';
import '../negocio/logic/dashboard_controller.dart';
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

  // Controlador de dashboard para detectar nuevas reseñas (solo para Dueños)
  DashboardController? _dashboardController;

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

      // Inicializar el controller de dashboard para dueños
      if (_rol == 'Dueño') {
        _dashboardController = DashboardController();
        _dashboardController!.addListener(_onDashboardUpdate);
        _dashboardController!.cargarDashboard();
      }
    }
  }

  void _onDashboardUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dashboardController?.removeListener(_onDashboardUpdate);
    _dashboardController?.dispose();
    super.dispose();
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
    final nuevasResenas = _dashboardController?.nuevasResenas ?? 0;

    final screens = esDueno
        ? const <Widget>[DashboardScreen(), MenuGestionScreen(), PerfilScreen()]
        : const <Widget>[FilterScreen(), FavoritosScreen(), PerfilScreen()];

    final navItems = esDueno
        ? <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: nuevasResenas > 0,
                label: Text('$nuevasResenas'),
                child: const Icon(Icons.dashboard_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: nuevasResenas > 0,
                label: Text('$nuevasResenas'),
                child: const Icon(Icons.dashboard),
              ),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menú',
            ),
            const BottomNavigationBarItem(
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de ComeSur?'),
            content: const Text('¿Deseas salir de la aplicación?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Salir'),
              ),
            ],
          ),
        );
        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            // Al tocar Dashboard, limpiar badge de notificaciones
            if (esDueno && i == 0 && nuevasResenas > 0) {
              _dashboardController?.marcarResenasVistas();
            }
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: navItems,
        ),
      ),
    );
  }
}
