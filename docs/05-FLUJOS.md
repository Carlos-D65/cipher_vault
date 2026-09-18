# Flujos de CipherVault

## 1. Flujo de protección estándar

```text
Usuario
  |
  v
Protect
  |
  +--> mensaje
  |
  +--> contraseña
  |
  +--> algoritmo
          |
          v
     EncryptText
          |
          v
 EncryptionRepository
          |
          v
 EncryptionService
          |
          +--> AES-256-GCM
          |
          +--> ChaCha20-Poly1305
          |
          v
      EncryptedData
          |
          v
   Payload Codec CVLT1
          |
          v
       CVLT1
```

## 2. Flujo de protección avanzada

```text
Usuario
  |
  v
Protect
  |
  v
Advanced
  |
  +--> AES-256-GCM + ML-KEM
  |
  +--> ChaCha20-Poly1305 + ML-KEM
          |
          v
  AdvancedEncryptionService
          |
          v
     ML-KEM-768
          |
          v
    Shared Secret
          |
          +------ contraseña
          |          |
          |          v
          |       Argon2id
          |          |
          +----------+
                     |
                     v
                    HKDF
                     |
                     v
               Hybrid Key
                     |
                     v
                 AEAD
                     |
                     v
                   CVLT2
```

## 3. Flujo Protect → Hide

```text
Protect
  |
  v
Payload CVLT1/CVLT2
  |
  v
Hide
  |
  v
Seleccionar PNG
  |
  v
SteganographyService
  |
  v
CVST + metadata + payload + CRC32
  |
  v
PNG protegido
```

## 4. Flujo Decrypt desde payload

```text
Payload
   |
   v
Decrypt
   |
   v
Detectar prefijo
   |
   +--> CVLT1 --> CipherVaultPayloadCodec
   |
   +--> CVLT2 --> AdvancedCipherVaultPayloadCodec
                       |
                       v
                    Descifrado
                       |
                       v
                 Texto original
```

## 5. Flujo Decrypt desde imagen

```text
Imagen PNG
    |
    v
Seleccionar imagen
    |
    v
Extract
    |
    v
SteganographyService
    |
    v
Validar CVST / longitud / CRC
    |
    v
Payload
    |
    v
Detectar CVLT1 o CVLT2
    |
    v
Descifrar
    |
    v
Texto original
```

## 6. Flujo CVLT1

```text
Password
   |
   v
Argon2id
   |
   v
32-byte key
   |
   v
AES-GCM / ChaCha20-Poly1305
   |
   v
Authentication Tag
   |
   v
Plaintext
```

## 7. Flujo CVLT2

```text
Password
   |
   v
Argon2id
   |
   v
Password Secret
             \
              +--> HKDF --> Hybrid Key --> AEAD --> Plaintext
             /
ML-KEM ------+
   |
   v
Shared Secret
```

## 8. Flujo de guardado

```text
Resultado
   |
   v
Controller
   |
   v
FileStorageService
   |
   v
Selector de archivos / almacenamiento
   |
   v
Archivo
```

## 9. Flujo de compartir

```text
Resultado
   |
   v
Controller
   |
   v
ShareService
   |
   v
share_plus
   |
   v
Hoja de compartir del sistema
```

## 10. Flujo de error

```text
Operación
   |
   v
Excepción / fallo
   |
   v
Controller
   |
   v
Provider
   |
   v
Estado error
   |
   v
Mensaje comprensible para el usuario
```

## 11. Estados generales

Las operaciones de Protect y Decrypt utilizan estados observables para representar el progreso.

Ejemplo:

```text
idle
  |
  v
encrypting / decrypting
  |
  +----> error
  |
  v
success
  |
  +----> saving
  |
  +----> sharing
```

Los estados de selección y extracción de imagen se manejan específicamente dentro de Decrypt.
