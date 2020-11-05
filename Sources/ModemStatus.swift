// Copyright © 2020 Tomáš Michalek
// See the file "LICENSE" for the full license governing this code.

public struct ModemStatus {
    public let cts : Bool
    public let dsr : Bool
    public let ring : Bool
    public let rlsd : Bool

    public init(cts: Bool, dsr: Bool, ring: Bool, rlsd: Bool) {
        self.cts = cts
        self.dsr = dsr
        self.ring = ring
        self.rlsd = rlsd
    }
}
