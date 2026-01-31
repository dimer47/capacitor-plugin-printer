# 🖨️ Capacitor Plugin Printer

![Version](https://img.shields.io/npm/v/capacitor-plugin-printer?color=red&style=flat-square) ![Last update](https://img.shields.io/github/last-commit/dimer47/cordova-plugin-printer?color=yellow&label=Last%20update&style=flat-square) ![Bundle size](https://img.shields.io/bundlephobia/minzip/capacitor-plugin-printer?color=green&label=bundle%20size&style=flat-square) ![Repo size](https://img.shields.io/github/repo-size/dimer47/cordova-plugin-printer?style=flat-square) ![Downloads](https://img.shields.io/npm/dt/capacitor-plugin-printer?style=flat-square) ![License](https://img.shields.io/github/license/dimer47/cordova-plugin-printer?style=flat-square) ![Capacitor](https://img.shields.io/badge/Capacitor-8-blue?style=flat-square&logo=capacitor) ![iOS](https://img.shields.io/badge/iOS-15%2B-black?style=flat-square&logo=apple) ![Android](https://img.shields.io/badge/Android-7.0%2B-green?style=flat-square&logo=android)

A [Capacitor](https://capacitorjs.com) plugin to print HTML, PDF, images, and plain text on iOS, Android, and Web.

```typescript
import { Printer } from 'capacitor-plugin-printer';

await Printer.printHtml({ html: '<b>Hello Capacitor!</b>' });
```

**⚠️ Warning:** Version 2.0 introduces breaking changes (migration from Cordova to Capacitor 8, new dedicated print methods, Swift + Kotlin rewrite). If you were using version 1.x, please review the new API below.

## 🎉 Features

- 📄 Print **HTML & CSS** with full styling support
- 📝 Print **plain text** with font customization
- 📑 Print **PDF documents** from file paths or URIs
- 🖼️ Print **images** (PNG, JPEG, GIF, BMP, HEIF)
- 🔐 Print **base64-encoded** data with explicit MIME types
- 🌐 Print the current **WebView** content
- 📐 **Paper sizes** — named sizes (A0–A10, Letter, Legal, Tabloid, etc.) and custom dimensions
- 📏 **Unit support** — points, inches, millimeters, centimeters
- 🎨 **Headers & footers** with labels, page numbers, and font styling (iOS)
- 🖨️ **Direct print** to a specific printer without dialog (iOS)
- ✂️ **Duplex** printing (double-sided)

## 📍 Supported Platforms

| Platform | Version |
|:---------|:--------|
| iOS | 15+ |
| Android | 7.0+ (API 24) |
| Web | Modern browsers |

## 📦 Installation

```bash
npm install capacitor-plugin-printer
npx cap sync
```

## 🧮 API

### Methods

| Method | Description |
|:-------|:-----------|
| [`print()`](#-print) | Print content with auto-detected type |
| [`printHtml()`](#-printhtml) | Print an HTML string |
| [`printPdf()`](#-printpdf) | Print a PDF from a file path or URI |
| [`printBase64()`](#-printbase64) | Print base64-encoded data |
| [`printFile()`](#-printfile) | Print a file from a path or URI |
| [`printWebView()`](#-printwebview) | Print the current WebView content |
| [`canPrintItem()`](#-canprintitem) | Check if the device can print |
| [`getPrintableTypes()`](#-getprintabletypes) | List supported printable document types |
| [`pick()`](#-pick) | Show the printer picker (iOS only) |

---

### 📄 print()

```typescript
print(options?: PrintOptions) => Promise<PrintResult>
```

Print content with automatic type detection. The plugin detects whether the content is HTML, a file URI, base64 data, or plain text.

```typescript
// HTML
await Printer.print({ content: '<h1>Hello</h1>' });

// File
await Printer.print({ content: 'file:///path/to/document.pdf' });

// Base64
await Printer.print({ content: 'base64://JVBERi0...' });

// Plain text
await Printer.print({ content: 'Hello World' });
```

---

### 📄 printHtml()

```typescript
printHtml(options: PrintHtmlOptions) => Promise<PrintResult>
```

Print an HTML string.

```typescript
await Printer.printHtml({
  html: '<h1>Invoice</h1><p>Amount: $42.00</p>',
  name: 'Invoice',
  orientation: 'portrait',
});
```

---

### 📑 printPdf()

```typescript
printPdf(options: PrintPdfOptions) => Promise<PrintResult>
```

Print a PDF file from a path or URI.

```typescript
await Printer.printPdf({ path: 'file:///path/to/document.pdf' });
```

---

### 🔐 printBase64()

```typescript
printBase64(options: PrintBase64Options) => Promise<PrintResult>
```

Print base64-encoded data with an explicit MIME type.

```typescript
await Printer.printBase64({
  data: 'JVBERi0xLjQK...', // base64 string without prefix
  mimeType: 'application/pdf',
});
```

---

### 🖼️ printFile()

```typescript
printFile(options: PrintFileOptions) => Promise<PrintResult>
```

Print a file from a path or URI. The MIME type is detected automatically if not provided.

```typescript
await Printer.printFile({ path: 'file:///path/to/image.png' });

// With explicit MIME type
await Printer.printFile({
  path: 'file:///path/to/doc',
  mimeType: 'application/pdf',
});
```

---

### 🌐 printWebView()

```typescript
printWebView(options?: PrintWebViewOptions) => Promise<PrintResult>
```

Print the current WebView content.

```typescript
await Printer.printWebView();

// With options
await Printer.printWebView({ orientation: 'landscape' });
```

---

### ✅ canPrintItem()

```typescript
canPrintItem(options?: CanPrintOptions) => Promise<CanPrintResult>
```

Check if the device supports printing, optionally for a specific item.

```typescript
const { available } = await Printer.canPrintItem();

// Check a specific URI
const { available } = await Printer.canPrintItem({ uri: 'file:///path/to/file.pdf' });
```

---

### 📋 getPrintableTypes()

```typescript
getPrintableTypes() => Promise<PrintableTypesResult>
```

Get the list of printable document types supported by the platform (UTIs on iOS, MIME types on Android).

```typescript
const { types } = await Printer.getPrintableTypes();
// e.g. ["com.adobe.pdf", "public.jpeg", "public.png", ...]
```

---

### 🖨️ pick()

```typescript
pick(options?: PickOptions) => Promise<PickResult>
```

Show the system printer picker. **iOS only** — on Android, this method will reject.

```typescript
const { url } = await Printer.pick();
if (url) {
  await Printer.printHtml({ html: '<p>Direct print</p>', printer: url });
}
```

---

## ⚙️ Options

### BasePrintOptions

Common options shared by all print methods.

| Property | Type | Default | Platform | Description |
|:---------|:-----|:--------|:---------|:------------|
| `name` | `string` | — | All | Job name and document title |
| `orientation` | `'portrait' \| 'landscape'` | `'portrait'` | All | Print orientation |
| `monochrome` | `boolean` | `false` | All | Black & white printing |
| `photo` | `boolean` | `false` | iOS | Photography media type for higher quality |
| `copies` | `number` | `1` | iOS | Number of copies |
| `pageCount` | `number` | — | iOS, Android | Maximum number of pages to print |
| `duplex` | `'none' \| 'long' \| 'short'` | `'none'` | All | Double-sided printing |
| `margin` | `boolean \| MarginOptions` | — | All | Margins. Set to `false` to disable |
| `font` | `FontOptions` | — | iOS | Font configuration for plain text |
| `maxWidth` | `string \| number` | — | iOS | Maximum content width |
| `maxHeight` | `string \| number` | — | iOS | Maximum content height |
| `header` | `HeaderFooterOptions` | — | iOS | Header configuration |
| `footer` | `HeaderFooterOptions` | — | iOS | Footer configuration |
| `paper` | `PaperOptions` | — | iOS, Android | Paper format |
| `printer` | `string` | — | iOS | Printer URL for direct printing (skip dialog) |
| `ui` | `UIOptions` | — | iOS | Printer dialog UI options |
| `autoFit` | `boolean` | `true` | Android | Auto-scale images to fit content area |
| `javascript` | `boolean` | `false` | Android | Enable JavaScript in WebView rendering |

### PrintOptions

Extends `BasePrintOptions` with:

| Property | Type | Description |
|:---------|:-----|:------------|
| `content` | `string` | Content to print (HTML, text, file URI, or base64 URI) |

### PrintHtmlOptions

Extends `BasePrintOptions` with:

| Property | Type | Description |
|:---------|:-----|:------------|
| `html` | `string` **(required)** | HTML string to print |

### PrintPdfOptions

Extends `BasePrintOptions` with:

| Property | Type | Description |
|:---------|:-----|:------------|
| `path` | `string` **(required)** | File path or URI to the PDF |

### PrintBase64Options

Extends `BasePrintOptions` with:

| Property | Type | Description |
|:---------|:-----|:------------|
| `data` | `string` **(required)** | Base64-encoded data |
| `mimeType` | `string` **(required)** | MIME type (e.g. `'application/pdf'`, `'image/png'`) |

### PrintFileOptions

Extends `BasePrintOptions` with:

| Property | Type | Description |
|:---------|:-----|:------------|
| `path` | `string` **(required)** | File path or URI |
| `mimeType` | `string` | MIME type (auto-detected if omitted) |

### MarginOptions

| Property | Type | Description |
|:---------|:-----|:------------|
| `top` | `string \| number` | Top margin |
| `left` | `string \| number` | Left margin |
| `bottom` | `string \| number` | Bottom margin |
| `right` | `string \| number` | Right margin |

### FontOptions

| Property | Type | Description |
|:---------|:-----|:------------|
| `name` | `string` | Font family name |
| `size` | `number` | Font size in points |
| `color` | `string` | Hex color (e.g. `'#FF0000'`) |
| `align` | `'left' \| 'right' \| 'center' \| 'justified'` | Text alignment |
| `bold` | `boolean` | Bold text |
| `italic` | `boolean` | Italic text |

### HeaderFooterOptions

| Property | Type | Description |
|:---------|:-----|:------------|
| `height` | `string \| number` | Header/footer area height |
| `text` | `string` | Simple text content |
| `label` | `LabelOptions` | Single label |
| `labels` | `LabelOptions[]` | Multiple labels |

### LabelOptions

| Property | Type | Description |
|:---------|:-----|:------------|
| `text` | `string` | Label text. Use `%ld` to insert page number (e.g. `"Page %ld"`) |
| `showPageIndex` | `boolean` | Display the page number |
| `font` | `FontOptions` | Label font styling |
| `top` | `string \| number` | Top offset within the header/footer area |
| `left` | `string \| number` | Left offset |
| `right` | `string \| number` | Right offset |
| `bottom` | `string \| number` | Bottom offset |

### PaperOptions

| Property | Type | Description |
|:---------|:-----|:------------|
| `width` | `string \| number` | Paper width (e.g. `'210mm'`) |
| `height` | `string \| number` | Paper height (e.g. `'297mm'`) |
| `name` | `string` | Named paper size (e.g. `'A4'`, `'LETTER'`) |
| `length` | `string \| number` | Cut length for roll-fed printers (iOS) |

**Named paper sizes:** A0–A10, B0–B10, C0–C10, LETTER, LEGAL, TABLOID, LEDGER, JUNIOR_LEGAL, GOVT_LETTER, 4X6, 5X7, 8X10, JIS_B0–JIS_B10, and many more (JPN, ROC, PRC series).

### UIOptions

| Property | Type | Platform | Description |
|:---------|:-----|:---------|:------------|
| `hideNumberOfCopies` | `boolean` | iOS | Hide the copies control |
| `hidePaperFormat` | `boolean` | iOS | Hide the paper format control |
| `top` | `number` | iPad | Popover Y position |
| `left` | `number` | iPad | Popover X position |
| `width` | `number` | iPad | Popover width |
| `height` | `number` | iPad | Popover height |

### 📏 Unit type

Dimension values accept either a number (in points) or a string with a unit suffix:

| Suffix | Unit | Example |
|:-------|:-----|:--------|
| `pt` | Points | `"72pt"` (= 1 inch) |
| `in` | Inches | `"2in"` |
| `mm` | Millimeters | `"210mm"` |
| `cm` | Centimeters | `"29.7cm"` |

A plain number is interpreted as points: `72` is the same as `"72pt"` (1 inch).

---

## 📤 Return Types

### PrintResult

```typescript
interface PrintResult {
  success: boolean;
}
```

### CanPrintResult

```typescript
interface CanPrintResult {
  available: boolean;
}
```

### PrintableTypesResult

```typescript
interface PrintableTypesResult {
  types: string[];
}
```

### PickResult

```typescript
interface PickResult {
  url?: string; // Printer URL, or undefined if cancelled
}
```

---

## 🔗 URI Schemes

| Scheme | Example | Description |
|:-------|:--------|:------------|
| `file:///` | `file:///path/to/file.pdf` | Absolute file path |
| `file://` | `file://assets/image.png` | App assets/bundle |
| `res:` | `res://icon` | App resources |
| `base64:` | `base64://JVBERi0...` | Base64-encoded data |

---

## 🖨️ Direct Print (iOS)

On iOS, you can send content directly to a printer without showing the print dialog by passing the printer URL:

```typescript
await Printer.printHtml({
  html: '<p>Direct print</p>',
  printer: 'ipp://printer.local.:631/ipp/print',
});
```

Use [`pick()`](#-pick) to let the user select a printer and retrieve its URL:

```typescript
const { url } = await Printer.pick();
if (url) {
  await Printer.printHtml({ html: content, printer: url });
}
```

---

## 💡 Full Example

```typescript
import { Printer } from 'capacitor-plugin-printer';

await Printer.printHtml({
  html: `
    <h1>Invoice #1234</h1>
    <p>Date: 2025-01-15</p>
    <table>
      <tr><td>Item</td><td>$42.00</td></tr>
    </table>
  `,
  name: 'Invoice-1234',
  orientation: 'portrait',
  monochrome: false,
  duplex: 'long',
  paper: { name: 'A4' },
  margin: { top: '1cm', left: '1cm', right: '1cm', bottom: '1cm' },
  header: {
    height: '2cm',
    label: {
      text: 'My Company',
      font: { bold: true, size: 14, align: 'center' },
    },
  },
  footer: {
    height: '1.5cm',
    label: {
      text: 'Page %ld',
      showPageIndex: true,
      font: { size: 10, align: 'center' },
    },
  },
});
```

---

## 📊 Platform Feature Matrix

| Feature | iOS | Android | Web |
|:--------|:---:|:-------:|:---:|
| Print HTML | ✅ | ✅ | ✅ |
| Print plain text | ✅ | ✅ | ✅ |
| Print PDF | ✅ | ✅ | — |
| Print images | ✅ | ✅ | — |
| Print base64 data | ✅ | ✅ | — |
| Print WebView | ✅ | ✅ | ✅ |
| Headers & footers | ✅ | — | — |
| Direct print (printer URL) | ✅ | — | — |
| Printer picker (`pick`) | ✅ | — | — |
| Number of copies | ✅ | — | — |
| Paper size selection | ✅ | ✅ | — |
| JavaScript in WebView | — | ✅ | — |

---

## 🤝 Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## 🧾 License

This software is released under the [Apache 2.0 License](http://opensource.org/licenses/Apache-2.0).
