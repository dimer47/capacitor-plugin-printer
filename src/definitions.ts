export interface PrinterPlugin {
  /**
   * Sends content to the printer.
   *
   * @param options - Print options including content and settings.
   * @returns A promise resolving with the print result.
   */
  print(options: PrintOptions): Promise<PrintResult>;

  /**
   * Prints an HTML string.
   *
   * Shorthand for `print()` with HTML content.
   *
   * @param options - HTML content and print settings.
   * @returns A promise resolving with the print result.
   */
  printHtml(options: PrintHtmlOptions): Promise<PrintResult>;

  /**
   * Prints a PDF file from a file path or URI.
   *
   * @param options - PDF file path and print settings.
   * @returns A promise resolving with the print result.
   */
  printPdf(options: PrintPdfOptions): Promise<PrintResult>;

  /**
   * Prints base64-encoded data with an explicit MIME type.
   *
   * @param options - Base64 data, MIME type, and print settings.
   * @returns A promise resolving with the print result.
   */
  printBase64(options: PrintBase64Options): Promise<PrintResult>;

  /**
   * Prints a file from a file path or URI, with optional MIME type.
   *
   * @param options - File path, optional MIME type, and print settings.
   * @returns A promise resolving with the print result.
   */
  printFile(options: PrintFileOptions): Promise<PrintResult>;

  /**
   * Prints the current web view content.
   *
   * @param options - Optional print settings (no content field).
   * @returns A promise resolving with the print result.
   */
  printWebView(options?: PrintWebViewOptions): Promise<PrintResult>;

  /**
   * Checks if the device can print, optionally checking a specific item.
   *
   * @param options - Optional URI to check.
   * @returns A promise resolving with availability info.
   */
  canPrintItem(options?: CanPrintOptions): Promise<CanPrintResult>;

  /**
   * Returns a list of all printable document types (UTIs).
   *
   * @returns A promise resolving with printable types.
   */
  getPrintableTypes(): Promise<PrintableTypesResult>;

  /**
   * Displays system interface for selecting a printer (iOS only).
   *
   * @param options - Optional UI positioning options.
   * @returns A promise resolving with the selected printer info.
   */
  pick(options?: PickOptions): Promise<PickResult>;
}

export interface PrintOptions {
  /**
   * The content to print: HTML string, plain text, or file URI.
   * If not provided, prints the current web view content.
   */
  content?: string;

  /**
   * The name of the print job.
   */
  name?: string;

  /**
   * The orientation of the printed content.
   * @default 'portrait'
   */
  orientation?: 'portrait' | 'landscape';

  /**
   * Whether to print in monochrome (grayscale).
   * @default false
   */
  monochrome?: boolean;

  /**
   * Whether to use photo quality printing.
   * @default false
   */
  photo?: boolean;

  /**
   * Number of copies to print.
   * @default 1
   */
  copies?: number;

  /**
   * Maximum number of pages to print.
   */
  pageCount?: number;

  /**
   * Duplex mode for double-sided printing.
   * @default 'none'
   */
  duplex?: 'none' | 'long' | 'short';

  /**
   * Margin settings. Set to false to remove margins,
   * or provide an object with top/left/bottom/right values.
   *
   * iOS: values are in points. Strings with units ('1cm', '10mm', '0.5in') are supported.
   * Android: values are converted to mils (thousandths of inch). Same unit strings are supported.
   */
  margin?: boolean | MarginOptions;

  /**
   * Font settings for plain text printing.
   */
  font?: FontOptions;

  /**
   * Maximum content width (e.g. '10cm', '4in').
   */
  maxWidth?: string | number;

  /**
   * Maximum content height (e.g. '10cm', '4in').
   */
  maxHeight?: string | number;

  /**
   * Header configuration (iOS only).
   */
  header?: HeaderFooterOptions;

  /**
   * Footer configuration (iOS only).
   */
  footer?: HeaderFooterOptions;

  /**
   * Paper size configuration (iOS + Android).
   *
   * Use `name` for standard sizes or `width`/`height` for custom dimensions.
   * On Android, this sets the default media size in the print dialog
   * (user can still change it). On iOS, the system selects the best
   * matching paper from the printer's available stock.
   */
  paper?: PaperOptions;

  /**
   * Printer URL to print directly without showing the picker dialog (iOS only).
   */
  printer?: string;

  /**
   * UI positioning options for iPad popover.
   */
  ui?: UIOptions;

  /**
   * Whether to auto-fit the image to the printable area (Android images only).
   * @default true
   */
  autoFit?: boolean;

  /**
   * Whether to enable JavaScript in the print WebView (Android only).
   * @default false
   */
  javascript?: boolean;
}

/**
 * Common print settings shared by all dedicated print methods.
 * Same as PrintOptions but without the generic `content` field.
 */
