# CipherVault

Aplicación Flutter local de cifrado y esteganografía, implementada siguiendo la captura de diseño suministrada.

## Arquitectura

- `features/`: pantallas y flujos de producto.
- `services/encryption/`: contrato y adaptadores independientes para AES-GCM-256 y ChaCha20-Poly1305.
- `services/steganography/`: LSB RGB sobre imágenes que se reexportan como PNG sin pérdida.
- `services/storage/`: persistencia local de ciphertext e imágenes.
- `services/sharing/`: integración con el diálogo de compartir del sistema.
- `services/clipboard/`: portapapeles.
- `models/`: formato versionado de ciphertext y tipos de dominio.
- `core/theme/`: tokens visuales tomados de la referencia.
- `widgets/`: componentes reutilizables.

## Dependencias verificadas

Las versiones fijadas en `pubspec.yaml` fueron contrastadas con pub.dev al implementar esta versión: `cryptography 2.9.0`, `cryptography_flutter 2.3.4`, `image 4.10.1`, `image_picker 1.2.3`, `path_provider 2.1.6`, `share_plus 13.3.0`, `gal 2.3.3` y `provider 6.1.5+1`.

## Formato de ciphertext

CipherVault utiliza JSON compacto codificado en Base64URL:

```text
{
  "v": 1,
  "alg": "AES-256-GCM",
  "kdf": "ARGON2ID",
  "m": 19456,
  "p": 1,
  "i": 2,
  "h": 32,
  "salt": "...",
  "nonce": "...",
  "ct": "...",
  "tag": "..."
}
```

El objeto completo se serializa a UTF-8 y se codifica en Base64URL sin padding. La contraseña nunca se incluye. El KDF deriva una clave de 256 bits a partir de la contraseña y un salt aleatorio de 16 bytes. El cifrado utiliza AEAD y autentica `CV1|<algoritmo>` como AAD.

## Esteganografía

La carga se inserta en los bits menos significativos de los canales R/G/B de una imagen. El contenedor usa:

- `CVST` magic de 4 bytes.
- versión de 1 byte.
- longitud de payload de 4 bytes.
- SHA-256 del payload de 32 bytes.
- payload UTF-8.

La salida se fuerza a PNG para evitar que una compresión con pérdida destruya los bits ocultos. JPEG/WebP con pérdida no se usan como salida de esteganografía.

## Ejecutar

El entorno de esta entrega no incluye el SDK de Flutter, por lo que no se pudo ejecutar `flutter analyze`/`flutter test` aquí. En una máquina con Flutter instalado:

```bash
flutter create .
flutter pub get
flutter analyze
flutter test
flutter run
```

`flutter create .` genera las carpetas Android/iOS según la versión instalada. Después de generarlas, aplica las configuraciones de permisos descritas abajo.

### iOS

En `ios/Runner/Info.plist` agrega:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>CipherVault necesita acceder a tus imágenes para ocultar o extraer información.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>CipherVault necesita guardar imágenes protegidas en tu fototeca.</string>
```

### Android

`image_picker` y `gal` gestionan las rutas modernas. Para Android API <= 29, `gal` requiere permiso de escritura de almacenamiento. Agrega dentro de `<manifest>`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />
```

## Seguridad

No se imprimen contraseñas ni ciphertext en logs. La contraseña vive solamente durante la operación y no se persiste. La esteganografía solo recibe el ciphertext ya cifrado; nunca recibe la contraseña.