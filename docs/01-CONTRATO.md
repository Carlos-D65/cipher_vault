# Contrato técnico de CipherVault

## 1. Propósito

Este documento establece las reglas técnicas que deben respetarse al modificar o ampliar CipherVault.

Su objetivo es conservar la arquitectura, el comportamiento de seguridad y la coherencia visual y funcional del proyecto.

## 2. Regla de fuente visual

La interfaz de CipherVault debe respetar el diseño establecido para el proyecto.

No se deben introducir rediseños, componentes, pantallas o comportamientos visuales ajenos a la especificación existente sin una decisión explícita del proyecto.

## 3. Regla de arquitectura

El código debe mantenerse modular.

Las responsabilidades deben permanecer separadas entre:

- presentación;
- providers y controllers;
- casos de uso;
- repositorios;
- servicios de seguridad;
- almacenamiento;
- compartir información;
- componentes de plataforma.

No se deben trasladar responsabilidades de seguridad, almacenamiento o persistencia directamente a widgets cuando existe una capa apropiada para ellas.

## 4. Regla criptográfica

CipherVault debe utilizar implementaciones criptográficas reales.

No se permiten:

- algoritmos simulados;
- claves fijas para producción;
- contraseñas utilizadas directamente como claves;
- datos criptográficos inventados;
- sustituciones que hagan que una operación parezca cifrada sin realizar cifrado real.

## 5. Algoritmos estándar

Las implementaciones estándar de AES-256-GCM y ChaCha20-Poly1305 deben permanecer separadas.

No se deben convertir en una única clase que mezcle las dos implementaciones.

## 6. Derivación de claves

Las contraseñas deben pasar por Argon2id antes de utilizarse para obtener material criptográfico.

El sistema utiliza salt aleatorio y parámetros serializados en el payload.

## 7. Datos autenticados

Los metadatos relevantes del payload deben formar parte del material autenticado mediante AAD.

La modificación de los datos autenticados debe provocar el fallo correspondiente de autenticación.

## 8. Formatos versionados

El formato estándar utiliza `CVLT1`.

El formato avanzado utiliza `CVLT2`.

Los formatos deben conservar su versionado y no deben modificarse de manera incompatible sin actualizar su codec y su documentación.

## 9. Cifrado avanzado

ML-KEM se utiliza como mecanismo de establecimiento de secreto y no como sustituto del cifrado de mensajes.

El mensaje continúa protegido mediante un algoritmo AEAD.

La derivación híbrida utiliza el secreto derivado de la contraseña y el secreto compartido de ML-KEM antes de producir la clave final mediante HKDF.

## 10. Material de claves

La identidad ML-KEM utilizada por el sistema avanzado se almacena mediante almacenamiento seguro del dispositivo.

Las claves privadas no deben aparecer en logs, mensajes de error ni interfaces de usuario.

## 11. Esteganografía

El mecanismo actual utiliza PNG y bits LSB de los canales RGB.

El formato interno debe conservar su marcador, versión, longitud, payload y verificación CRC32.

## 12. Errores

Los errores internos no deben exponerse innecesariamente al usuario.

La interfaz debe mostrar mensajes comprensibles, mientras que la implementación conserva la separación entre excepciones, fallos y estados de UI.

## 13. Dependencias

No se deben incorporar paquetes innecesarios.

Toda nueva dependencia debe tener una función real dentro de la implementación.

## 14. Código

Se debe priorizar:

- null safety;
- responsabilidades únicas;
- nombres coherentes;
- archivos manejables;
- ausencia de código duplicado;
- ausencia de variables duplicadas con significados diferentes;
- interfaces claras entre capas.

## 15. Cambios

Antes de reemplazar una implementación existente se debe comprobar qué clases dependen de ella.

Un cambio no debe resolver un error local introduciendo una inconsistencia en otra capa.

## 16. Documentación

Cuando una funcionalidad implementada cambie de forma relevante, debe actualizarse la documentación correspondiente.

No se deben documentar como implementadas funcionalidades que solamente estén planeadas.

## 17. Regla final

La prioridad es conservar tres propiedades:

1. comportamiento real;
2. seguridad real;
3. arquitectura mantenible.

Una modificación que sacrifique una de estas propiedades para obtener una solución rápida debe revisarse antes de incorporarse al proyecto.
