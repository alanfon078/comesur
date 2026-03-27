# ComeSur - Diseño Visual

## 1. Sistema de Colores

### Paleta Principal

| Nombre | Hex | RGB | Uso |
|--------|-----|-----|-----|
| Primary Green | `#4CAF50` | 76,175,80 | Botones principales, acentos |
| Primary Dark | `#388E3C` | 56,142,60 | Estados pressed |
| Primary Light | `#81C784` | 129,199,132 | Backgrounds sutiles |
| Secondary Grey | `#9E9E9E` | 158,158,158 | Texto secundario |
| Accent Amber | `#FFC107` | 255,193,7 | Estrellas, highlights |

### Tema Claro (Light Theme)

```dart
// Scaffold
scaffoldBackgroundColor: Colors.white

// Primary Color
primaryColor: Colors.green  // #4CAF50

// ColorScheme
colorScheme: ColorScheme.light(
  primary: Colors.green,
  secondary: Colors.grey,
)

// Text
onPrimary: Colors.white
onSecondary: Colors.black
```

### Tema Oscuro (Dark Theme)

```dart
// Scaffold
scaffoldBackgroundColor: Colors.black

// Primary Color
primaryColor: Colors.greenAccent

// ColorScheme
colorScheme: ColorScheme.dark(
  primary: Colors.green,
  secondary: Colors.white,
)

// Text
onPrimary: Colors.black
onSecondary: Colors.white
```

### Colores de Estado

| Estado | Color | Hex | Uso |
|--------|-------|-----|-----|
| Success | Verde | `#4CAF50` | Confirmaciones |
| Warning | Naranja | `#FF9800` | Alertas |
| Error | Rojo | `#F44336` | Errores |
| Info | Azul | `#2196F3` | Información |

---

## 2. Tipografía

### Sistema de Tipografía (Material Design 3)

| Estilo | Font | Size | Weight | Line Height | Uso |
|--------|------|------|--------|-------------|-----|
| Display Large | Roboto | 57sp | 400 | 64sp | N/A |
| Headline Large | Roboto | 32sp | 400 | 40sp | Títulos de pantalla |
| Headline Medium | Roboto | 28sp | 400 | 36sp | Nombres de negocio |
| Title Large | Roboto | 22sp | 500 | 28sp | Títulos de sección |
| Title Medium | Roboto | 16sp | 500 | 24sp | Subtítulos |
| Body Large | Roboto | 16sp | 400 | 24sp | Texto principal |
| Body Medium | Roboto | 14sp | 400 | 20sp | Texto secundario |
| Label Large | Roboto | 14sp | 500 | 20sp | Botones |
| Label Small | Roboto | 11sp | 500 | 16sp | Labels de input |

### Aplicación en la App

```dart
// Títulos de pantalla
Text('¿Qué se te antoja?', 
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// Nombres de negocio
Text('La Casa del Burger',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
)

// Precio
Text('\$85.00',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  ),
)
```

---

## 3. Espaciado y Dimensiones

### Sistema de Espaciado (8pt Grid)

| Nombre | Valor | Uso |
|--------|-------|-----|
| xs | 4dp | Espaciado mínimo entre elementos relacionados |
| sm | 8dp | Padding interno de componentes pequeños |
| md | 16dp | Espaciado estándar entre componentes |
| lg | 24dp | Padding de pantallas |
| xl | 32dp | Espaciado entre secciones |
| xxl | 48dp | Espaciado mayor, márgenes de pantalla |

### Dimensiones de Componentes

| Componente | Dimensión | Observaciones |
|------------|-----------|--------------|
| AppBar Height | 56dp | Estándar Material |
| Button Height | 48dp | Mínimo touch target |
| Input Height | 56dp | TextFields con ícono |
| Card Min Height | 80dp | Cards de resultado |
| FAB Size | 56dp | Floating Action Button |
| Icon Size | 24dp | Íconos de navegación |
| Avatar Size | 40dp | Avatares de usuario |

### Border Radius

