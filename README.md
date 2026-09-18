# CipherVault

CipherVault es una aplicación móvil desarrollada con Flutter y Dart para proteger información mediante cifrado y para ocultar payloads cifrados dentro de imágenes PNG mediante esteganografía.

La aplicación separa el cifrado estándar del cifrado avanzado y utiliza formatos de payload versionados para que el sistema pueda identificar cómo debe procesar la información.

## Características implementadas

- Cifrado estándar con AES-256-GCM.
- Cifrado estándar con ChaCha20-Poly1305.
- Derivación de claves mediante Argon2id.
- Salt y nonce generados aleatoriamente.
- Authentication tag mediante los algoritmos AEAD.
- AAD para proteger metadatos asociados al payload.
- Formato de payload estándar `CVLT1`.
- Cifrado avanzado con AES-256-GCM + ML-KEM.
- Cifrado avanzado con ChaCha20-Poly1305 + ML-KEM.
- Derivación híbrida mediante contraseña, secreto compartido de ML-KEM y HKDF.
- Formato de payload avanzado `CVLT2`.
- Almacenamiento seguro de la identidad ML-KEM del dispositivo.
- Esteganografía LSB sobre imágenes PNG.
- Extracción automática del payload desde una imagen protegida.
- Detección de payload estándar o avanzado al descifrar.
- Copiar, guardar y compartir payloads y resultados desde la aplicación.

## Tecnologías principales

- Flutter
- Dart
- `cryptography`
- `cryptography_flutter`
- `provider`
- `path_provider`
- `share_plus`
- `image`
- `file_picker`
- `mlkem_native`
- `flutter_secure_storage`

## Flujo general

```text
Mensaje
   |
   v
Protect
   |
   +--> Cifrado estándar --> CVLT1
   |
   +--> Cifrado avanzado --> CVLT2
                              |
                              v
                           Hide
                              |
                              v
                     Imagen PNG protegida
                              |
                              v
                           Decrypt
                              |
                              v
                       Mensaje original
```

## Cifrado estándar

El flujo estándar utiliza una contraseña como entrada para Argon2id. La clave derivada se utiliza con AES-256-GCM o ChaCha20-Poly1305.

El resultado se serializa como un payload `CVLT1`.

## Cifrado avanzado

El flujo avanzado combina la derivación basada en contraseña con un secreto compartido obtenido mediante ML-KEM. HKDF produce la clave utilizada por el cifrado AEAD.

El resultado se serializa como `CVLT2`.

La implementación actual utiliza una identidad ML-KEM almacenada de forma segura en el dispositivo. Por ello, el descifrado avanzado depende de la identidad ML-KEM disponible en el dispositivo correspondiente.

## Esteganografía

CipherVault puede ocultar un payload cifrado dentro de una imagen PNG utilizando bits menos significativos de los canales RGB.

El formato interno de esteganografía incluye:

- marcador de CipherVault;
- versión;
- longitud del payload;
- payload;
- CRC32.

Para este mecanismo se utilizan imágenes PNG, ya que el procesamiento de formatos con compresión con pérdida puede alterar los bits utilizados por la esteganografía.

## Estructura

La aplicación utiliza una estructura modular separando presentación, casos de uso, seguridad, almacenamiento, intercambio de archivos y funcionalidades.

La documentación técnica se encuentra en `docs/`.

## Ejecución

Con Flutter instalado:

```bash
flutter pub get
flutter run
```

## Compilación Android

Para generar un APK de release:

```bash
flutter build apk --release
```

## Documentación

- [`docs/01-CONTRATO.md`](docs/01-CONTRATO.md) — reglas y criterios que deben respetarse durante el desarrollo.
- [`docs/02-ARQUITECTURA.md`](docs/02-ARQUITECTURA.md) — organización técnica y responsabilidades.
- [`docs/03-FUNCIONALIDADES.md`](docs/03-FUNCIONALIDADES.md) — funcionalidades actualmente implementadas.
- [`docs/04-SEGURIDAD.md`](docs/04-SEGURIDAD.md) — mecanismos de seguridad y formatos criptográficos.
- [`docs/05-FLUJOS.md`](docs/05-FLUJOS.md) — recorridos principales de la aplicación.
- [`docs/06-ESTRUCTURA.md`](docs/06-ESTRUCTURA.md) — estructura del código fuente.

## Nota de alcance

Esta documentación describe el estado implementado de CipherVault. No se presentan como disponibles funciones que no formen parte de la implementación actual.
