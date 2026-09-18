# Arquitectura de CipherVault

## 1. Objetivo

CipherVault está organizado para mantener separadas la interfaz, la lógica de aplicación, la seguridad y las operaciones de plataforma.

La separación permite modificar una parte sin convertir los widgets o controllers en archivos monolíticos.

## 2. Capas principales

```text
UI
 |
 v
Providers / Controllers
 |
 v
Use Cases
 |
 v
Repositories
 |
 +--> Security Services
 |
 +--> Storage Services
 |
 +--> Sharing Services
 |
 v
Platform / Packages
```

## 3. `app/`

Contiene la configuración de arranque y navegación de la aplicación.

```text
app/
├── app.dart
├── router/
│   └── app_router.dart
└── bootstrap/
    └── bootstrap.dart
```

`bootstrap.dart` inicializa Flutter y arranca la aplicación.

`app.dart` configura `MaterialApp`, tema y ruta inicial.

## 4. `core/`

Contiene componentes reutilizables que no pertenecen exclusivamente a una pantalla.

```text
core/
├── errors/
├── extensions/
├── platform/
├── results/
├── security/
├── sharing/
├── storage/
├── theme/
└── utils/
```

### `errors`

Define excepciones y fallos de aplicación.

### `platform`

Agrupa servicios específicos de plataforma, como el portapapeles.

### `results`

Contiene el tipo de resultado utilizado para representar éxito o fallo.

### `security`

Contiene cifrado, derivación de claves, formatos de payload, ML-KEM y esteganografía.

### `sharing`

Abstrae la funcionalidad de compartir.

### `storage`

Abstrae el almacenamiento de archivos.

### `theme`

Contiene el tema visual de la aplicación.

### `utils`

Contiene utilidades compartidas.

## 5. Seguridad

La seguridad se encuentra organizada por responsabilidad.

```text
security/
├── aes/
├── chacha/
├── codec/
├── kdf/
├── models/
├── pqc/
├── random/
├── services/
└── steganography/
```

La carpeta `advanced/` contiene específicamente los componentes del formato `CVLT2`.

## 6. Features

Las funcionalidades se organizan por dominio de aplicación:

```text
features/
├── home/
├── encryption/
├── decryption/
└── steganography/
```

Cada feature puede contener presentación, dominio y datos según las necesidades de la funcionalidad.

## 7. Protect

Protect recibe la entrada del usuario y delega el cifrado al caso de uso correspondiente.

El controller coordina la operación y el provider mantiene el estado de la interfaz.

En el modo estándar se produce `CVLT1`.

En el modo avanzado se selecciona el servicio AES-ML-KEM o ChaCha20-ML-KEM y se produce `CVLT2`.

## 8. Decrypt

Decrypt recibe un payload directamente o lo obtiene desde una imagen mediante el servicio de esteganografía.

El controller detecta el prefijo:

```text
CVLT1.
CVLT2.
```

y utiliza el sistema de descifrado correspondiente.

## 9. Hide

Hide utiliza el servicio de esteganografía para insertar un payload cifrado en una imagen PNG.

El resultado es una nueva imagen PNG que conserva el payload en los bits LSB utilizados por CipherVault.

## 10. Servicios de almacenamiento y compartir

El almacenamiento se abstrae mediante `FileStorageService`.

La implementación local utiliza el sistema de archivos de la aplicación y también proporciona operaciones de guardado mediante el selector de archivos del sistema.

El intercambio se abstrae mediante `ShareService` y su implementación basada en `share_plus`.

## 11. Inyección de dependencias

Las dependencias de las funcionalidades se construyen mediante clases de dependencias específicas.

Esto evita que cada widget tenga que crear manualmente todos los servicios que necesita.

## 12. Principio de mantenimiento

Los widgets deben concentrarse en la presentación.

Los controllers coordinan acciones.

Los providers mantienen estados observables.

Los casos de uso representan operaciones de aplicación.

Los repositorios y servicios contienen la lógica correspondiente a su dominio.

La lógica criptográfica no debe terminar dentro de widgets.
