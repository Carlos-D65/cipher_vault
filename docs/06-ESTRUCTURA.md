# Estructura del proyecto CipherVault

## 1. Vista general

La aplicación está organizada en módulos para evitar concentrar toda la lógica en un único archivo.

```text
lib/
├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

## 2. `lib/main.dart`

Es el punto de entrada de la aplicación.

Su responsabilidad actual es iniciar el proceso de bootstrap.

## 3. `lib/app/`

```text
app/
├── app.dart
├── router/
│   └── app_router.dart
└── bootstrap/
    └── bootstrap.dart
```

### `app.dart`

Configura la aplicación Flutter, tema y navegación inicial.

### `router/app_router.dart`

Centraliza las rutas de la aplicación.

### `bootstrap/bootstrap.dart`

Realiza la inicialización necesaria antes de ejecutar la aplicación.

## 4. `lib/core/`

```text
core/
├── constants/
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

Excepciones y fallos.

### `platform`

Integraciones de plataforma.

### `results`

Representación de resultados exitosos o fallidos.

### `security`

Todo lo relacionado con protección de datos.

### `sharing`

Compartir contenido.

### `storage`

Guardar archivos.

### `theme`

Tema visual.

### `utils`

Utilidades compartidas.

## 5. Seguridad

La estructura de seguridad actual incluye:

```text
security/
├── advanced/
│   ├── codec/
│   ├── models/
│   └── services/
│
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

## 6. `advanced/`

Contiene el sistema `CVLT2`.

Incluye:

- codec del payload avanzado;
- modelo de datos avanzado;
- servicio AES + ML-KEM;
- servicio ChaCha20 + ML-KEM;
- AAD avanzado.

## 7. `pqc/`

Contiene los componentes relacionados con criptografía post-cuántica:

```text
pqc/
├── models/
├── pqc_dependencies.dart
├── services/
└── storage/
```

Aquí se encuentran los modelos ML-KEM, servicios de encapsulación y recuperación, derivación híbrida y almacenamiento de la identidad.

## 8. `steganography/`

Contiene:

```text
steganography/
├── codec/
├── models/
└── services/
```

Su responsabilidad es ocultar y extraer payloads desde imágenes.

## 9. `sharing/`

```text
sharing/
├── share_plus_service.dart
└── share_service.dart
```

La interfaz `ShareService` permite desacoplar la aplicación de la implementación concreta de compartir.

## 10. `storage/`

```text
storage/
├── file_storage_service.dart
└── local_file_storage_service.dart
```

La interfaz define las operaciones de almacenamiento y la implementación local utiliza las capacidades de almacenamiento del dispositivo y el selector de archivos.

## 11. `features/`

Las funcionalidades de la aplicación se organizan por dominio:

```text
features/
├── home/
├── encryption/
├── decryption/
└── steganography/
```

Dentro de cada feature se separan las responsabilidades de presentación, dominio y datos cuando corresponde.

## 12. Nombres importantes

Entre los componentes principales se encuentran:

- `ProtectController`
- `ProtectProvider`
- `DecryptController`
- `DecryptProvider`
- `EncryptionService`
- `EncryptionServiceFactory`
- `EncryptionRepository`
- `Argon2idKeyDerivationService`
- `CipherVaultPayloadCodec`
- `AdvancedCipherVaultPayloadCodec`
- `AesMlKemEncryptionService`
- `Chacha20MlKemEncryptionService`
- `SteganographyService`
- `FileStorageService`
- `ShareService`

## 13. Principio de organización

La ubicación de una clase debe responder a su responsabilidad.

Por ejemplo:

```text
UI
↓
Controller / Provider
↓
Use Case
↓
Repository
↓
Service
```

La criptografía no debe depender de una pantalla concreta.

El almacenamiento no debe estar implementado directamente dentro de un widget.

El compartir debe permanecer abstraído mediante su servicio.

## 14. Mantenimiento

Cuando se agregue código, debe buscarse primero una ubicación coherente dentro de la arquitectura existente antes de crear nuevos directorios o duplicar servicios.

La documentación debe actualizarse cuando una modificación cambie una responsabilidad, flujo o funcionalidad ya documentada.
