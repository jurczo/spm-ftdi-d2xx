# FTDI D2xx wrapper

> As the wrapper had linker issues for now, it is converted into Framework
> with the plans to return back to pure Swift PM after some investigation.

Swift PM wrapper around the FTDI D2xx driver. 

Example usage:
```swift
import FTDI

let candidates = try! FTDI.availableCandidates()
guard let serial = candidates.first?.serialNumber else {
   fatalError()
}
guard let handle = try? FTDI.open(using: .serialNumber, value: serial) else {
   fatalError()
}

do {
   try configure(handle, using: Configuration())
   let info = try describe(handle)
   print(info)
   
   try write(handle, string: "Hello, world!")
   let data = try read(handle, length: 30)
   
   try close(handle)
} catch {
    print(error)
    fatalError()
}
```
