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
            val buf = ByteArray(input.available().coerceAtLeast(8192))
            var bytesRead: Int

            input.mark(Int.MAX_VALUE)

            while (input.read(buf).also { bytesRead = it } > 0) {
                output.write(buf, 0, bytesRead)
            }

            input.reset()
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
        val absPath = path.substring(7)
        return try {
            FileInputStream(absPath)
        } catch (e: Exception) {
            null
        }
    }

    fun decodeFile(path: String): Bitmap? {
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

    fun openResource(path: String): InputStream {
        val resPath = path.substring(6)
        val resId = getResId(resPath)
        return context.resources.openRawResource(resId)
    }

    fun decodeResource(path: String): Bitmap? {
        val data = path.substring(9)
        val bytes = Base64.decode(data, 0)
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
    }

    fun openBase64(path: String): InputStream {
        val data = path.substring(9)
        val bytes = Base64.decode(data, 0)
        return ByteArrayInputStream(bytes)
    }

    fun decodeBase64(path: String): Bitmap? {
        val data = path.substring(9)
        val bytes = Base64.decode(data, 0)
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
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

        val resName = fileName.substring(0, fileName.lastIndexOf('.'))
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
