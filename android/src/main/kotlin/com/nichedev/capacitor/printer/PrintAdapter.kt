package com.nichedev.capacitor.printer

import android.os.Bundle
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.print.PageRange
import android.print.PrintAttributes
import android.print.PrintDocumentAdapter
import android.print.PrintDocumentInfo
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream

class PrintAdapter(
    private val jobName: String,
    private val pageCount: Int,
    private val input: InputStream,
    private val callback: () -> Unit
) : PrintDocumentAdapter() {

    override fun onLayout(
        oldAttributes: PrintAttributes?,
        newAttributes: PrintAttributes,
        cancellationSignal: CancellationSignal?,
        callback: LayoutResultCallback,
        extras: Bundle?
    ) {
        if (cancellationSignal?.isCanceled == true) {
            callback.onLayoutCancelled()
            return
        }

        val pdi = PrintDocumentInfo.Builder(jobName)
            .setContentType(PrintDocumentInfo.CONTENT_TYPE_DOCUMENT)
            .setPageCount(pageCount)
            .build()

        val changed = newAttributes != oldAttributes
        callback.onLayoutFinished(pdi, changed)
    }

    override fun onWrite(
        pages: Array<out PageRange>,
        destination: ParcelFileDescriptor,
        cancellationSignal: CancellationSignal?,
        callback: WriteResultCallback
    ) {
        if (cancellationSignal?.isCanceled == true) {
            callback.onWriteCancelled()
            return
        }

        val output = FileOutputStream(destination.fileDescriptor)

        try {
            PrintIO.copy(input, output)
        } catch (e: IOException) {
            callback.onWriteFailed(e.message)
            return
        } finally {
            PrintIO.close(output)
            try { destination.close() } catch (_: IOException) { }
        }

        callback.onWriteFinished(arrayOf(PageRange.ALL_PAGES))
    }

    override fun onFinish() {
        super.onFinish()
        PrintIO.close(input)
        callback()
    }
}
