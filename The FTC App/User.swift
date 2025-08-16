//
//  User.swift
//  The FTC App
//
//  Created by Jining Liu on 8/8/25.
//

import Foundation
import SwiFTC

struct User: Codable, RawRepresentable {
    var name: String
    var team: FTCAPIV2Data.TeamListings.Team?

    init() {
        self.name = "Roboticist"
        self.team = nil
    }

    init(testing: Bool) {
        self.init()

        if !testing {
            return
        }

        self.name = "Roboticist"
        self.team = try! JSONDecoder().decode(
            FTCAPIV2Data.TeamListings.Team.self,
            from:
                "{\"teamNumber\":20240,\"displayTeamNumber\":\"20240\",\"nameFull\":\"Texas Workforce Commission&Westwood High School\",\"nameShort\":\"Slingshot\",\"city\":\"Austin\",\"stateProv\":\"TX\",\"country\":\"USA\",\"rookieYear\":2021,\"homeRegion\":\"USTX\",\"displayLocation\":\"Austin, TX, USA\"}"
                .data(using: .utf8)!
        )
    }

    typealias RawValue = String

    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let user = try? JSONDecoder().decode(User.self, from: data)
        else {
            return nil
        }
        self = user
    }

    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let string = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return string
    }
}