export type BasePrintOptions = Omit<PrintOptions, 'content'>;

/**
 * Options for `printHtml()`.
 */
export interface PrintHtmlOptions extends BasePrintOptions {
  /** The HTML string to print. */
  html: string;
}

/**
 * Options for `printPdf()`.
 */
export interface PrintPdfOptions extends BasePrintOptions {
  /** The file path or URI of the PDF to print. */
  path: string;
}

/**
 * Options for `printBase64()`.
 */
export interface PrintBase64Options extends BasePrintOptions {
  /** The base64-encoded data to print. */
  data: string;
  /** The MIME type of the data (e.g. 'application/pdf', 'image/png'). */
  mimeType: string;
}

/**
 * Options for `printFile()`.
 */
export interface PrintFileOptions extends BasePrintOptions {
  /** The file path or URI of the file to print. */
  path: string;
  /** Optional MIME type. If not provided, the type is guessed from the file extension. */
  mimeType?: string;
}

/**
 * Options for `printWebView()`.
 * No content field — prints the current web view.
 */
export type PrintWebViewOptions = BasePrintOptions;

export interface MarginOptions {
  top?: string | number;
  left?: string | number;
  bottom?: string | number;
  right?: string | number;
}

export interface FontOptions {
  /** Font family name. */
  name?: string;
  /** Font size in points. */
  size?: number;
  /** Text color as hex string (e.g. '#FF0000'). */
  color?: string;
  /** Text alignment. */
  align?: 'left' | 'right' | 'center' | 'justified';
  /** Whether to use bold font. */
  bold?: boolean;
  /** Whether to use italic font. */
  italic?: boolean;
}

export interface HeaderFooterOptions {
  /** Height of the header/footer area (e.g. '1cm', '0.5in'). */
  height?: string | number;
  /** Text content for simple header/footer. */
  text?: string;
  /** Single label configuration. */
  label?: LabelOptions;
  /** Multiple label configurations. */
  labels?: LabelOptions[];
}

export interface LabelOptions {
  /** The text to display. */
  text?: string;
  /** Whether to show the page index. */
  showPageIndex?: boolean;
  /** Font settings for this label. */
  font?: FontOptions;
  /** Position offsets (e.g. '5mm', '1cm'). */
  top?: string | number;
  left?: string | number;
  right?: string | number;
  bottom?: string | number;
}

export interface PaperOptions {
  /** Paper width (e.g. '210mm' for A4). */
  width?: string | number;
  /** Paper height (e.g. '297mm' for A4). */
  height?: string | number;
  /** Cut length for roll-fed printers (iOS only). */
  length?: string | number;
  /**
   * Named paper size. Takes precedence over width/height.
   *
   * ISO sizes: 'A0'-'A10', 'B0'-'B10', 'C0'-'C10'
   * North America: 'LETTER', 'LEGAL', 'TABLOID', 'LEDGER', 'JUNIOR_LEGAL',
   *   'GOVT_LETTER', 'INDEX_3X5', '4X6', 'INDEX_5X8', 'QUARTO', 'FOOLSCAP'
   * JIS: 'JIS_B0'-'JIS_B10', 'JIS_EXEC'
   * Japanese: 'JPN_HAGAKI', 'JPN_OUFUKU', 'JPN_CHOU2'-'JPN_CHOU4',
   *   'JPN_KAHU', 'JPN_KAKU2', 'JPN_YOU4'
   * Chinese: 'ROC_8K', 'ROC_16K', 'PRC_1'-'PRC_10', 'PRC_16K',
   *   'OM_PA_KAI', 'OM_DAI_PA_KAI', 'OM_JUURO_KU_KAI'
   *
   * Case-insensitive.
   */
  name?: string;
}

export interface UIOptions {
  /** Hide the number of copies selector (iOS only). */
  hideNumberOfCopies?: boolean;
  /** Hide the paper format selector (iOS only). */
  hidePaperFormat?: boolean;
  /** Top position for iPad popover. */
  top?: number;
  /** Left position for iPad popover. */
  left?: number;
  /** Width of the iPad popover anchor. */
  width?: number;
  /** Height of the iPad popover anchor. */
  height?: number;
}

export interface PrintResult {
  /** Whether the print job was successfully submitted. */
  success: boolean;
}

export interface CanPrintOptions {
  /** URI of the item to check (file://, res://, base64://). */
  uri?: string;
}

export interface CanPrintResult {
  /** Whether the device can print (the specified item). */
  available: boolean;
}

export interface PrintableTypesResult {
  /** List of printable UTI types. */
  types: string[];
}

export interface PickOptions {
  /** UI positioning options for iPad popover. */
  ui?: UIOptions;
}

export interface PickResult {
  /** The URL of the selected printer, or undefined if cancelled. */
  url?: string;
}
