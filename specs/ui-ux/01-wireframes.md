# ComeSur - Wireframes

## 1. Pantalla de Login

```
┌─────────────────────────────────────┐
│                                     │
│           COMESUR                   │  ← Título centrado, 36sp, bold
│          BIENVENIDO                 │  ← Subtítulo, verde primario
│       ¿QUÉ BUSCAS COMER?           │  ← Texto secundario
│                                     │
│  ┌─────────────────────────────┐    │
│  │  USUARIO / CORREO           │    │  ← Label, 12sp
│  │  ejemplo@correo.com          │    │  ← Input con hint
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  CONTRASEÑA                 │    │
│  │  ******                      │    │  ← Input obscured
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     INICIAR SESIÓN          │    │  ← Botón primario verde
│  └─────────────────────────────┘    │
│                                     │
│          O ingresa con              │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  G  Login con Google        │    │  ← Botón outlined
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  f  Login con Facebook     │    │
│  └─────────────────────────────┘    │
│                                     │
│      Crear Cuenta Nueva            │  ← Link subrayada
│                                     │
│              🍔                     │  ← Ícono decorativo
└─────────────────────────────────────┘
```

### Especificaciones
- **Padding**: 24dp horizontal, 40dp vertical superior
- **Campos de texto**: border-radius 8dp, sin borde visible
- **Botón primario**: verde, texto blanco, 16sp bold
- **Botón outlined**: borde gris, texto negro
- **Espaciado entre elementos**: 20-30dp

---

## 2. Pantalla de Filtros

```
┌─────────────────────────────────────┐
│  ←  ¿Qué se te antoja?             │  ← AppBar con back
├─────────────────────────────────────┤
│                                     │
│                                     │
│  TIPO DE COMIDA                     │  ← Label
│  ┌─────────────────────────────┐    │
│  │ 🔍  Ej. Hamburguesa, Tacos  │    │  ← TextField con ícono
│  └─────────────────────────────┘    │
│                                     │
│                                     │
│  PRESUPUESTO MÁXIMO (OPCIONAL)      │
│  ┌─────────────────────────────┐    │
│  │ 💰  Ej. 40                 │    │  ← TextField numérico
│  └─────────────────────────────┘    │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │     APLICAR FILTROS         │    │  ← Botón primario
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

### Especificaciones
- **AppBar**: Fondo blanco/negro según tema, título centrado
- **Campos de texto**: 
  - fillColor: grey[200] (light) / grey[900] (dark)
  - border-radius: 8dp
  - prefixIcon: 24dp, color primario
- **Form validation**:
  - Tipo de comida: requerido
  - Presupuesto: opcional, numérico > 0

---

## 3. Pantalla de Resultados

```
┌─────────────────────────────────────┐
│  ←  Resultados                      │  ← AppBar
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │  🍔  Hamburguesa Clásica     │    │  ← Card con ícono
│  │       │                      │    │
│  │       📍 La Casa del Burger  │    │
│  │       ⭐ 4.5                │    │
│  │                      $85.00  │    │  ← Precio alineado derecha
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  🌮  Tacos de Asada         │    │
│  │       │                      │    │
│  │       📍 Taquería El Güero  │    │
│  │       ⭐ 4.2                │    │
│  │                      $60.00  │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  🍕  Pizza Margarita        │    │
│  │       │                      │    │
│  │       📍 Pizzas Express     │    │
│  │       ⭐ 4.8                │    │
│  │                     $120.00 │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

### Especificaciones
- **Lista**: ListView.builder con padding 16dp
- **Card**:
  - margin-bottom: 16dp
  - border-radius: 12dp
  - elevation: 2
  - contentPadding: 16dp
- **Leading**: Container circular 48dp con ícono restaurant
- **Trailing**: Precio en negrita, color primario, 18sp

---

## 4. Empty State (Sin Resultados)

```
┌─────────────────────────────────────┐
│  ←  Resultados                      │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│            🔍                        │  ← Ícono 80dp, gris
│                                     │
│    No hay comidas que coincidan      │
│    con los filtros especificados.   │
│                                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │   MODIFICAR FILTROS         │    │  ← Botón outlined
│  └─────────────────────────────┘    │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. Pantalla de Detalle (Futuro)

```
┌─────────────────────────────────────┐
│  ←  La Casa del Burger        ⋮     │  ← AppBar con opciones
├─────────────────────────────────────┤
│                                     │
│         [Imagen del negocio]         │  ← Banner 200dp
│                                     │
├─────────────────────────────────────┤
│                                     │
│  La Casa del Burger                 │  ← Nombre, 24sp bold
│  ⭐ 4.5 (128 calificaciones)        │  ← Rating con conteo
│  🍔 Americana • 💰$              │  ← Categoría y rango precio
│  📍 Av. Universidad #123            │  ← Dirección
│  🕐 8:00 - 22:00                   │  ← Horario
│                                     │
├─────────────────────────────────────┤
│  Menú del Día                       │  ← Sección
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │ Hamburguesa Clásica      $85 │    │
│  │ Doble carne, queso...   ❤️  │    │  ← Con botón favorito
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ Papas Fritas            $35 │    │
│  │ Crujientes y sabrosas   ❤️  │    │
│  └─────────────────────────────┘    │
│                                     │
├─────────────────────────────────────┤
│  Calificaciones                      │
│  ┌─────────────────────────────┐    │
│  │ ⭐⭐⭐⭐⭐  Excelente...  │    │
│  │ - Juan P. • Hace 2 días     │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## 6. Responsive Behavior

### Mobile (< 600dp)
- Layout de una sola columna
- Botones full-width
- Cards apiladas verticalmente

### Tablet (≥ 600dp)
- Máximo 2 columnas en lista de resultados
- Cards más anchas
- Padding horizontal mayor

---

## 7. Flujo de Navegación Principal

```
┌─────────┐    ┌───────────┐    ┌───────────┐    ┌────────┐
│  Login  │───▶│  Filtros  │───▶│ Resultados│───▶│ Detalle│
└─────────┘    └───────────┘    └───────────┘    └────────┘
     │              │                │
     │              │                │
     ▼              ▼                ▼
[Registro]    [Resultados]      [Favoritos]
(pendiente)    vacíos            (pendiente)
```

---

*Documento actualizado: 2026-03-25*
*Versión: 1.0*
