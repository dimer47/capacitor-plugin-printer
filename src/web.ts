import { WebPlugin } from '@capacitor/core';

import type {
  PrinterPlugin,
  PrintOptions,
  PrintResult,
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
