# URI Schemes

Reference for all URI schemes supported by the plugin to reference files, resources, and inline data.

## Overview

| Scheme | Supported On | Description |
|:-------|:-------------|:------------|
| `file:///` | iOS, Android | Absolute filesystem path |
| `file://` | iOS, Android | App bundle assets |
| `res:` | iOS, Android | Named app resources |
| `base64:` | iOS, Android | Inline base64-encoded data |

## file:/// — Absolute File Path

References a file using its full filesystem path.

```
file:///var/mobile/Containers/Data/Application/.../Documents/report.pdf
file:///storage/emulated/0/Download/photo.jpg
```

### iOS
Resolved directly as an `NSURL` file path.

### Android
Opened via `FileInputStream` after stripping the `file:///` prefix.

### Examples

```typescript
await Printer.printPdf({
  path: 'file:///var/mobile/.../document.pdf',
});

await Printer.printFile({
  path: 'file:///storage/emulated/0/Download/image.png',
});
```

## file:// — App Bundle Assets

References a file within the app's asset bundle (without the triple slash).

```
file://www/assets/logo.png
file://public/report.pdf
```

### iOS
Resolved by looking up the filename in the app's main `Bundle`. The path after `file://` is used to find the resource name.

### Android
Opened via `AssetManager` after stripping the `file://` prefix. The remaining path is relative to the `assets/` directory.

### Examples

```typescript
await Printer.printFile({
  path: 'file://public/images/logo.png',
});

await Printer.printPdf({
  path: 'file://www/templates/invoice.pdf',
});
```

## res: — App Resources

References a named resource from the app's resource system.

```
res://icon
res://logo
res://splash
```

### iOS
Resolved by looking up the resource name in the app's main `Bundle` using `Bundle.main.url(forResource:...)`.

### Android
Resolved by looking up the resource ID in the app's `R.drawable` resources and opening the corresponding input stream.

### Examples

```typescript
await Printer.printFile({
  path: 'res://company_logo',
  mimeType: 'image/png',
});

// Check if a resource can be printed
const { available } = await Printer.canPrintItem({
  uri: 'res://invoice_template',
});
```

## base64: — Inline Base64 Data

Inline binary data encoded as a base64 string.

```
base64://JVBERi0xLjQK...
base64:JVBERi0xLjQK...
```

Both `base64://` and `base64:` prefixes are accepted.

### iOS
The base64 string is decoded to `NSData` via `Data(base64Encoded:)`.

### Android
The base64 string is decoded via `Base64.decode()` and wrapped in a `ByteArrayInputStream`.

### With print()

When using the generic `print()` method, pass the full URI:

```typescript
await Printer.print({
  content: 'base64://JVBERi0xLjQK...',
});
```

### With printBase64()

When using `printBase64()`, pass the raw base64 string **without** the prefix:

```typescript
await Printer.printBase64({
  data: 'JVBERi0xLjQK...', // No "base64:" prefix
  mimeType: 'application/pdf',
});
```

The method adds the `base64:` prefix internally.

## Content Type Detection

When using `print()` or `printFile()`, the plugin auto-detects the content type:

### By URI scheme

| URI | Detected As |
|:----|:------------|
| `base64:...` | Guessed from stream content (Android) or raw data (iOS) |
| `file:///...pdf` | Guessed from file extension |
| `file://...png` | Guessed from file extension |
| `res://...` | Guessed from resource data |

### By content inspection

| Content | Detected As |
|:--------|:------------|
| Starts with `<` | HTML |
| Has a URI scheme (`xxx://...`) | File/resource reference |
| Anything else | Plain text |

### Supported MIME types for detection

| MIME Type | Content Type |
|:----------|:-------------|
| `application/pdf` | PDF |
| `image/png` | Image |
| `image/jpeg`, `image/jpeg2000`, `image/jp2` | Image |
| `image/gif` | Image |
| `image/bmp` | Image |
| `image/heif` | Image |
| `image/x-icon`, `image/vnd.microsoft.icon` | Image |
| `text/html` | HTML |
| `text/plain` | Plain text |
