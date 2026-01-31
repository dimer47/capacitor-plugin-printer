# Paper Sizes

Complete reference of all named paper sizes supported by the `paper.name` option.

## Usage

```typescript
await Printer.printHtml({
  html: '<p>Content</p>',
  paper: { name: 'A4' },
});
```

Paper names are **case-insensitive**: `'A4'`, `'a4'`, and `'A4'` all work.

## ISO Sizes

### A Series

| Name | Width (mm) | Height (mm) | Platform |
|:-----|:-----------|:------------|:---------|
| `A0` | 841 | 1189 | iOS, Android |
| `A1` | 594 | 841 | iOS, Android |
| `A2` | 420 | 594 | iOS, Android |
| `A3` | 297 | 420 | iOS, Android |
| `A4` | 210 | 297 | iOS, Android |
| `A5` | 148 | 210 | iOS, Android |
| `A6` | 105 | 148 | iOS, Android |
| `A7` | 74 | 105 | iOS, Android |
| `A8` | 52 | 74 | iOS, Android |
| `A9` | 37 | 52 | iOS, Android |
| `A10` | 26 | 37 | iOS, Android |

### B Series

| Name | Width (mm) | Height (mm) | Platform |
|:-----|:-----------|:------------|:---------|
| `B0` | 1000 | 1414 | iOS, Android |
| `B1` | 707 | 1000 | iOS, Android |
| `B2` | 500 | 707 | iOS, Android |
| `B3` | 353 | 500 | iOS, Android |
| `B4` | 250 | 353 | iOS, Android |
| `B5` | 176 | 250 | iOS, Android |
| `B6` | 125 | 176 | iOS, Android |
| `B7` | 88 | 125 | iOS, Android |
| `B8` | 62 | 88 | iOS, Android |
| `B9` | 44 | 62 | iOS, Android |
| `B10` | 31 | 44 | iOS, Android |

### C Series (Envelope)

| Name | Width (mm) | Height (mm) | Platform |
|:-----|:-----------|:------------|:---------|
| `C0` | 917 | 1297 | iOS, Android |
| `C1` | 648 | 917 | iOS, Android |
| `C2` | 458 | 648 | iOS, Android |
| `C3` | 324 | 458 | iOS, Android |
| `C4` | 229 | 324 | iOS, Android |
| `C5` | 162 | 229 | iOS, Android |
| `C6` | 114 | 162 | iOS, Android |
| `C7` | 81 | 114 | iOS, Android |
| `C8` | 57 | 81 | iOS, Android |
| `C9` | 40 | 57 | iOS, Android |
| `C10` | 28 | 40 | iOS, Android |

## North American Sizes

| Name | Width (in) | Height (in) | Platform |
|:-----|:-----------|:------------|:---------|
| `LETTER` | 8.5 | 11 | iOS, Android |
| `LEGAL` | 8.5 | 14 | iOS, Android |
| `TABLOID` | 11 | 17 | iOS, Android |
| `LEDGER` | 17 | 11 | iOS, Android |
| `JUNIOR_LEGAL` | 5 | 8 | iOS, Android |
| `GOVT_LETTER` | 8 | 10.5 | iOS, Android |
| `INDEX_3X5` | 3 | 5 | Android |
| `4X6` | 4 | 6 | iOS, Android |
| `INDEX_5X8` | 5 | 8 | Android |
| `5X7` | 5 | 7 | iOS |
| `8X10` | 8 | 10 | iOS |
| `QUARTO` | 8 | 10 | Android |
| `FOOLSCAP` | 8.5 | 13 | Android |

## JIS Sizes (Japanese Industrial Standard)

| Name | Platform |
|:-----|:---------|
| `JIS_B0` through `JIS_B10` | iOS, Android |
| `JIS_EXEC` | Android |

## Japanese Sizes

| Name | Platform |
|:-----|:---------|
| `JPN_HAGAKI` | Android |
| `JPN_OUFUKU` | Android |
| `JPN_CHOU2` | Android |
| `JPN_CHOU3` | Android |
| `JPN_CHOU4` | Android |
| `JPN_KAHU` | Android |
| `JPN_KAKU2` | Android |
| `JPN_YOU4` | Android |

## Chinese Sizes

| Name | Platform |
|:-----|:---------|
| `ROC_8K` | Android |
| `ROC_16K` | Android |
| `PRC_1` through `PRC_10` | Android |
| `PRC_16K` | Android |
| `OM_PA_KAI` | Android |
| `OM_DAI_PA_KAI` | Android |
| `OM_JUURO_KU_KAI` | Android |

## Custom Dimensions

If no named size matches your needs, use `width` and `height` directly:

```typescript
paper: { width: '100mm', height: '150mm' }
```

Values accept any [Unit type](./options.md#unit-type): numbers (in points), or strings with `mm`, `cm`, `in`, or `pt` suffixes.

## Roll-Fed Printers (iOS)

For receipt printers and other roll-fed printers, use the `length` property to control where the paper is cut:

```typescript
paper: {
  width: '80mm',   // Roll width
  length: '200mm', // Cut after 200mm
}
```

The `length` property is only supported on iOS and only works with printers that support roll media.
