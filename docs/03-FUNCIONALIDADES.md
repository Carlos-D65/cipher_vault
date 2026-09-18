# Funcionalidades implementadas

Este documento describe las capacidades actualmente implementadas en CipherVault.

## 1. Home

La aplicación dispone de una pantalla principal desde la que se accede a las funcionalidades principales.

El flujo de navegación contempla:

- Protect.
- Decrypt.
- Hide.
- Advanced dentro del flujo de protección.

## 2. Protect

Protect permite preparar un mensaje para cifrado.

### Entrada

- Mensaje.
- Contraseña.
- Algoritmo.

### Cifrado estándar

Están disponibles:

- AES-256-GCM.
- ChaCha20-Poly1305.

El resultado se convierte en un payload `CVLT1`.

### Acciones sobre el resultado

El payload puede:

- copiarse;
- guardarse;
- compartirse.

El guardado utiliza el selector de archivos disponible mediante la capa de almacenamiento.

## 3. Protect Advanced

Protect incluye un modo avanzado.

Las combinaciones implementadas son:

- AES-256-GCM + ML-KEM.
- ChaCha20-Poly1305 + ML-KEM.

El formato resultante es `CVLT2`.

El sistema utiliza ML-KEM-768 para la identidad avanzada actual.

## 4. Decrypt

Decrypt permite recuperar el mensaje original desde un payload.

### Desde imagen

Puede seleccionarse una imagen PNG que contenga un payload de CipherVault.

La aplicación extrae el payload mediante el servicio de esteganografía.

### Desde texto

También puede procesarse directamente un payload textual.

### Detección de formato

El sistema reconoce:

```text
CVLT1.
CVLT2.
```

y selecciona automáticamente el mecanismo de descifrado correspondiente.

### Resultado

Después del descifrado, el texto puede:

- copiarse;
- guardarse;
- compartirse.

## 5. Hide

Hide permite ocultar un payload cifrado dentro de una imagen.

El flujo es:

```text
Payload cifrado
       +
Imagen PNG
       |
       v
Esteganografía
       |
       v
PNG protegido
```

La implementación utiliza bits menos significativos de canales RGB.

## 6. Esteganografía

El formato interno de CipherVault incorpora:

- magic `CVST`;
- versión;
- longitud;
- payload;
- CRC32.

La verificación permite detectar datos extraídos que no corresponden al formato esperado o que fueron alterados.

## 7. Almacenamiento

CipherVault dispone de almacenamiento local de texto y bytes.

También existe una operación de guardado mediante el selector de archivos del sistema.

## 8. Compartir

CipherVault dispone de una abstracción de compartir y una implementación mediante `share_plus`.

Se pueden compartir:

- payloads de texto;
- archivos generados.

## 9. Portapapeles

Los payloads y textos resultantes pueden copiarse al portapapeles mediante el servicio de plataforma correspondiente.

## 10. Estados de interfaz

Las operaciones principales manejan estados como:

- idle;
- operación en progreso;
- éxito;
- error;
- guardando;
- compartiendo.

Decrypt también diferencia la selección y extracción de imagen del proceso de descifrado.

## 11. Comportamiento del cifrado avanzado

El sistema avanzado mantiene una identidad ML-KEM almacenada de forma segura en el dispositivo.

Por esta razón, un payload `CVLT2` generado en un dispositivo depende de la identidad ML-KEM disponible en ese dispositivo para poder recuperar el secreto compartido.

## 12. Dependencias funcionales principales

| Área | Tecnología |
|---|---|
| Framework | Flutter |
| Lenguaje | Dart |
| Criptografía | cryptography |
| ML-KEM | mlkem_native |
| Claves seguras | flutter_secure_storage |
| Archivos | file_picker |
| Imágenes | image |
| Almacenamiento | path_provider |
| Compartir | share_plus |
| Estado | provider |

## 13. Alcance

La documentación de este archivo se limita a funcionalidades que forman parte de la implementación actual. No se incluyen características futuras como si estuvieran disponibles.
