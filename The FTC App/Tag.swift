//
//  Tag.swift
//  The FTC App
//
//  Created by Jining Liu on 8/16/25.
//

import SwiftUI

enum Tag: Codable {
    case firstHq
    case s
    case lm
    case lt
    case qt
    case sq
    case ic
    case cmp
    case custom(String, String)

    init(eventType: Int, eventTypeName: String) {
        switch eventType {
        case 0:
            self = .s
        case 1:
            self = .lm
        case 2:
            self = .qt
        case 3:
            self = .lt
        case 4:
            self = .cmp
        case 7:
            self = .sq
        default:
            self = .custom(eventTypeName, eventTypeName)
        }
    }

    var tag: String {
        switch self {
        case .firstHq:
            "FIRST HQ"
        case .s:
            "S"
        case .lm:
            "LM"
        case .lt:
            "LT"
        case .qt:
            "QT"
        case .sq:
            "SQ"
        case .ic:
            "IC"
        case .cmp:
            "CMP"
        case .custom(let tag, _):
            tag
        }
    }

    var description: String {
        switch self {
        case .firstHq:
            "FIRST HQ"
        case .s:
            "Scrimmage"
        case .lm:
            "League Meet"
        case .lt:
            "League Tournament"
        case .qt:
            "Qualifying Tournament"
        case .sq:
            "Super Qualifier"
        case .ic:
            "Innovation Challenge"
        case .cmp:
            "Championship"
        case .custom(_, let description):
            description
        }
    }

    var foregroundColor: Color {
        switch self {
        case .firstHq, .s, .lm, .lt, .qt, .sq, .ic, .cmp, .custom(_, _):
            .white
        }
    }

    var backgroundColor: Color {
        switch self {
        case .firstHq:
            .red
        case .s, .lm, .lt, .qt, .sq, .ic, .cmp:
            .blue
        case .custom(_, _):
            .orange
        }
    }

    var label: some View {
        Text(.init(self.tag))
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(self.foregroundColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(self.backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
    }
}
