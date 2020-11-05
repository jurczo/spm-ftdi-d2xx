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

#### Libraries
### [FTDI D2xx](https://www.ftdichip.com/Drivers/FTDriverLicenceTerms.htm)
<details>
<summary>EULA</summary>

Full FTDI D2xx license lives [here](https://www.ftdichip.com/Drivers/FTDriverLicenceTerms.htm).

</details>

### [semver](https://ghub.io/semver)

<details>
<summary>ISC</summary>

The ISC License

Copyright (c) Isaac Z. Schlueter and Contributors

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

</details>


#### License
The MIT License (MIT)

Copyright (c) 2020 Tomáš Michalek
See the file "LICENSE" for the full license governing this code.
