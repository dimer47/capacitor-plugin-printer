export interface PrinterPlugin {
  /**
   * Sends content to the printer.
   *
   * @param options - Print options including content and settings.
   * @returns A promise resolving with the print result.
   */
  print(options: PrintOptions): Promise<PrintResult>;

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
   * Values can be numbers (points) or strings with units ('1cm', '10mm', '0.5in').
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
   * Paper size configuration (iOS only).
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
  /** Cut length for roll-fed printers. */
  length?: string | number;
  /** Named paper size (e.g. 'A4'). */
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
