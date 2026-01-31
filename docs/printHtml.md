# printHtml()

Print an HTML string. This is a dedicated method for HTML content with a required `html` parameter, providing stronger type safety than the generic `print()` method.

## Signature

```typescript
printHtml(options: PrintHtmlOptions): Promise<PrintResult>
```

## Parameters

### PrintHtmlOptions

Extends `BasePrintOptions` (all common print options except `content`).

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `html` | `string` | **Yes** | The HTML string to print |
| `name` | `string` | No | Job name |
| `orientation` | `'portrait' \| 'landscape'` | No | Default: `'portrait'` |
| `monochrome` | `boolean` | No | Default: `false` |
| `photo` | `boolean` | No | iOS only. Default: `false` |
| `copies` | `number` | No | iOS only. Default: `1` |
| `pageCount` | `number` | No | Max pages (iOS, Android) |
| `duplex` | `'none' \| 'long' \| 'short'` | No | Default: `'none'` |
| `margin` | `boolean \| MarginOptions` | No | Margins |
| `font` | `FontOptions` | No | Not applied to HTML (used for plain text) |
| `maxWidth` | `string \| number` | No | iOS only |
| `maxHeight` | `string \| number` | No | iOS only |
| `header` | `HeaderFooterOptions` | No | iOS only |
| `footer` | `HeaderFooterOptions` | No | iOS only |
| `paper` | `PaperOptions` | No | iOS, Android |
| `printer` | `string` | No | iOS: printer URL for direct print |
| `ui` | `UIOptions` | No | iPad popover settings |
| `autoFit` | `boolean` | No | Android images only |
| `javascript` | `boolean` | No | Android: enable JS in WebView. Default: `false` |

## Return Value

```typescript
interface PrintResult {
  success: boolean;
}
```

## Platform Behavior

### iOS
1. The HTML string is passed to `UIMarkupTextPrintFormatter`.
2. If `header` or `footer` is set, a custom `UIPrintPageRenderer` renders them around the HTML content.
3. The native print dialog is presented (or direct printing if `printer` is set).

### Android
1. A temporary `WebView` is created off-screen.
2. The HTML is loaded via `loadDataWithBaseURL()`.
3. After the page finishes loading (`onPageFinished`), a `PrintDocumentAdapter` is created from the WebView.
4. The system print dialog is shown.

### Web
1. Opens a new browser window.
2. Writes the HTML into the window.
3. Calls `window.print()` then closes the window.
4. Always returns `{ success: true }`.

## Examples

### Basic HTML

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

await Printer.printHtml({
  html: '<h1>Hello World</h1>',
});
```

### Styled HTML

```typescript
await Printer.printHtml({
  html: `
    <style>
      body { font-family: Arial, sans-serif; }
      h1 { color: #333; }
      table { width: 100%; border-collapse: collapse; }
      td { padding: 8px; border: 1px solid #ddd; }
    </style>
    <h1>Invoice #1234</h1>
    <table>
      <tr><td>Item A</td><td>$20.00</td></tr>
      <tr><td>Item B</td><td>$22.00</td></tr>
      <tr><td><strong>Total</strong></td><td><strong>$42.00</strong></td></tr>
    </table>
  `,
  name: 'Invoice-1234',
});
```

### Landscape with custom paper

```typescript
await Printer.printHtml({
  html: '<table>...</table>',
  orientation: 'landscape',
  paper: { name: 'A4' },
  margin: { top: '5mm', left: '10mm', right: '10mm', bottom: '5mm' },
});
```

### With headers and footers (iOS)

```typescript
await Printer.printHtml({
  html: '<p>Page content here...</p>',
  header: {
    height: '3cm',
    labels: [
      {
        text: 'Company Name',
        font: { bold: true, size: 16, align: 'left' },
        left: '1cm',
        top: '1cm',
      },
      {
        text: 'Page %ld',
        showPageIndex: true,
        font: { size: 10, align: 'right' },
        right: '1cm',
        top: '1cm',
      },
    ],
  },
  footer: {
    height: '1.5cm',
    label: {
      text: 'Confidential',
      font: { size: 9, italic: true, align: 'center', color: '#999999' },
    },
  },
});
```

## Errors

| Error | Cause |
|:------|:------|
| `"The 'html' parameter is required"` | `html` was not provided or is `null` |
| `"WebView not available"` | Android: bridge WebView not accessible |
| `"Print failed: ..."` | Android: exception during print |
