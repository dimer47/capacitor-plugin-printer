# printBase64()

Print base64-encoded data with an explicit MIME type. Use this when you have in-memory binary data (PDF, image, etc.) encoded as a base64 string.

## Signature

```typescript
printBase64(options: PrintBase64Options): Promise<PrintResult>
```

## Parameters

### PrintBase64Options

Extends `BasePrintOptions`.

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `data` | `string` | **Yes** | Base64-encoded data (without `base64:` prefix) |
| `mimeType` | `string` | **Yes** | MIME type of the data |
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

## Supported MIME Types

| MIME Type | Content |
|:----------|:--------|
| `application/pdf` | PDF document |
| `image/png` | PNG image |
| `image/jpeg` | JPEG image |
| `image/gif` | GIF image |
| `image/bmp` | BMP image |
| `image/heif` | HEIF image |
| `image/x-icon` | ICO image |

## Platform Behavior

### iOS
1. The `data` string is prefixed with `base64:` internally.
2. `PrinterItem` decodes the base64 string into `NSData`.
3. The data is set as `printingItem` on the print controller.
4. The native print dialog is presented.

### Android
1. The `data` string is prefixed with `base64:` internally.
2. The `mimeType` is used to determine the content type (PDF, image, etc.).
3. For PDFs: the base64 data is decoded and streamed through `PrintAdapter`.
4. For images: the data is decoded into a `Bitmap` and printed via `PrintHelper`.

### Web
**Not available.** Throws an `unimplemented` error.

## Examples

### Print a base64 PDF

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

// Assuming you have a base64-encoded PDF string
const pdfBase64 = 'JVBERi0xLjQKMSAwIG9iago8PC...';

await Printer.printBase64({
  data: pdfBase64,
  mimeType: 'application/pdf',
  name: 'Generated Report',
});
```

### Print a base64 image

```typescript
const imageBase64 = 'iVBORw0KGgoAAAANSUhEUg...';

await Printer.printBase64({
  data: imageBase64,
  mimeType: 'image/png',
  autoFit: true,
});
```

### From a fetch response

```typescript
const response = await fetch('https://api.example.com/invoice/123/pdf');
const blob = await response.blob();

const base64 = await new Promise<string>((resolve) => {
  const reader = new FileReader();
  reader.onloadend = () => {
    const result = reader.result as string;
    resolve(result.split(',')[1]); // Remove "data:...;base64," prefix
  };
  reader.readAsDataURL(blob);
});

await Printer.printBase64({
  data: base64,
  mimeType: 'application/pdf',
});
```

## Errors

| Error | Cause |
|:------|:------|
| `"The 'data' parameter is required"` | `data` was not provided or is `null` |
| `"The 'mimeType' parameter is required"` | `mimeType` was not provided or is `null` |
| `"WebView not available"` | Android: bridge WebView not accessible |
| `"Print failed: ..."` | Android: exception during print |
| `"printBase64() is not available on web."` | Called on the web platform |