| Componente | Radius | Uso |
|-----------|--------|-----|
| TextField | 8dp | Inputs de texto |
| Button | 8dp | Botones primarios |
| Card | 12dp | Cards de contenido |
| Chip | 20dp | Chips de filtro |
| BottomSheet | 16dp (top) | Sheet desde abajo |
| Dialog | 28dp | Ventanas modales |

---

## 4. Íconos (Material Icons)

### Íconos Principales

| Funcionalidad | Ícono | Código |
|---------------|-------|--------|
| Comida | `Icons.fastfood_rounded` | 🍔 |
| Búsqueda | `Icons.search` | 🔍 |
| Filtro | `Icons.filter_list` | ⚙️ |
| Dinero | `Icons.attach_money` | 💰 |
| Ubicación | `Icons.location_on` | 📍 |
| Horario | `Icons.access_time` | 🕐 |
| Teléfono | `Icons.phone` | 📞 |
| Favorito | `Icons.favorite` | ❤️ |
| Favorito Outline | `Icons.favorite_border` | 🤍 |
| Estrella | `Icons.star` | ⭐ |
| Usuario | `Icons.person` | 👤 |
| Atras | `Icons.arrow_back` | ← |
| Menu | `Icons.menu` | ☰ |

### Estados de Íconos

```dart
// Favorito
Icon(
  isFavorite ? Icons.favorite : Icons.favorite_border,
  color: isFavorite ? Colors.red : null,
)

// Rating
Row(
  children: List.generate(5, (index) {
    return Icon(
      index < rating ? Icons.star : Icons.star_border,
      color: Colors.amber,
      size: 16,
    );
  }),
)
```

---

## 5. Sombras y Elevación

### Niveles de Elevación

| Nivel | Elevación | Uso |
|-------|-----------|-----|
| 0 | 0dp | Superficies planas |
| 1 | 1dp | Cards resting |
| 2 | 2dp | Cards elevated, AppBar |
| 3 | 4dp | FAB, Dialogs |
| 4 | 6dp | Navigation drawer |
| 5 | 8dp | Snackbar |

### Aplicación

```dart
// Card resting
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
)

// Card pressed
Card(
  elevation: 1,
  // ...
)
```

---

## 6. Animaciones

### Transiciones de Pantalla

| Transición | Duración | Curva | Uso |
|------------|----------|-------|-----|
| Push | 300ms | easeInOut | Navegación forward |
| Pop | 300ms | easeInOut | Navegación back |
| Fade | 200ms | linear | Cambios de estado |

### Micro-interacciones

| Elemento | Animación | Duración |
|----------|-----------|----------|
| Botón Press | Scale 0.95 | 100ms |
| Loading | CircularProgressIndicator | Indeterminado |
| Skeleton | Shimmer | 1000ms loop |
| Heart | Scale bounce | 200ms |
| Star | Scale 1.2 + color | 150ms |

---

## 7. Assets Visuales

### Placeholder Images

- **Logo**: Vector SVG del logo ComeSur
- **Empty State**: Íconos de Material 80dp
- **Loading**: CircularProgressIndicator con color primario
- **Error**: Ícono error + mensaje

### Imágenes de Negocio (Futuro)

| Tipo | Dimensión | Formato |
|------|-----------|---------|
| Banner | 800x400px | WebP, JPG |
| Logo | 200x200px | PNG, WebP |
| Menú | 600x600px | JPG, WebP |

---

## 8. Dark Mode

### Consideraciones de Accesibilidad

| Elemento | Light | Dark | Contraste |
|----------|-------|------|-----------|
| Background | `#FFFFFF` | `#000000` | ✓ |
| Surface | `#F5F5F5` | `#121212` | ✓ |
| Text Primary | `#000000` (87%) | `#FFFFFF` (87%) | ✓ |
| Text Secondary | `#000000` (60%) | `#FFFFFF` (60%) | ✓ |
| Divider | `#000000` (12%) | `#FFFFFF` (12%) | ✓ |

### Best Practices Implementadas

- [x] Tema claro y oscuro basados en sistema
- [x] Colores con suficiente contraste WCAG AA
- [x] Íconos con color adaptativo
- [x] Sombras más sutiles en dark mode

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
