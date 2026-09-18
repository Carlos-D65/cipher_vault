# Seguridad de CipherVault

## 1. Modelo general

CipherVault utiliza dos formatos de protección:

```text
CVLT1 = cifrado estándar
CVLT2 = cifrado avanzado híbrido
```

Los dos formatos son versionados y contienen la información necesaria para interpretar sus parámetros criptográficos.

## 2. CVLT1

El flujo estándar es:

```text
Contraseña
    |
    v
Argon2id
    |
    v
Clave de 32 bytes
    |
    +-------------------+
    |                   |
    v                   v
AES-256-GCM       ChaCha20-Poly1305
    |                   |
    +---------+---------+
              |
              v
          SecretBox
              |
              v
            CVLT1
```

## 3. Argon2id

La implementación utiliza Argon2id para transformar la contraseña en material de clave.

Los parámetros actuales incluyen:

- memoria: 19456 KiB;
- iteraciones: 2;
- paralelismo: 1;
- longitud de clave: 32 bytes.

El salt utilizado para la derivación es aleatorio y se almacena dentro del payload.

## 4. AES-256-GCM

La implementación utiliza AES-GCM con clave de 256 bits.

El nonce utilizado por el flujo actual tiene 12 bytes.

El resultado autenticado se representa mediante:

- ciphertext;
- authentication tag.

## 5. ChaCha20-Poly1305

La implementación utiliza ChaCha20-Poly1305 como alternativa independiente a AES-GCM.

El nonce utilizado por el flujo actual tiene 12 bytes y el resultado incluye el tag de autenticación.

## 6. AAD

CipherVault construye AAD a partir de metadatos del payload.

Entre estos datos se encuentran:

- versión;
- algoritmo;
- KDF;
- parámetros del KDF.

Esto vincula criptográficamente esos metadatos con el contenido protegido.

## 7. CVLT1

El payload estándar se representa como:

```text
CVLT1.<base64url-json>
```

El JSON contiene:

- versión;
- algoritmo;
- KDF;
- parámetros KDF;
- salt;
- nonce;
- ciphertext;
- authentication tag.

## 8. Cifrado avanzado

El flujo avanzado utiliza ML-KEM para obtener un secreto compartido y lo combina con material derivado de la contraseña.

```text
Contraseña
    |
    v
Argon2id
    |
    v
Password Secret
    |
    +-----------------------+
                            |
ML-KEM Encapsulation        |
    |                       |
    v                       |
Shared Secret --------------+
            |
            v
           HKDF
            |
            v
      Clave de 32 bytes
            |
      +-----+------+
      |            |
      v            v
 AES-256-GCM   ChaCha20-Poly1305
      |            |
      +-----+------+
            |
            v
           CVLT2
```

## 9. ML-KEM

La implementación actual utiliza ML-KEM-768.

ML-KEM funciona como mecanismo de encapsulación de claves. El mensaje no se cifra directamente con ML-KEM.

El secreto compartido de ML-KEM se incorpora al proceso de derivación híbrida.

## 10. Derivación híbrida

La implementación utiliza:

- secreto derivado de la contraseña;
- secreto compartido de ML-KEM;
- HKDF;
- HMAC-SHA-256;
- una longitud final de 32 bytes.

El contexto utilizado por el servicio híbrido es:

```text
CipherVault-CVLT2-Hybrid-AEAD-v1
```

## 11. CVLT2

El payload avanzado se representa como:

```text
CVLT2.<base64url-json>
```

Incluye:

- versión;
- algoritmo simétrico;
- algoritmo ML-KEM;
- salt;
- ciphertext de encapsulación KEM;
- nonce;
- ciphertext;
- authentication tag.

## 12. Almacenamiento de claves

La identidad ML-KEM del dispositivo se almacena mediante `flutter_secure_storage`.

La identidad contiene material público y privado asociado al algoritmo utilizado.

La clave privada no forma parte del payload `CVLT2`.

## 13. Implicación del diseño CVLT2

El payload avanzado incluye el ciphertext de encapsulación, pero la recuperación del secreto compartido requiere la clave privada correspondiente.

La implementación actual mantiene esa identidad asociada al dispositivo.

Por ello, el descifrado avanzado depende de disponer de la identidad ML-KEM correspondiente en el dispositivo.

## 14. Esteganografía

CipherVault utiliza esteganografía LSB sobre imágenes PNG.

El payload se convierte en bytes y se inserta en bits de los canales RGB.

La estructura contiene:

```text
CVST
VERSION
PAYLOAD LENGTH
PAYLOAD
CRC32
```

## 15. CRC32

El CRC32 se utiliza como verificación de integridad del bloque de esteganografía.

No sustituye la autenticación criptográfica del payload.

La autenticación criptográfica continúa siendo responsabilidad de AES-GCM o ChaCha20-Poly1305.

## 16. Formatos de imagen

La implementación está orientada a PNG.

Los formatos con compresión con pérdida pueden modificar los bits utilizados por el mecanismo LSB y por ello no forman parte del flujo de esteganografía implementado.

## 17. Manejo de contraseñas

La contraseña se utiliza como entrada para la derivación de claves.

No debe utilizarse directamente como clave AEAD.

No debe escribirse en logs.

No debe incluirse en los payloads.

## 18. Errores de autenticación

Cuando una operación AEAD no puede autenticar los datos, el flujo de aplicación presenta un mensaje general indicando que la contraseña puede ser incorrecta o que los datos pudieron ser modificados.

Esto evita mostrar detalles internos innecesarios.

## 19. Resumen

La protección estándar utiliza:

```text
Argon2id + AES-256-GCM
```

o:

```text
Argon2id + ChaCha20-Poly1305
```

La protección avanzada utiliza:

```text
Argon2id
+
ML-KEM
+
HKDF
+
AES-256-GCM
```

o:

```text
Argon2id
+
ML-KEM
+
HKDF
+
ChaCha20-Poly1305
```
