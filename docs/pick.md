# pick()

Display the system printer picker interface, allowing the user to select a printer. **iOS only.**

The returned printer URL can then be passed to any print method via the `printer` option to enable direct printing without showing the print dialog.

## Signature

```typescript
pick(options?: PickOptions): Promise<PickResult>
```

## Parameters

### PickOptions

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `ui` | `UIOptions` | No | Positioning for the iPad popover |

### UIOptions (for `ui`)

| Property | Type | Description |
|:---------|:-----|:------------|
| `top` | `number` | Y position of the popover anchor (iPad). Default: `30` |
| `left` | `number` | X position of the popover anchor (iPad). Default: `40` |
| `width` | `number` | Width of the popover anchor (iPad). Default: `0` |
| `height` | `number` | Height of the popover anchor (iPad). Default: `0` |

On iPhone, these positioning options are ignored — the picker is presented as a full-screen modal.

## Return Value

```typescript
interface PickResult {
  url?: string;
}
```

- `url` — The URL string of the selected printer (e.g. `"ipp://printer.local.:631/ipp/print"`).
- `undefined` — The user cancelled the picker without selecting a printer.

## Platform Behavior

### iOS
1. Creates a `UIPrinterPickerController` with no initially selected printer.
2. On iPad: presents as a popover anchored at the position specified by `ui`.
3. On iPhone: presents as a full-screen modal.
4. The selected printer is remembered internally, so it appears pre-selected in the next print dialog.

### Android
**Not supported.** The method call is rejected with the error `"Printer picker is not supported on Android"`. On Android, printer selection is handled by the system print dialog.

### Web
**Not available.** Throws an `unimplemented` error.

## Examples

### Basic picker

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

const { url } = await Printer.pick();

if (url) {
  console.log('Selected printer:', url);
} else {
  console.log('No printer selected');
}
```

### Pick and print directly

```typescript
const { url } = await Printer.pick();

if (url) {
  await Printer.printHtml({
    html: '<h1>Direct Print</h1><p>This goes straight to the printer.</p>',
    printer: url,
  });
}
```

### With popover positioning (iPad)

```typescript
const { url } = await Printer.pick({
  ui: {
    top: 100,
    left: 200,
    width: 44,
    height: 44,
  },
});
```

### Store printer for later use

```typescript
let savedPrinterUrl: string | undefined;

async function selectPrinter() {
  const { url } = await Printer.pick();
  if (url) {
    savedPrinterUrl = url;
  }
}

async function quickPrint(html: string) {
  await Printer.printHtml({
    html,
    printer: savedPrinterUrl, // Direct print if saved, dialog otherwise
  });
}
```

## Errors

| Error | Cause |
|:------|:------|
| `"Printer picker is not supported on Android"` | Called on Android |
| `"pick() is not available on web."` | Called on the web platform |
