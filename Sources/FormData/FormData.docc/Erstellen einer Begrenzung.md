# Erstellen einer Begrenzung

Erstellen einer eigenen Begrenzung für `name/value` Paare.

## Overview

Wie auch bei anderen Multipart-Typen werden die einzelnen Teile (engl. *parts*)
mit Hilfe einer Begrenzung (engl. *boundary*) getrennt.
Die Begrenzung ist zusammengesetzt aus CRLF (Carriage Return und Line Feed), „----“
und einem Wert. Dieser Wert ist frei wählbar. Zu beachten ist allerdings folgendes:

Begrenzungen…
- dürfen nicht innerhalb des gekapselten Materials erscheinen
- dürfen nicht länger als 70 Zeichen sein,
wobei die beiden führenden Bindestriche nicht mitgezählt werden.

Zum Beispiel:
```swift
let uniqueID = UUID().uuidString
let boundaryValue = "MeineBegrenzung\(uniqueID)"
let boundary = "--\(boundaryValue)\r\n"
```
- Important: `FormData(boundary:)` fügt den `CRLF` automatisch hinzu.
Dieser sollte deswegen **nicht** selbst hinzugefügt werden.

## Topics

### Group

- ``FormData``
