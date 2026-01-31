# printFile()

Print a file from a path or URI. The MIME type is detected automatically from the file extension, or can be specified explicitly.

## Signature

```typescript
printFile(options: PrintFileOptions): Promise<PrintResult>
```

## Parameters

### PrintFileOptions

Extends `BasePrintOptions`.

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `path` | `string` | **Yes** | File path or URI |
| `mimeType` | `string` | No | MIME type (auto-detected if omitted) |
| `name` | `string` | No | Job name |
| `orientation` | `'portrait' \| 'landscape'` | No | Default: `'portrait'` |
| `monochrome` | `boolean` | No | Default: `false` |
| `duplex` | `'none' \| 'long' \| 'short'` | No | Default: `'none'` |
| `pageCount` | `number` | No | Max pages (iOS, Android) |
| `paper` | `PaperOptions` | No | Paper format (iOS, Android) |
| `printer` | `string` | No | iOS: printer URL for direct print |
| `ui` | `UIOptions` | No | iPad popover settings |
| `autoFit` | `boolean` | No | Android images: auto-scale. Default: `true` |

## Return Value

```typescript
interface PrintResult {
  success: boolean;
}
```

## Supported File Types

| Type | Extensions | MIME Types |
|:-----|:-----------|:-----------|
| PDF | `.pdf` | `application/pdf` |
| PNG | `.png` | `image/png` |
| JPEG | `.jpg`, `.jpeg` | `image/jpeg` |
| GIF | `.gif` | `image/gif` |
| BMP | `.bmp` | `image/bmp` |
| HEIF | `.heif`, `.heic` | `image/heif` |
| ICO | `.ico` | `image/x-icon` |

If the file extension is not recognized and no `mimeType` is provided, the content type detection falls back to `UNSUPPORTED` on Android.

## Supported Path Formats

| Format | Example | Description |
|:-------|:--------|:------------|
| Absolute path | `file:///var/mobile/.../photo.png` | Full filesystem path |
| App assets | `file://www/images/logo.png` | File from app bundle/assets |
| App resource | `res://icon` | Named resource |

See [URI Schemes](./uri-schemes.md) for details.

## Platform Behavior

### iOS
1. The path is resolved via `PrinterItem` to either an `NSURL` or `NSData`.
2. If `mimeType` is provided it is accepted but iOS relies on the data/URL for type detection.
3. The resolved item is set as `printingItem` on the print controller.

### Android
1. The file is opened as a `BufferedInputStream`.
2. The `mimeType` (explicit or auto-detected) determines the print path:
   - **PDF**: streamed through `PrintAdapter`.
   - **Image**: decoded to `Bitmap` and printed via `PrintHelper`.
   - **Other**: rendered in a temporary WebView (if applicable).
3. The system print dialog is shown.

### Web
**Not available.** Throws an `unimplemented` error.

## Examples

### Print an image

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

await Printer.printFile({
  path: 'file:///var/mobile/Containers/Data/Application/.../photo.jpg',
});
```

### Print with explicit MIME type

```typescript
await Printer.printFile({
  path: 'file:///path/to/document',
  mimeType: 'application/pdf',
  name: 'My Document',
});
```

### Print an app asset

```typescript
await Printer.printFile({
  path: 'file://www/assets/report.pdf',
  orientation: 'landscape',
});
```

### Print a resource

```typescript
await Printer.printFile({
  path: 'res://receipt_template',
  mimeType: 'image/png',
});
```

## Errors

| Error | Cause |
|:------|:------|
| `"The 'path' parameter is required"` | `path` was not provided or is `null` |
| `"WebView not available"` | Android: bridge WebView not accessible |
| `"Print failed: ..."` | Android: exception during print (e.g. file not found, unsupported type) |
| `"printFile() is not available on web."` | Called on the web platform |
