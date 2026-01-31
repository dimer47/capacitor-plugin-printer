# printPdf()

Print a PDF document from a file path or URI.

## Signature

```typescript
printPdf(options: PrintPdfOptions): Promise<PrintResult>
```

## Parameters

### PrintPdfOptions

Extends `BasePrintOptions`.

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `path` | `string` | **Yes** | File path or URI of the PDF |
| `name` | `string` | No | Job name |
| `orientation` | `'portrait' \| 'landscape'` | No | Default: `'portrait'` |
| `monochrome` | `boolean` | No | Default: `false` |
| `duplex` | `'none' \| 'long' \| 'short'` | No | Default: `'none'` |
| `pageCount` | `number` | No | Max pages (iOS, Android) |
| `paper` | `PaperOptions` | No | Paper format (iOS, Android) |
| `printer` | `string` | No | iOS: printer URL for direct print |
| `ui` | `UIOptions` | No | iPad popover settings |

Other `BasePrintOptions` fields are accepted but only relevant properties apply to PDFs.

## Return Value

```typescript
interface PrintResult {
  success: boolean;
}
```

## Supported Path Formats

| Format | Example | Description |
|:-------|:--------|:------------|
| Absolute path | `file:///var/mobile/.../doc.pdf` | Full filesystem path |
| App assets | `file://www/report.pdf` | File from app bundle/assets |
| App resource | `res://report` | Named resource |

See [URI Schemes](./uri-schemes.md) for details.

## Platform Behavior

### iOS
1. The path is resolved to an `NSURL` or `NSData` via `PrinterItem`.
2. The data is set as `printingItem` on `UIPrintInteractionController`.
3. The native print dialog is presented.

### Android
1. The path is opened as a `BufferedInputStream` via `PrintContent.open()`.
2. The stream is passed to a custom `PrintAdapter` (extends `PrintDocumentAdapter`).
3. The adapter copies the PDF data to the print output file descriptor.
4. The system print dialog is shown.

### Web
**Not available.** Throws an `unimplemented` error.

## Examples

### Print a local PDF

```typescript
import { Printer } from 'capacitor-plugin-printer';

await Printer.printPdf({
  path: 'file:///var/mobile/Containers/Data/Application/.../document.pdf',
});
```

### Print a PDF from app assets

```typescript
await Printer.printPdf({
  path: 'file://www/contracts/template.pdf',
});
```

### Print with options

```typescript
await Printer.printPdf({
  path: 'file:///path/to/report.pdf',
  name: 'Annual Report',
  orientation: 'landscape',
  duplex: 'long',
  paper: { name: 'A4' },
});
```

### Check availability before printing

```typescript
const { available } = await Printer.canPrintItem({
  uri: 'file:///path/to/document.pdf',
});

if (available) {
  await Printer.printPdf({ path: 'file:///path/to/document.pdf' });
}
```

## Errors

| Error | Cause |
|:------|:------|
| `"The 'path' parameter is required"` | `path` was not provided or is `null` |
| `"WebView not available"` | Android: bridge WebView not accessible |
| `"Print failed: ..."` | Android: exception during print (e.g. file not found) |
| `"printPdf() is not available on web."` | Called on the web platform |
