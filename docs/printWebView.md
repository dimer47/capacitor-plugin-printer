# printWebView()

Print the current WebView content. This captures the rendered state of your app's WebView and sends it to the printer.

## Signature

```typescript
printWebView(options?: PrintWebViewOptions): Promise<PrintResult>
```

## Parameters

### PrintWebViewOptions

Same as `BasePrintOptions` — all common print options without any content field.

| Property | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `name` | `string` | — | Job name |
| `orientation` | `'portrait' \| 'landscape'` | `'portrait'` | Print orientation |
| `monochrome` | `boolean` | `false` | Black & white |
| `duplex` | `'none' \| 'long' \| 'short'` | `'none'` | Double-sided printing |
| `margin` | `boolean \| MarginOptions` | — | Margins |
| `maxWidth` | `string \| number` | — | Max content width (iOS) |
| `maxHeight` | `string \| number` | — | Max content height (iOS) |
| `header` | `HeaderFooterOptions` | — | iOS only |
| `footer` | `HeaderFooterOptions` | — | iOS only |
| `paper` | `PaperOptions` | — | Paper format (iOS, Android) |
| `printer` | `string` | — | iOS: printer URL for direct print |
| `ui` | `UIOptions` | — | iPad popover settings |

All parameters are optional. Calling `printWebView()` with no arguments uses default settings.

## Return Value

```typescript
interface PrintResult {
  success: boolean;
}
```

## Platform Behavior

### iOS
1. Gets a `viewPrintFormatter()` from the bridge's WKWebView.
2. If headers/footers are configured, wraps the formatter in a custom `UIPrintPageRenderer`.
3. Presents the native print dialog.

### Android
1. Gets the bridge's `WebView` reference.
2. Creates a `PrintDocumentAdapter` from the WebView using `createPrintDocumentAdapter()`.
3. Presents the system print dialog.

### Web
1. Calls `window.print()` on the current page.
2. The browser's native print dialog appears.
3. Always returns `{ success: true }`.

## Examples

### Simple WebView print

```typescript
import { Printer } from 'capacitor-plugin-printer';

await Printer.printWebView();
```

### With options

```typescript
await Printer.printWebView({
  name: 'App Screenshot',
  orientation: 'landscape',
  paper: { name: 'A4' },
});
```

### With header/footer (iOS)

```typescript
await Printer.printWebView({
  header: {
    height: '2cm',
    label: {
      text: 'My Application',
      font: { bold: true, align: 'center' },
    },
  },
  footer: {
    height: '1cm',
    label: {
      text: 'Page %ld',
      showPageIndex: true,
      font: { size: 9, align: 'center' },
    },
  },
});
```

## Errors

| Error | Cause |
|:------|:------|
| `"WebView not available"` | Android: bridge WebView not accessible |
| `"Print failed: ..."` | Android: exception during print |
