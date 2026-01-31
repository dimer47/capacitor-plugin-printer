package com.nichedev.capacitor.printer

import android.os.Bundle
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.print.PageRange
import android.print.PrintAttributes
import android.print.PrintDocumentAdapter

class PrintProxy(
    private val delegate: PrintDocumentAdapter,
    private val callback: () -> Unit
) : PrintDocumentAdapter() {

    override fun onLayout(
        oldAttributes: PrintAttributes?,
        newAttributes: PrintAttributes,
        cancellationSignal: CancellationSignal?,
        callback: LayoutResultCallback,
        extras: Bundle?
    ) {
        delegate.onLayout(oldAttributes, newAttributes, cancellationSignal, callback, extras)
    }

    override fun onWrite(
        pages: Array<out PageRange>,
        destination: ParcelFileDescriptor,
        cancellationSignal: CancellationSignal?,
        callback: WriteResultCallback
    ) {
        delegate.onWrite(pages, destination, cancellationSignal, callback)
    }

    override fun onStart() {
        delegate.onStart()
        super.onStart()
    }

    override fun onFinish() {
        delegate.onFinish()
        super.onFinish()
        callback()
    }
}
