# Personalización del Tema Powerline-Multiline

Este documento describe las nuevas opciones de personalización disponibles en la versión mejorada del tema powerline-multiline.

## Truncado Inteligente de Rutas

### Variables de Configuración

```bash
# Habilitar/deshabilitar truncado inteligente de rutas
POWERLINE_ENABLE_PATH_TRUNCATION=true    # default

# Ancho máximo de la ruta antes de truncar (caracteres)
POWERLINE_PATH_MAX_WIDTH=40              # default
```

### Estrategia de Truncado

El tema implementa una estrategia inteligente de truncado en 3 niveles:

#### Nivel 1: Abreviación de directorios intermedios
```
Ruta original:    /home/usuario/proyectos/mi-proyecto/src/components
Ruta truncada:    ~/p/m/s/components
```

Las primeras letras de los directorios intermedios se preservan, manteniendo:
- El símbolo `~` (home)
- Todos los directorios intermedios abreviados a su primer letra
- El nombre completo del directorio actual (última carpeta)

#### Nivel 2: Mostrar solo últimos 2 directorios
```
Ruta original:    /home/usuario/very/long/directory/structure/that/is/quite/deep/src
Ruta truncada:    ~/deep/src
```

Si la abreviación aún no cabe, muestra solo:
- El directorio padre
- El directorio actual

#### Nivel 3: Solo nombre del directorio
```
Ruta original:    /home/usuario/a/very/long/directory/with/extremely/deep/nesting
Ruta truncada:    ~/nesting
```

Como último recurso, solo se muestra el nombre del directorio actual.

## Adaptación al Ancho de Terminal

El tema ahora se adapta dinámicamente al ancho de tu terminal:

### Comportamiento Automático

- **Terminal ancha (>80 columnas):** Se muestran todos los segmentos
  - Izquierda: SCM, Python, Ruby, CWD
  - Derecha: Vim, Reloj, Batería, Usuario

- **Terminal normal (60-80 columnas):** Se ocultan algunos segmentos del lado derecho
  - Los segmentos menos críticos se eliminan automáticamente

- **Terminal estrecha (<60 columnas):** Solo los elementos esenciales
  - Solo CWD y status del último comando

### Reserva de Espacio

El tema reserva automáticamente:
- **70%** del ancho para el prompt izquierdo
- **30%** del ancho para el prompt derecho

Esto previene que el prompt se superponga con comandos largos.

## Ejemplos de Configuración

### Configuración Predeterminada
```bash
# En tu ~/.bashrc
OSH_THEME="powerline-multiline"
# Las nuevas mejoras están activadas por defecto
```

### Desabilitar Truncado (Mostrar Rutas Completas)
```bash
# En tu ~/.bashrc
OSH_THEME="powerline-multiline"
POWERLINE_ENABLE_PATH_TRUNCATION=false
```

### Rutas Más Agresivas
```bash
# Limitar a 30 caracteres
POWERLINE_PATH_MAX_WIDTH=30
```

### Rutas Menos Agresivas
```bash
# Permitir hasta 50 caracteres
POWERLINE_PATH_MAX_WIDTH=50
```

### Personalización Completa
```bash
# ~/.bashrc
OSH_THEME="powerline-multiline"

# Truncado inteligente
POWERLINE_ENABLE_PATH_TRUNCATION=true
POWERLINE_PATH_MAX_WIDTH=35

# Colores personalizados (existentes)
CWD_THEME_PROMPT_COLOR=33
CLOCK_THEME_PROMPT_COLOR=240

# Formato de reloj (existente)
THEME_CLOCK_FORMAT="%H:%M"

# Orden de segmentos izquierda (existente)
POWERLINE_LEFT_PROMPT="scm python_venv ruby cwd"

# Orden de segmentos derecha (existente)
POWERLINE_RIGHT_PROMPT="in_vim clock battery user_info"
```

## Comparación: Antes vs Después

### Antes (Rutas Largas)
```
┌─ ~/proyectos/mi-nuevo-proyecto-awesome/arquitectura/modulos/servicios/authentication/handlers ─────── 14:30:23 ⚡87% user@host ─┐
│                                                                                                                               │
❯ 
```
*El prompt es demasiado largo y ocupa múltiples líneas*

### Después (Con Truncado Inteligente)
```
┌─ ~ ─ master ─ ~/p/m/a/m/s/authentication/handlers ──────────────────────────── 14:30 ⚡87% user@host ─┐
│                                                                                                        │
❯
```
*El prompt está balanceado y se adapta automáticamente*

## Variables Heredadas (Seguimiento Compatible)

Las siguientes opciones de configuración siguen siendo válidas:

```bash
# Separadores personalizados
POWERLINE_LEFT_SEPARATOR=""  # default
POWERLINE_RIGHT_SEPARATOR="" # default

# Carácter del prompt
PROMPT_CHAR="❯"              # default

# Formato de reloj
THEME_CLOCK_FORMAT="%H:%M:%S"

# Colores personalizados
CWD_THEME_PROMPT_COLOR=240
CLOCK_THEME_PROMPT_COLOR=240
BATTERY_STATUS_THEME_PROMPT_GOOD_COLOR=70
# ... y más
```

## Problemas y Soluciones

### El prompt sigue siendo muy largo
**Solución:** Reduce `POWERLINE_PATH_MAX_WIDTH`
```bash
POWERLINE_PATH_MAX_WIDTH=25
```

### Las rutas están muy abreviadas y no se entienden
**Solución:** Aumenta `POWERLINE_PATH_MAX_WIDTH`
```bash
POWERLINE_PATH_MAX_WIDTH=50
```

### El reloj/batería desaparecen en terminal pequeña
**Comportamiento esperado:** El tema oculta automáticamente segmentos menos críticos en terminales estrechas.

### Los caracteres de Powerline no se muestran
**Solución:** Instala una fuente con soporte Powerline:
- [Fuentes Powerline Recomendadas](https://github.com/powerline/fonts)
- O usa [Nerd Fonts](https://www.nerdfonts.com/) (más completas)

## Ventajas de las Mejoras

✅ **Rutas inteligentes:** Mantienen legibilidad sin perder contexto  
✅ **Adaptable:** Se ajusta automáticamente a cualquier ancho de terminal  
✅ **Sin problemas:** No causa superposición de texto  
✅ **Configurable:** Totalmente personalizable si lo deseas  
✅ **Retro-compatible:** Las configuraciones antiguas siguen funcionando  
