import { WebPlugin } from '@capacitor/core';

import type {
  PrinterPlugin,
  PrintOptions,
  PrintResult,
  PrintHtmlOptions,
  PrintPdfOptions,
  PrintBase64Options,
  PrintFileOptions,
  PrintWebViewOptions,
  CanPrintOptions,
  CanPrintResult,
  PrintableTypesResult,
  PickOptions,
  PickResult,
} from './definitions';

export class PrinterWeb extends WebPlugin implements PrinterPlugin {
  async print(options: PrintOptions): Promise<PrintResult> {
    if (options.content) {
      const printWindow = window.open('', '_blank');
      if (printWindow) {
        printWindow.document.write(options.content);
        printWindow.document.close();
        printWindow.focus();
        printWindow.print();
        printWindow.close();
      } else {
        window.print();
      }
    } else {
      window.print();
    }
    return { success: true };
  }

  async printHtml({ html, ...opts }: PrintHtmlOptions): Promise<PrintResult> {
    return this.print({ content: html, ...opts });
  }

  async printPdf(_options: PrintPdfOptions): Promise<PrintResult> {
    throw this.unimplemented('printPdf() is not available on web.');
  }

  async printBase64(_options: PrintBase64Options): Promise<PrintResult> {
    throw this.unimplemented('printBase64() is not available on web.');
  }

  async printFile(_options: PrintFileOptions): Promise<PrintResult> {
    throw this.unimplemented('printFile() is not available on web.');
  }

  async printWebView(options?: PrintWebViewOptions): Promise<PrintResult> {
    return this.print({ ...options });
  }

  async canPrintItem(_options?: CanPrintOptions): Promise<CanPrintResult> {
    return { available: typeof window.print === 'function' };
  }

  async getPrintableTypes(): Promise<PrintableTypesResult> {
    return { types: [] };
  }

  async pick(_options?: PickOptions): Promise<PickResult> {
    throw this.unimplemented('pick() is not available on web.');
  }
}
