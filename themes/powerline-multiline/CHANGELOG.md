# CHANGELOG - Powerline Multiline Theme

## v1.1.0 - 2025-12-25

### ✨ Nuevas Características

#### Truncado Inteligente de Rutas
- Implementada función `__powerline_truncate_path()` para manejar rutas largas
- Estrategia de truncado multi-nivel:
  1. **Nivel 1:** Abreviar directorios intermedios a su primera letra
  2. **Nivel 2:** Mostrar solo los últimos 2 directorios
  3. **Nivel 3:** Solo el nombre del directorio actual
- Variables de configuración nuevas:
  - `POWERLINE_ENABLE_PATH_TRUNCATION` (default: `true`)
  - `POWERLINE_PATH_MAX_WIDTH` (default: `40`)

#### Adaptación Dinámica al Ancho de Terminal
- Implementada función `__powerline_get_terminal_width()` 
- El prompt ahora se adapta automáticamente al ancho de la terminal
- Reserva inteligente de espacio: 70% izquierda, 30% derecha
- Ocultamiento automático de segmentos en terminales estrechas
- Prevención de overlapping de texto

### 🔧 Cambios Técnicos

**powerline-multiline.base.sh:**
- Nueva función: `__powerline_get_terminal_width()`
  - Obtiene el ancho real del terminal con fallback a 80 columnas
  
- Nueva función: `__powerline_truncate_path()`
  - Trunca rutas inteligentemente manteniendo legibilidad
  - Soporta 3 niveles de truncado progresivo
  
- Mejorada función: `__powerline_right_segment()`
  - Verifica ancho disponible antes de agregar segmentos
  - Evita que el prompt derecho sea demasiado largo
  
- Mejorada función: `__powerline_prompt_command()`
  - Calcula dinámicamente el ancho disponible
  - Posiciona el cursor dinamicamente (no hardcoded a 500)
  - Maneja CWD con truncado inteligente
  - Actualiza cálculos de desplazamiento dinámico

**powerline-multiline.theme.sh:**
- Agregadas nuevas variables de configuración para truncado
- Se mantiene compatible con configuraciones anteriores

### 📚 Documentación

- **README.md:** Sección nueva sobre truncado inteligente y adaptación de terminal
- **CUSTOMIZATION.md:** Guía completa con ejemplos de uso

### 🎯 Beneficios

✅ Rutas largas ya no rompen el layout del prompt  
✅ Compatible con terminales de cualquier ancho  
✅ Mejor legibilidad en directorios anidados profundos  
✅ Sin cambios en la experiencia del usuario (configuración por defecto)  
✅ Totalmente personalizable si se desea  

### 🔄 Retro-compatibilidad

- Todas las configuraciones anteriores siguen siendo válidas
- Las nuevas variables tienen valores por defecto inteligentes
- Sin cambios en el comportamiento visual por defecto

### 📋 Ejemplos de Mejora

**Antes:**
```
~/proyectos/mi-nuevo-proyecto-awesome/arquitectura/modulos/servicios
```
Ruta muy larga que ocupa demasiado espacio

**Después:**
```
~/p/m/a/m/s/servicios
```
Ruta abreviada pero aún legible con contexto

### 🐛 Problemas Resueltos

- Posicionamiento frágil del prompt derecho (hardcoded a 500 columnas)
- Sin validación de ancho de terminal
- Rutas muy largas sin truncado
- Segmentos derechos causando overlapping

---

## v1.0.0 - Inicial

Versión original del tema powerline-multiline
