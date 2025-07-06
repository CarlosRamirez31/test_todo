# Todo App - Flutter

Una aplicación de tareas desarrollada con Flutter que implementa Clean Architecture y patrones de diseño modernos.

## 🚀 Características

- ✅ **CRUD completo**: Crear, leer, actualizar y eliminar tareas
- 🔍 **Filtros avanzados**: Por texto, estado completado y fecha
- 📅 **Fechas límite**: Asignar fechas límite a las tareas
- 🎨 **Tema oscuro/claro**: Alternancia entre temas
- 💾 **Almacenamiento local**: Persistencia con SQLite
- 🔄 **Swipe actions**: Editar y eliminar con gestos
- 📱 **Responsivo**: Diseño adaptativo

## ⚡ Inicio Rápido

### 🚀 Instalación y Ejecución

```bash
# 1. Clonar el repositorio
git clone [URL_DEL_REPOSITORIO]
cd test_todo

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la aplicación
flutter run
```

### 📋 Prerequisitos

- **Flutter SDK**: >= 3.0.0
- **Dart**: >= 3.0.0

---


## 🛠️ Decisiones Técnicas

### **1. Arquitectura Clean Architecture**
- **Razón**: Separación clara de responsabilidades y alta testabilidad
- **Beneficios**: 
  - Código mantenible y escalable
  - Fácil testing unitario
  - Independencia de frameworks externos

### **2. BLoC Pattern con Cubit**
- **Razón**: Manejo de estado predecible y reactivo
- **Beneficios**:
  - Estado inmutable
  - Separación entre lógica y UI
  - Fácil testing del estado

### **3. GetIt para Inyección de Dependencias**
- **Razón**: Service locator simple y eficiente
- **Beneficios**:
  - Configuración centralizada
  - Lazy loading de dependencias
  - Fácil mockeo para testing

### **4. GoRouter para Navegación**
- **Razón**: Navegación declarativa y tipada
- **Beneficios**:
  - URLs amigables
  - Mejor manejo de rutas

### **5. SQLite para Almacenamiento**
- **Razón**: Base de datos local ligera y rápida
- **Beneficios**:
  - Sin dependencia de internet
  - Consultas SQL eficientes
  - Soporte multiplataforma

### **6. Patrón Repository**
- **Razón**: Abstracción de la fuente de datos
- **Beneficios**:
  - Fácil cambio de fuente de datos
  - Testing con mocks
  - Separación de responsabilidades

### **7. Either Pattern para Manejo de Errores**
- **Razón**: Manejo explícito de errores y éxito
- **Beneficios**:
  - Errores tipados
  - Flujo de control claro
  - Mejor experiencia de usuario

**Desarrollado con ❤️ y Flutter**
