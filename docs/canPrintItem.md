# canPrintItem()

Check if the device supports printing. Optionally verifies if a specific item (file, resource, or base64 data) can be printed.

## Signature

```typescript
canPrintItem(options?: CanPrintOptions): Promise<CanPrintResult>
```

## Parameters

### CanPrintOptions

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `uri` | `string` | No | URI of the item to check (`file://`, `res:`, `base64:`) |

If `uri` is omitted, the method checks general printing availability.

## Return Value

```typescript
interface CanPrintResult {
  available: boolean;
}
```

- `available: true` — The device can print (or the specific item is printable).
- `available: false` — Printing is not available (or the item is not printable).

## Platform Behavior

### iOS
- Without URI: checks `UIPrintInteractionController.isPrintingAvailable`.
- With URI: resolves the URI via `PrinterItem` and checks if the result can be printed by `UIPrintInteractionController.canPrint(_:)`.

### Android
- Without URI: checks that the Android Print Framework is available (always `true` on API 24+).
- With URI: attempts to detect the content type and returns `true` if it's a known printable type (PDF, image).

### Web
- Returns `{ available: true }` if `window.print` is a function.
- The `uri` parameter is ignored.

## Examples

### Check general availability

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

const { available } = await Printer.canPrintItem();

if (available) {
  // Printing is supported
}
```

### Check a specific file

```typescript
const { available } = await Printer.canPrintItem({
  uri: 'file:///path/to/document.pdf',
});

if (available) {
  await Printer.printPdf({ path: 'file:///path/to/document.pdf' });
} else {
  console.log('This file cannot be printed');
}
```

### Check a resource

```typescript
const { available } = await Printer.canPrintItem({
  uri: 'res://logo',
});
```

### Check base64 data

```typescript
const { available } = await Printer.canPrintItem({
  uri: 'base64://JVBERi0xLjQK...',
});
```

## Errors

This method does not throw errors under normal conditions. It returns `{ available: false }` instead of failing.
