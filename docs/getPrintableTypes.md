# getPrintableTypes()

Returns a list of all document types that can be printed on the current platform.

## Signature

```typescript
getPrintableTypes(): Promise<PrintableTypesResult>
```

## Parameters

None.

## Return Value

```typescript
interface PrintableTypesResult {
  types: string[];
}
```

The format of the type identifiers depends on the platform:
- **iOS**: Uniform Type Identifiers (UTIs), e.g. `"com.adobe.pdf"`, `"public.jpeg"`
- **Android**: UTI-style identifiers (hardcoded list), e.g. `"com.adobe.pdf"`, `"public.png"`
- **Web**: empty array `[]`

## Platform Behavior

### iOS
Returns the contents of `UIPrintInteractionController.printableUTIs`, which is the set of all UTIs that the print system can handle. This list depends on the iOS version and installed system capabilities.

### Android
Returns a fixed list of supported types:

```json
[
  "com.adobe.pdf",
  "com.microsoft.bmp",
  "public.jpeg",
  "public.jpeg-2000",
  "public.png",
  "public.heif",
  "com.compuserve.gif",
  "com.microsoft.ico"
]
```

### Web
Returns `{ types: [] }` — an empty array, since the web platform prints via `window.print()` and doesn't expose document type support.

## Examples

### List all printable types

```typescript
import { Printer } from '@dimer47/capacitor-plugin-printer';

const { types } = await Printer.getPrintableTypes();
console.log('Printable types:', types);
// iOS example: ["com.adobe.pdf", "public.jpeg", "public.png", "public.heif", ...]
```

### Check if a specific type is supported

```typescript
const { types } = await Printer.getPrintableTypes();

if (types.includes('com.adobe.pdf')) {
  console.log('PDF printing is supported');
}
```

## Errors

This method does not throw errors under normal conditions.
