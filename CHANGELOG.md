## ChangeLog

#### Version 2.0.4 (24.08.2026)
- [__change__:] Le paquet et le produit SPM sont renommés `Dimer47CapacitorPluginPrinter` pour correspondre à la dérivation du CLI Capacitor depuis `@dimer47/capacitor-plugin-printer` (#3, merci __keremtiryaki__)
- [bugfix:] Corrige la résolution du paquet lors d'une intégration iOS via Swift Package Manager

> __Note :__ le produit exposé passe de `PrinterPlugin` à `Dimer47CapacitorPluginPrinter`. Une référence écrite en dur telle que `.product(name: "PrinterPlugin", ...)` doit être mise à jour. Les intégrations CocoaPods ne sont pas concernées.

#### Version 2.0.3 (29.05.2026)
- [bugfix:] Corrige la configuration ProGuard (Android)

#### Version 2.0.2 (01.02.2026)
- [bugfix:] Supprime les espaces superflus lors des tests de contenu HTML

#### Version 2.0.1 (01.02.2026)
- [__change__:] `pm.print` utilise désormais des paramètres de callback explicites

#### Version 2.0.0 (31.01.2026)
- [__change__:] Migration de Cordova vers Capacitor, réécriture complète en Swift, Kotlin et TypeScript
- [__change__:] Requiert iOS 15 ou plus récent


#### Version 0.8.0 (01.03.2019)
- Most parts of the code has been rewritten
- Added support for Android 8+
- Added support for iOS 10+
- Added support for the browser platform
- Added support for header and foooter
- Added support to print PDF files, images, Base64 encoded images
- And many more, see the new README

#### Version 0.7.3 (19.12.2016)
- Fixed incompatibility with Android KitKat (4.4)

#### Version 0.7.2 (03.08.2016)
- [__change__:] Changed plugin ID to `cordova-plugin-printer`
- [__change__:] Plugin requires Android KitKat or newer
- [__change__:] `isAvailable` returns false if no enabled service can be found (Android)
- [feature:] New `pick` interface to pick a printer for future usage
- [feature:] Support for Windows10 platform (Thanks to #cristi-badila)
- [enhancement:] `isAvailable` returns count of available services (Android)
- [enhancement:] `print` returns bool value to indicate the result
- [enhancement:] Added missing `duplex` support (Android)
- [__change__:] `duplex` requires a string (`none`, `long` or `short`)
- [enhancement:] Support for `border`, `hidePageRange`, `hideNumberOfCopies` and `hidePaperFormat` (iOS specific)

#### Version 0.7.1 (23.04.2015)
- [bugfix:] `isAvailable` does not block the main thread anymore.
- [bugfix:] iPad+iOS8 incompatibility (Thanks to __zmagyar__)
- [enhancement:] Print-View positioning on iPad
- [enhancement:] Send direct to printer when printerId: is specified.

#### Version 0.7.0 (12.09.2014)
- Android Printing Framework support
- [__change__:] Renamed `isServiceAvailable` to `isAvailable`
- [enhancement:] New print options like `name`, `landscape` or `duplex`
- [enhancement:] Ability to print remote content via URI
- [enhancement:] Callback support