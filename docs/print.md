# print()

Print content with automatic type detection. The plugin inspects the `content` string and routes it to the appropriate native print handler.

## Signature

```typescript
print(options?: PrintOptions): Promise<PrintResult>
```

## Parameters

### PrintOptions

All fields are optional. If `content` is omitted, the current WebView is printed (same as `printWebView()`).

| Property | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `content` | `string` | — | Content to print. See [Content Detection](#content-detection) below |
| `name` | `string` | — | Job name / document title |
| `orientation` | `'portrait' \| 'landscape'` | `'portrait'` | Print orientation |
| `monochrome` | `boolean` | `false` | Black & white |
| `photo` | `boolean` | `false` | Photography media type (iOS) |
| `copies` | `number` | `1` | Number of copies (iOS) |
| `pageCount` | `number` | — | Max pages to print (iOS, Android) |
| `duplex` | `'none' \| 'long' \| 'short'` | `'none'` | Double-sided printing |
| `margin` | `boolean \| MarginOptions` | — | Margin settings |
| `font` | `FontOptions` | — | Font for plain text (iOS) |
| `maxWidth` | `string \| number` | — | Max content width (iOS) |
| `maxHeight` | `string \| number` | — | Max content height (iOS) |
| `header` | `HeaderFooterOptions` | — | Header config (iOS) |
| `footer` | `HeaderFooterOptions` | — | Footer config (iOS) |
| `paper` | `PaperOptions` | — | Paper format (iOS, Android) |
| `printer` | `string` | — | Printer URL for direct print (iOS) |
| `ui` | `UIOptions` | — | Print dialog UI options (iOS/iPad) |
| `autoFit` | `boolean` | `true` | Auto-scale images (Android) |
| `javascript` | `boolean` | `false` | Enable JS in WebView (Android) |

See [Options](./options.md) for detailed type definitions.

## Return Value

```typescript
interface PrintResult {
  success: boolean;
}
```

- `success: true` — The print job was submitted successfully (or the user confirmed printing).
- `success: false` — The user cancelled the print dialog.

## Content Detection

The plugin inspects the `content` string and determines its type:

| Content | Detection Rule | Handled As |
|:--------|:---------------|:-----------|
| `undefined` / `null` / empty | No content | WebView print formatter |
| Starts with `<` | HTML markup | `UIMarkupTextPrintFormatter` (iOS) / WebView HTML load (Android) |
| Starts with `file:///`, `file://`, `res:`, `base64:` | URI scheme detected | File / resource / base64 data |
| Any other string | Plain text | `UISimpleTextPrintFormatter` (iOS) / WebView HTML wrapping (Android) |

## Platform Behavior

### iOS
- Uses `UIPrintInteractionController` to present the native print dialog.
- If `printer` is set, prints directly without dialog.
- Supports headers, footers, fonts, margins, and custom paper selection.

### Android
- Opens the system Print dialog via Android Print Framework.
- HTML and plain text are rendered through a temporary WebView.
- Images use `PrintHelper` from `androidx.print`.
- PDFs are streamed through a custom `PrintDocumentAdapter`.

### Web
- If `content` is provided, opens a new browser window, writes the content, calls `window.print()`, and closes it.
- If `content` is omitted, calls `window.print()` on the current page.
- Always returns `{ success: true }`.
- Only HTML/text and WebView printing are available.

## Examples

### Print HTML

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

await Printer.print({
  content: '<h1>Hello World</h1><p>This is a test.</p>',
});
```

### Print plain text

```typescript
await Printer.print({
  content: 'Hello\nWorld!',
  font: { size: 18, bold: true },
});
```

### Print a file

```typescript
await Printer.print({
  content: 'file:///path/to/document.pdf',
});
```

### Print base64-encoded data

```typescript
await Printer.print({
  content: 'base64://JVBERi0xLjQK...',
});
```

### Print an app resource

```typescript
await Printer.print({
  content: 'res://logo.png',
});
```

### Print the current WebView

```typescript
await Printer.print(); // no content = prints WebView
```

### Print with full options (iOS)

```typescript
await Printer.print({
  content: '<h1>Invoice</h1><p>$42.00</p>',
  name: 'Invoice-001',
  orientation: 'portrait',
  duplex: 'long',
  copies: 2,
  paper: { name: 'A4' },
  margin: { top: '1cm', left: '1cm', right: '1cm', bottom: '1cm' },
  header: {
    height: '2cm',
    label: {
      text: 'ACME Corp',
      font: { bold: true, size: 14, align: 'center' },
    },
  },
  footer: {
    height: '1cm',
    label: {
      text: 'Page %ld',
      showPageIndex: true,
      font: { size: 10, align: 'center' },
    },
  },
});
```

### Direct print to a specific printer (iOS)

```typescript
await Printer.print({
  content: '<p>Receipt</p>',
  printer: 'ipp://printer.local.:631/ipp/print',
});
```

## Errors

| Error | Cause |
|:------|:------|
| `"Activity not available"` | Android: the host Activity is not ready |
| `"WebView not available"` | Android: the bridge WebView could not be accessed |
| `"Print failed: ..."` | Android: an exception occurred during printing |
