# Ubuntu 24.04 Source Engine Docker Image

A modern Source Engine Docker image based on Ubuntu 24.04 with GLIBC 2.39, designed for SourceMod extensions that require GLIBC 2.38+.

## Why This Image?

Modern SourceMod extensions require GLIBC 2.38 or higher. The standard Pterodactyl Source Engine images use older base systems with insufficient GLIBC versions.

| Image      | GLIBC Version | Modern Extensions |
|------------|---------------|-------------------|
| Original   | 2.36          | ❌ Too old        |
| This Image | 2.39          | ✅ Full support   |

## Usage

### Pull the Image

```bash
docker pull sak0a/pterodactyl-source-ubuntu24:latest
```

### Use with Pterodactyl

1. Go to Pterodactyl admin panel
2. Navigate to `Nests` → `Source Engine` → Your game egg
3. Change "Docker Image" to: `sak0a/pterodactyl-source-ubuntu24:latest`
4. Save and restart servers

### Verify GLIBC Version

Access your container and check the version:
```bash
docker exec -it <container-id> bash
ldd --version
```

Expected output:
```
ldd (Ubuntu GLIBC 2.39-0ubuntu8.2) 2.39
```

## Features

- **GLIBC 2.39** - Supports modern SourceMod extensions
- **Ubuntu 24.04** - Modern, stable base
- **32-bit Support** - Complete i386 library stack
- **Minimal Size** - Only essential packages
- **Drop-in Replacement** - Compatible with existing Pterodactyl setups

## Credits

Based on Pterodactyl yolks source games image by Matthew Penner.
