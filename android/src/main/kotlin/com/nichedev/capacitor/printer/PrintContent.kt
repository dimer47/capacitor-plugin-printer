package com.nichedev.capacitor.printer

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.BufferedInputStream
import java.io.InputStream
import java.net.URLConnection

class PrintContent private constructor(ctx: Context) {

    enum class ContentType { PLAIN, HTML, IMAGE, PDF, UNSUPPORTED }

    private val io = PrintIO(ctx)

    companion object {
        fun getContentType(path: String?, context: Context, forcedMimeType: String? = null): ContentType {
            return PrintContent(context).getContentType(path, forcedMimeType)
        }

        fun open(path: String, context: Context): BufferedInputStream? {
            return PrintContent(context).open(path)
        }

        fun decode(path: String, context: Context): Bitmap? {
            return PrintContent(context).decode(path)
        }
    }

    private fun getContentType(path: String?, forcedMimeType: String? = null): ContentType {
        if (path == null || path.isEmpty() || path.trimStart().startsWith("<")) {
            return ContentType.HTML
        }

        if (path.matches(Regex("^[a-z0-9]+://.+"))) {
            val mime: String? = forcedMimeType ?: if (path.startsWith("base64:")) {
                try {
                    URLConnection.guessContentTypeFromStream(io.openBase64(path))
                } catch (e: Exception) {
                    return ContentType.UNSUPPORTED
                }
            } else {
                URLConnection.guessContentTypeFromName(path)
            }

            return when (mime) {
                "image/bmp", "image/png", "image/jpeg", "image/jpeg2000",
                "image/jp2", "image/gif", "image/x-icon",
                "image/vnd.microsoft.icon", "image/heif" -> ContentType.IMAGE
                "application/pdf" -> ContentType.PDF
                else -> ContentType.UNSUPPORTED
            }
        }

        return ContentType.PLAIN
    }

    private fun open(path: String): BufferedInputStream? {
        val stream: InputStream? = when {
            path.startsWith("res:") -> io.openResource(path)
            path.startsWith("file:///") -> io.openFile(path)
            path.startsWith("file://") -> io.openAsset(path)
            path.startsWith("base64:") -> io.openBase64(path)
            else -> null
        }
        return stream?.let { BufferedInputStream(it) }
    }

    private fun decode(path: String): Bitmap? {
        return when {
            path.startsWith("res:") -> io.decodeResource(path)
            path.startsWith("file:///") -> io.decodeFile(path)
            path.startsWith("file://") -> io.decodeAsset(path)
            path.startsWith("base64:") -> io.decodeBase64(path)
            else -> BitmapFactory.decodeFile(path)
        }
    }
}
