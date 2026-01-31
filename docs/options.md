# Options Reference

Complete reference for all option interfaces and types used by the plugin.

## Table of Contents

- [BasePrintOptions](#baseprintoptions)
- [PrintOptions](#printoptions)
- [PrintHtmlOptions](#printhtmloptions)
- [PrintPdfOptions](#printpdfoptions)
- [PrintBase64Options](#printbase64options)
- [PrintFileOptions](#printfileoptions)
- [PrintWebViewOptions](#printwebviewoptions)
- [MarginOptions](#marginoptions)
- [FontOptions](#fontoptions)
- [HeaderFooterOptions](#headerfooteroptions)
- [LabelOptions](#labeloptions)
- [PaperOptions](#paperoptions)
- [UIOptions](#uioptions)
- [CanPrintOptions](#canprintoptions)
- [PickOptions](#pickoptions)
- [Unit Type](#unit-type)
- [Return Types](#return-types)

---

## BasePrintOptions

Common settings shared by all dedicated print methods (`printHtml`, `printPdf`, `printBase64`, `printFile`, `printWebView`). This is `PrintOptions` without the `content` field.

```typescript
type BasePrintOptions = Omit<PrintOptions, 'content'>;
```

| Property | Type | Default | Platform | Description |
|:---------|:-----|:--------|:---------|:------------|
| `name` | `string` | — | All | Print job name and document title |
| `orientation` | `'portrait' \| 'landscape'` | `'portrait'` | All | Print orientation |
| `monochrome` | `boolean` | `false` | All | Grayscale printing |
| `photo` | `boolean` | `false` | iOS | Use photo media type for higher quality |
| `copies` | `number` | `1` | iOS | Number of copies to print |
| `pageCount` | `number` | — | iOS, Android | Maximum number of pages. On iOS, negative values skip last N pages |
| `duplex` | `'none' \| 'long' \| 'short'` | `'none'` | All | Double-sided printing mode |
| `margin` | `boolean \| MarginOptions` | — | All | Margin configuration. `false` = no margins |
| `font` | `FontOptions` | — | iOS | Font settings (for plain text content) |
| `maxWidth` | `string \| number` | — | iOS | Maximum content area width |
| `maxHeight` | `string \| number` | — | iOS | Maximum content area height |
| `header` | `HeaderFooterOptions` | — | iOS | Page header configuration |
| `footer` | `HeaderFooterOptions` | — | iOS | Page footer configuration |
| `paper` | `PaperOptions` | — | iOS, Android | Paper size/format selection |
| `printer` | `string` | — | iOS | Printer URL for direct printing (skip dialog) |
| `ui` | `UIOptions` | — | iOS | Print dialog positioning (iPad) |
| `autoFit` | `boolean` | `true` | Android | Auto-scale images to fit printable area |
| `javascript` | `boolean` | `false` | Android | Enable JavaScript in the rendering WebView |

### Duplex modes

| Value | Description |
|:------|:------------|
| `'none'` | Single-sided printing |
| `'long'` | Double-sided, flipping on the long edge (book-style) |
| `'short'` | Double-sided, flipping on the short edge (notepad-style) |

---

## PrintOptions

Used by the generic `print()` method. Extends all `BasePrintOptions` with a `content` field.

```typescript
interface PrintOptions extends BasePrintOptions {
  content?: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `content` | `string` | No | Content to print. Auto-detected as HTML, text, file URI, or base64 |

---

## PrintHtmlOptions

```typescript
interface PrintHtmlOptions extends BasePrintOptions {
  html: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `html` | `string` | **Yes** | HTML string to print |

---

## PrintPdfOptions

```typescript
interface PrintPdfOptions extends BasePrintOptions {
  path: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `path` | `string` | **Yes** | File path or URI to the PDF |

---

## PrintBase64Options

```typescript
interface PrintBase64Options extends BasePrintOptions {
  data: string;
  mimeType: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `data` | `string` | **Yes** | Base64-encoded binary data (no prefix) |
| `mimeType` | `string` | **Yes** | MIME type (e.g. `'application/pdf'`, `'image/png'`) |

---

## PrintFileOptions

```typescript
interface PrintFileOptions extends BasePrintOptions {
  path: string;
  mimeType?: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `path` | `string` | **Yes** | File path or URI |
| `mimeType` | `string` | No | MIME type. Auto-detected from extension if omitted |

---

## PrintWebViewOptions

```typescript
type PrintWebViewOptions = BasePrintOptions;
```

Same as `BasePrintOptions` — no content field. Prints the current WebView.

---

## MarginOptions

```typescript
interface MarginOptions {
  top?: string | number;
  left?: string | number;
  bottom?: string | number;
  right?: string | number;
}
```

Each value accepts a number (in points) or a string with a unit suffix. See [Unit Type](#unit-type).

**Setting `margin: false`** disables all margins.

**iOS behavior:** Values are converted to points and applied as `contentInsets` on the print formatter.

**Android behavior:** Values are converted to mils (thousandths of an inch) and applied to `PrintAttributes.Margins`.

### Examples

```typescript
// Using unit strings
margin: { top: '1cm', left: '15mm', right: '15mm', bottom: '1cm' }

// Using points (1 inch = 72 points)
margin: { top: 36, left: 36, right: 36, bottom: 36 }

// Disable margins
margin: false
```

---

## FontOptions

Font configuration for plain text printing. On iOS, this creates a `UIFont` with the specified attributes. Not applicable to HTML content (use CSS instead).

```typescript
interface FontOptions {
  name?: string;
  size?: number;
  color?: string;
  align?: 'left' | 'right' | 'center' | 'justified';
  bold?: boolean;
  italic?: boolean;
}
```

| Property | Type | Default | Description |
|:---------|:-----|:--------|:------------|
| `name` | `string` | System font | Font family name (e.g. `'Helvetica'`, `'Courier'`) |
| `size` | `number` | System default | Font size in points |
| `color` | `string` | Black | Hex color string: `'#FF0000'` or `'FF0000'` |
| `align` | `string` | `'left'` | Text alignment |
| `bold` | `boolean` | `false` | Bold weight |
| `italic` | `boolean` | `false` | Italic style |

### Examples

```typescript
font: {
  name: 'Helvetica',
  size: 14,
  color: '#333333',
  align: 'center',
  bold: true,
}
```

---

## HeaderFooterOptions

Configure page headers and footers. **iOS only.**

```typescript
interface HeaderFooterOptions {
  height?: string | number;
  text?: string;
  label?: LabelOptions;
  labels?: LabelOptions[];
}
```

| Property | Type | Description |
|:---------|:-----|:------------|
| `height` | `string \| number` | Height of the header/footer area |
| `text` | `string` | Simple text content (shorthand for a single centered label) |
| `label` | `LabelOptions` | Single label with positioning and font control |
| `labels` | `LabelOptions[]` | Multiple labels positioned within the area |

Use `label` for a single label, or `labels` for multiple labels in the same header/footer area.

### Examples

```typescript
// Simple text
header: { height: '2cm', text: 'Document Title' }

// Single label with styling
header: {
  height: '2cm',
  label: {
    text: 'Company Name',
    font: { bold: true, size: 16, align: 'center' },
  },
}

// Multiple labels
header: {
  height: '2cm',
  labels: [
    {
      text: 'Left Title',
      font: { bold: true },
      left: '1cm',
      top: '5mm',
    },
    {
      text: 'Page %ld',
      showPageIndex: true,
      font: { size: 10 },
      right: '1cm',
      top: '5mm',
    },
  ],
}
```

---

## LabelOptions

A label within a header or footer area. **iOS only.**

```typescript
interface LabelOptions {
  text?: string;
  showPageIndex?: boolean;
  font?: FontOptions;
  top?: string | number;
  left?: string | number;
  right?: string | number;
  bottom?: string | number;
}
```

| Property | Type | Description |
|:---------|:-----|:------------|
| `text` | `string` | Label text. Use `%ld` as a placeholder for the page number |
| `showPageIndex` | `boolean` | Enable page number display. Required for `%ld` substitution |
| `font` | `FontOptions` | Font styling for this label |
| `top` | `string \| number` | Top offset within the header/footer area |
| `left` | `string \| number` | Left offset |
| `right` | `string \| number` | Right offset |
| `bottom` | `string \| number` | Bottom offset |

### Page numbering

To display page numbers, set `showPageIndex: true` and use `%ld` in the text:

```typescript
{
  text: 'Page %ld',
  showPageIndex: true,
}
// Renders: "Page 1", "Page 2", "Page 3", ...
```

```typescript
{
  text: '%ld / Total',
  showPageIndex: true,
}
// Renders: "1 / Total", "2 / Total", ...
```

---

## PaperOptions

Paper size configuration. Supported on iOS and Android.

```typescript
interface PaperOptions {
  width?: string | number;
  height?: string | number;
  length?: string | number;
  name?: string;
}
```

| Property | Type | Platform | Description |
|:---------|:-----|:---------|:------------|
| `width` | `string \| number` | iOS, Android | Paper width |
| `height` | `string \| number` | iOS, Android | Paper height |
| `length` | `string \| number` | iOS | Cut length for roll-fed printers |
| `name` | `string` | iOS, Android | Named paper size (takes precedence over width/height) |

**iOS behavior:** The system finds the best matching paper from the printer's available stock using `bestPaper(forPageSize:withPapersFrom:)`.

**Android behavior:** The named size maps to an `PrintAttributes.MediaSize` constant. Custom width/height creates a custom media size.

See [Paper Sizes](./paper-sizes.md) for the full list of named sizes.

### Examples

```typescript
// Named size
paper: { name: 'A4' }

// Custom dimensions
paper: { width: '210mm', height: '297mm' }

// Roll printer with cut length (iOS)
paper: { width: '80mm', length: '200mm' }
```

---

## UIOptions

Options for controlling the print dialog appearance, primarily on iPad.

```typescript
interface UIOptions {
  hideNumberOfCopies?: boolean;
  hidePaperFormat?: boolean;
  top?: number;
  left?: number;
  width?: number;
  height?: number;
}
```

| Property | Type | Default | Platform | Description |
|:---------|:-----|:--------|:---------|:------------|
| `hideNumberOfCopies` | `boolean` | `false` | iOS | Hide the copies control in the dialog |
| `hidePaperFormat` | `boolean` | `false` | iOS | Hide the paper format control |
| `top` | `number` | `30` | iPad | Y position of the popover anchor |
| `left` | `number` | `40` | iPad | X position of the popover anchor |
| `width` | `number` | `0` | iPad | Width of the popover anchor rect |
| `height` | `number` | `0` | iPad | Height of the popover anchor rect |

On iPhone, the print dialog is always presented as a full-screen sheet. The position/size options only affect iPad's popover presentation.

---

## CanPrintOptions

```typescript
interface CanPrintOptions {
  uri?: string;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `uri` | `string` | No | URI to check (`file://`, `res:`, `base64:`) |

---

## PickOptions

```typescript
interface PickOptions {
  ui?: UIOptions;
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `ui` | `UIOptions` | No | iPad popover positioning |

---

## Unit Type

Many dimension properties (`margin`, `maxWidth`, `maxHeight`, `header.height`, `paper.width`, label positions, etc.) accept a **Unit** type: either a number or a string with a unit suffix.

```typescript
type Unit = string | number;
```

### Supported units

| Suffix | Unit | Example | Equivalent |
|:-------|:-----|:--------|:-----------|
| `pt` | Points | `"72pt"` | 1 inch |
| `in` | Inches | `"1in"` | 72 points |
| `mm` | Millimeters | `"25.4mm"` | 1 inch |
| `cm` | Centimeters | `"2.54cm"` | 1 inch |
| *(none)* | Points | `72` | 1 inch |

A plain number is always interpreted as **points**.

### Conversion table

| From | To Points (iOS) | To Mils (Android) |
|:-----|:----------------|:------------------|
| 1 pt | 1.0 | 13.889 |
| 1 in | 72.0 | 1000.0 |
| 1 mm | 2.835 | 39.370 |
| 1 cm | 28.346 | 393.701 |

---

## Return Types

### PrintResult

```typescript
interface PrintResult {
  success: boolean;
}
```

| Field | Description |
|:------|:------------|
| `success: true` | Print job submitted / user confirmed |
| `success: false` | User cancelled the print dialog |

### CanPrintResult

```typescript
interface CanPrintResult {
  available: boolean;
}
```

| Field | Description |
|:------|:------------|
| `available: true` | Device can print (the specified item) |
| `available: false` | Printing not available |

### PrintableTypesResult

```typescript
interface PrintableTypesResult {
  types: string[];
}
```

Array of printable type identifiers (UTIs on iOS, UTI-style on Android, empty on Web).

### PickResult

```typescript
interface PickResult {
  url?: string;
}
```

| Field | Description |
|:------|:------------|
| `url` | Printer URL string (e.g. `"ipp://..."`) |
| `undefined` | User cancelled the picker |
