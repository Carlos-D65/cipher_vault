CipherVault — Master Context

Documento maestro del proyecto.
Este archivo contiene las decisiones aprobadas sobre alcance, arquitectura, UX y criptografía.
Cualquier cambio importante debe ser aprobado antes de modificar estas decisiones.

1. Objetivo del proyecto

CipherVault es una aplicación móvil de privacidad digital basada en dos capas:

CAPA 1 — CRIPTOGRAFÍA
CAPA 2 — ESTEGANOGRAFÍA


Concepto:

Primero protege tu información. Después decide si quieres ocultarla.

La aplicación permitirá:

introducir información;
protegerla mediante criptografía;
obtener un payload cifrado;
copiar o guardar el resultado;
opcionalmente ocultar ese payload dentro de una imagen;
extraer información desde una imagen;
desencriptar el payload y recuperar el mensaje original.

El objetivo es construir una aplicación móvil real, funcional y navegable, no solamente un conjunto de pantallas.

2. Stack
Aplicación
Flutter
Dart
VS Code

Gestión de estado
Riverpod 3.4.2


Riverpod será la única solución de gestión de estado.

No utilizar:

Bloc;
Provider;
GetX;
múltiples gestores de estado.

No agregar riverpod_generator ni build_runner salvo que posteriormente exista una razón técnica justificada y aprobada.

3. Arquitectura oficial

Utilizar:

Clean Architecture + Feature-based Architecture


Estructura:

lib/
├── core/
│   ├── crypto/
│   │   ├── aes/
│   │   ├── chacha20/
│   │   ├── ml_kem/
│   │   ├── kdf/
│   │   ├── payload/
│   │   └── interfaces/
│   ├── steganography/
│   ├── storage/
│   ├── errors/
│   ├── constants/
│   ├── utils/
│   └── security/
│
├── features/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── protect/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── decrypt/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── hide/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/
└── main.dart


Dirección conceptual:

Presentation
      ↓
Domain
      ↓
Data
      ↓
Core / Infrastructure


La UI nunca debe implementar directamente criptografía.

4. Principio arquitectónico

La arquitectura no es un ejercicio separado del producto.

Debe construirse mientras se desarrolla la aplicación real.

No crear capas, abstracciones o patrones innecesarios solamente para "cumplir Clean Architecture".

Crear entidades, casos de uso, repositories, providers y servicios cuando tengan una responsabilidad real dentro de una funcionalidad.

Objetivo:

UI
 ↓
Use Case
 ↓
Repository
 ↓
Implementation
 ↓
Core

5. Diseño visual

El diseño de Figma proporcionado por el usuario es la fuente de verdad visual.

NO rediseñar.

Mantener:

colores;
tipografías;
componentes;
iconos;
espaciados;
bordes;
tarjetas;
botones;
distribución;
navegación;
estilo visual.

Las capturas de Figma deben utilizarse como referencia directa para implementar la aplicación.

Si una parte de la interfaz no puede determinarse claramente a partir del diseño:

preguntar antes de inventar.

No introducir mejoras visuales por iniciativa propia.

6. Áreas principales

La aplicación tiene cuatro áreas:

Home
Protect
Decrypt
Hide


La navegación inferior del diseño contiene:

Inicio
Proteger
Desencriptar
Ocultar


Todas las pantallas secundarias deben permitir regresar al paso anterior.

Cuando sea posible, conservar los datos introducidos por el usuario.

7. Home

Debe funcionar como dashboard principal.

Contiene:

encabezado CipherVault;
configuración;
mensaje principal;
tarjeta de criptografía;
Proteger información;
Desencriptar;
tarjeta de esteganografía;
Explorar Ocultamiento;
actividad reciente;
navegación inferior.

Desde Home deben funcionar:

Proteger información
Desencriptar
Ocultar información

8. Flujo Protect

Flujo:

Home
 ↓
Proteger información
 ↓
Introducir mensaje
 ↓
Introducir contraseña
 ↓
Seleccionar algoritmo
 ↓
Encriptar
 ↓
Procesamiento
 ↓
Resultado


Resultado:

mostrar ciphertext/payload simulado inicialmente;
copiar;
guardar;
ocultar en imagen.

Feedback:

