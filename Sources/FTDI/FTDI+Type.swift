// Copyright © 2020 Gatema a.s. All rights reserved.
// See the file "LICENSE" for the full license governing this code.

import Foundation

/// Making the `FTDIDeviceType` play nice with Swift reflection
///
///  As Streamer actually only supports the `232R` or `232H` all others are marked as unsupported.
///  event if they could work in theory. It may be expanded in future.
extension FTDIDeviceType : CustomStringConvertible {
    public var description: String {
        switch self {
        case .R232: return "232R"
        case .H232: return "232H"
        default: return "unsupported"
        }
    }
}
