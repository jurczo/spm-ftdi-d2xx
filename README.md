# FTDI D2xx wrapper

Swift PM wrapper around the FTDI D2xx driver. 

Example usage:
```swift
var count : DWORD = 0

var status = FT_CreateDeviceInfoList(&count)
guard status == FT_OK else { fatalError() }
guard count > 0 else { fatalError() }

var devs = [FT_DEVICE_LIST_INFO_NODE](repeating: .init(), count: Int(count))

status = FT_GetDeviceInfoList(&devs, &count)
guard status == FT_OK else { fatalError() }

for dev in devs { /* eg print(String(describing: dev.SerialNumber)) */ }
```