Resultado copiado
Resultado guardado


La opción "Ocultar en imagen" debe ser visualmente destacada.

Debe poder pasar automáticamente el resultado al flujo de esteganografía.

No obligar al usuario a copiar y pegar manualmente el resultado.

9. Flujo Decrypt

Home:

Desencriptar


Debe ofrecer:

Desde una imagen
Desde texto cifrado

Desde imagen
Imagen
 ↓
Extraer información
 ↓
Información cifrada encontrada
 ↓
Introducir contraseña / credenciales
 ↓
Desencriptar
 ↓
Mensaje original

Desde texto
Texto cifrado
 ↓
Credenciales
 ↓
Desencriptar
 ↓
Mensaje original


Ambos caminos deben terminar utilizando el mismo proceso de desencriptación cuando sea posible.

10. Flujo Hide / Steganography

Puede iniciarse:

Desde Protect
Mensaje
 ↓
Cifrado
 ↓
Resultado
 ↓
Ocultar en imagen
 ↓
Imagen
 ↓
Ocultar información
 ↓
Imagen resultante


El payload cifrado debe pasar automáticamente al flujo.

Desde Home

También debe funcionar independientemente:

Home
 ↓
Ocultar
 ↓
Seleccionar imagen
 ↓
Introducir/seleccionar payload cifrado
 ↓
Ocultar información
 ↓
Imagen resultante

11. Regla fundamental de seguridad

La contraseña utilizada para cifrar información:

NUNCA debe almacenarse dentro de la imagen.

La imagen solamente contiene el payload/información cifrada necesaria para la recuperación.

La contraseña permanece separada.

Conceptualmente:

Imagen
 └── CipherVault Payload

Contraseña
 └── permanece fuera de la imagen


Para ML-KEM:

Public Key
Private Key


La private key debe permanecer protegida y nunca introducirse dentro de una imagen.

12. Criptografía

Los algoritmos seleccionados para el proyecto son:

Nivel básico
AES
ChaCha20

Nivel avanzado
AES + ML-KEM
ChaCha20 + ML-KEM


No se utilizará RSA en la aplicación.

No se añadirán otros algoritmos sin aprobación.

13. ML-KEM

ML-KEM debe tratarse correctamente como un:

Key Encapsulation Mechanism (KEM)

No como un cifrado simétrico.

Conceptualmente:

ML-KEM
   ↓
establecimiento/encapsulación de secreto
   ↓
secreto compartido
   ↓
KDF
   ↓
clave simétrica
   ↓
AES / ChaCha20


La construcción criptográfica exacta debe definirse técnicamente antes de implementarla.

No improvisar.

14. Criptografía real vs prototipo

El desarrollo puede comenzar utilizando datos simulados para construir:

UI;
navegación;
estados;
flujos;
interacción.

Posteriormente los mocks serán sustituidos por implementaciones criptográficas reales.

No confundir:

prototipo funcional


con:

seguridad criptográfica real


Cuando se implemente criptografía real debe realizarse una revisión técnica.

15. Regla para librerías criptográficas

No inventar nombres de paquetes, APIs ni métodos.

Antes de seleccionar una dependencia criptográfica:

investigar documentación actual;
comprobar compatibilidad con Flutter/Dart;
comprobar qué construcción criptográfica proporciona;
revisar mantenimiento y limitaciones;
comparar alternativas razonables;
justificar la elección;
aprobar la construcción;
implementar;
crear tests.

Esto aplica especialmente a:

AES
ChaCha20
KDF
ML-KEM
Steganography
Secure Storage

16. CipherVault Payload

La aplicación necesitará un formato de payload versionado.

Conceptualmente podrá contener información como:

CipherVault Payload
├── version
├── algorithm
├── KDF information
├── salt
├── nonce/IV
├── ML-KEM information (si aplica)
├── ciphertext
└── authentication information


Esto es solamente una estructura conceptual inicial.

El formato definitivo debe diseñarse antes de implementar la integración criptográfica y la esteganografía.

No agregar campos innecesarios.

17. Esteganografía

La esteganografía es una segunda capa de privacidad.

Flujo:

Mensaje
 ↓
Criptografía
 ↓
CipherVault Payload
 ↓
Esteganografía
 ↓
