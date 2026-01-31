package com.nichedev.capacitor.printer

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import java.io.ByteArrayInputStream
import java.io.Closeable
import java.io.FileInputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream

class PrintIO(private val context: Context) {

    companion object {
        @Throws(IOException::class)
        fun copy(input: InputStream, output: OutputStream) {
            val buf = ByteArray(8192)
            var bytesRead: Int

            if (input.markSupported()) {
                input.mark(Int.MAX_VALUE)
            }

            while (input.read(buf).also { bytesRead = it } > 0) {
                output.write(buf, 0, bytesRead)
            }

            if (input.markSupported()) {
                try { input.reset() } catch (_: IOException) { }
            }
            close(output)
        }

        fun close(stream: Closeable) {
            try {
                stream.close()
            } catch (_: IOException) {
                // ignore
            }
        }
    }

    fun openFile(path: String): InputStream? {
        if (path.length <= 7) return null
        val absPath = path.substring(7)
        return try {
            FileInputStream(absPath)
        } catch (e: Exception) {
            null
        }
    }

    fun decodeFile(path: String): Bitmap? {
        if (path.length <= 7) return null
        val absPath = path.substring(7)
        return BitmapFactory.decodeFile(absPath)
    }

    fun openAsset(path: String): InputStream? {
        val resPath = path.replaceFirst("file:/", "public")
        return try {
            context.assets.open(resPath)
        } catch (e: Exception) {
            null
        }
    }

    fun decodeAsset(path: String): Bitmap? {
        val stream = openAsset(path) ?: return null
        val bitmap = BitmapFactory.decodeStream(stream)
        close(stream)
        return bitmap
    }

    fun openResource(path: String): InputStream? {
        if (path.length <= 6) return null
        val resPath = path.substring(6)
        val resId = getResId(resPath)
        if (resId == 0) return null
        return try { context.resources.openRawResource(resId) } catch (_: Exception) { null }
    }

    fun decodeResource(path: String): Bitmap? {
        if (path.length <= 6) return null
        val resPath = path.substring(6)
        val resId = getResId(resPath)
        if (resId == 0) return null
        return BitmapFactory.decodeResource(context.resources, resId)
    }

    fun openBase64(path: String): InputStream? {
        if (path.length <= 9) return null
        val data = path.substring(9)
        return try {
            val bytes = Base64.decode(data, 0)
            ByteArrayInputStream(bytes)
        } catch (_: Exception) { null }
    }

    fun decodeBase64(path: String): Bitmap? {
        if (path.length <= 9) return null
        val data = path.substring(9)
        return try {
            val bytes = Base64.decode(data, 0)
            BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        } catch (_: Exception) { null }
    }

    private fun getResId(resPath: String): Int {
        val res = context.resources
        val pkgName = context.packageName
        var dirName = "drawable"
        var fileName = resPath

        if (resPath.contains("/")) {
            dirName = resPath.substring(0, resPath.lastIndexOf('/'))
            fileName = resPath.substring(resPath.lastIndexOf('/') + 1)
        }

        val dotIndex = fileName.lastIndexOf('.')
        val resName = if (dotIndex > 0) fileName.substring(0, dotIndex) else fileName
        var resId = res.getIdentifier(resName, dirName, pkgName)

        if (resId == 0) {
            resId = res.getIdentifier(resName, "mipmap", pkgName)
        }

        if (resId == 0) {
            resId = res.getIdentifier(resName, "drawable", pkgName)
        }

        return resId
    }
}