Imagen


Recuperación:

Imagen
 ↓
Extracción
 ↓
CipherVault Payload
 ↓
Criptografía
 ↓
Mensaje original


La esteganografía no reemplaza el cifrado.

Primero se cifra.

Después se oculta.

18. Almacenamiento

El proyecto será inicialmente:

local-first


No se requiere:

backend;
API;
servidor;
Firebase;
nube;
sincronización.

No se necesita una base de datos remota.

El almacenamiento local solamente se añadirá cuando una funcionalidad realmente lo necesite.

Las claves privadas, cuando corresponda, deben utilizar almacenamiento seguro y no texto plano.

19. Alcance
Incluido
aplicación móvil;
UI basada en Figma;
navegación;
formularios;
estados;
feedback;
cifrado;
AES;
ChaCha20;
ML-KEM;
KDF;
payload;
esteganografía;
selección de imágenes;
extracción de información;
almacenamiento local;
explicación educativa de los algoritmos.
Fuera del alcance actual
backend;
API;
usuarios;
autenticación;
cuentas;
Firebase;
nube;
sincronización;
pagos;
suscripciones;
RSA;
blockchain;
funcionalidades no aprobadas.
20. Desarrollo por bloques

No trabajar mediante microtareas artificiales.

Incorrecto:

Haz un comando.
Avísame.
Haz otro comando.
Avísame.


Correcto:

Bloque funcional
 ↓
Arquitectura necesaria
 ↓
Archivos
 ↓
Código
 ↓
Configuración
 ↓
Pruebas
 ↓
Funcionalidad funcionando
 ↓
Checkpoint


Cada bloque debe producir una parte visible o funcional del proyecto.

No adelantar fases sin aprobación.

21. Prioridad actual

El objetivo es convertir el diseño existente en una aplicación funcional.

Orden general:

Proyecto Flutter
 ↓
Arquitectura base necesaria
 ↓
Home funcional
 ↓
Navegación
 ↓
Protect funcional con simulación
 ↓
Decrypt funcional con simulación
 ↓
Hide funcional con simulación
 ↓
Integración completa de flujos
 ↓
Criptografía real
 ↓
Esteganografía real
 ↓
Hardening / testing / auditoría


No es necesario terminar toda la arquitectura abstracta antes de comenzar a construir la aplicación.

La arquitectura debe evolucionar de forma controlada junto con las funcionalidades reales.

22. Rol del chat de desarrollo

El chat de desarrollo debe actuar como desarrollador guiado por esta especificación.

Debe:

proporcionar código;
indicar archivos;
explicar decisiones;
proporcionar comandos;
implementar bloques funcionales;
realizar pruebas;
ayudar a solucionar errores.

No debe:

rediseñar Figma;
cambiar la arquitectura;
inventar funcionalidades;
introducir dependencias innecesarias;
implementar algoritmos no aprobados;
adelantarse sin autorización.

Si considera necesario cambiar una decisión:

Problema
 ↓
Motivo técnico
 ↓
Alternativa
 ↓
Impacto
 ↓
Esperar aprobación

23. Estado actual

Fase 0:

COMPLETADA


Entorno:

Flutter
Dart
VS Code
Riverpod 3.4.2


El proyecto Flutter ya fue creado y configurado.

La arquitectura inicial de carpetas ya fue establecida.

24. Próximo objetivo

El próximo bloque debe centrarse en construir la aplicación real, no en continuar creando arquitectura vacía.

Primer objetivo funcional:

HOME
 ↓
UI basada en Figma
 ↓
Navegación real
 ↓
Proteger
 ↓
Desencriptar
 ↓
Ocultar
 ↓
Bottom Navigation


Después se implementarán los flujos individuales.

25. Regla principal

CipherVault debe mantener siempre estas prioridades:

1. Alcance definido
2. Fidelidad al diseño
3. Arquitectura limpia
4. Correctitud criptográfica
5. Seguridad
6. Experiencia de usuario
7. Código mantenible


No sacrificar seguridad por velocidad.

No sacrificar el diseño por preferencias personales.

No sacrificar la arquitectura por copiar tutoriales.

No agregar funcionalidades solamente porque parezcan interesantes.

FIN DEL MASTER CONTEXT