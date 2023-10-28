//
//  DataModel.swift
//  MyCricInfo
//


import Foundation

// MARK: - DataModel
struct DataModel: Codable {
    let matchdetail: Matchdetail?
    let teams: [String: Team]?

    enum CodingKeys: String, CodingKey {
        case matchdetail = "Matchdetail"
        case teams = "Teams"
    }
}

// MARK: - Matchdetail
struct Matchdetail: Codable {
    let teamHome, teamAway: String?
    let match: Match?
    let series: Series?
    let venue: Venue?
    let officials: Officials?
    let weather, tosswonby, status, statusID: String?
    let playerMatch, result, winningteam, winmargin: String?
    let equation: String?

    enum CodingKeys: String, CodingKey {
        case teamHome = "Team_Home"
        case teamAway = "Team_Away"
        case match = "Match"
        case series = "Series"
        case venue = "Venue"
        case officials = "Officials"
        case weather = "Weather"
        case tosswonby = "Tosswonby"
        case status = "Status"
        case statusID = "Status_Id"
        case playerMatch = "Player_Match"
        case result = "Result"
        case winningteam = "Winningteam"
        case winmargin = "Winmargin"
        case equation = "Equation"
    }
}

// MARK: - Match
struct Match: Codable {
    let livecoverage, id, code, league: String?
    let number, type, date, time: String?
    let offset, daynight: String?

    enum CodingKeys: String, CodingKey {
        case livecoverage = "Livecoverage"
        case id = "Id"
        case code = "Code"
        case league = "League"
        case number = "Number"
        case type = "Type"
        case date = "Date"
        case time = "Time"
        case offset = "Offset"
        case daynight = "Daynight"
    }
}

// MARK: - Officials
struct Officials: Codable {
    let umpires, referee: String?

    enum CodingKeys: String, CodingKey {
        case umpires = "Umpires"
        case referee = "Referee"
    }
}

// MARK: - Series
struct Series: Codable {
    let id, name, status, tour: String?
    let tourName: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case status = "Status"
        case tour = "Tour"
        case tourName = "Tour_Name"
    }
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

// MARK: - Team
struct Team: Codable {
    let nameFull, nameShort: String?
    let players: [String: Player]?

    enum CodingKeys: String, CodingKey {
        case nameFull = "Name_Full"
        case nameShort = "Name_Short"
        case players = "Players"
    }
}

// MARK: - Player
struct Player: Codable {
    let position, nameFull: String?
    let batting: Batting?
    let bowling: Bowling?
    let iscaptain, iskeeper: Bool?

    enum CodingKeys: String, CodingKey {
        case position = "Position"
        case nameFull = "Name_Full"
        case batting = "Batting"
        case bowling = "Bowling"
        case iscaptain = "Iscaptain"
        case iskeeper = "Iskeeper"
    }
}

// MARK: - Batting
struct Batting: Codable {
    let style: Style?
    let average, strikerate, runs: String?

    enum CodingKeys: String, CodingKey {
        case style = "Style"
        case average = "Average"
        case strikerate = "Strikerate"
        case runs = "Runs"
    }
}

enum Style: String, Codable {
    case lhb = "LHB"
    case rhb = "RHB"
}

// MARK: - Bowling
struct Bowling: Codable {
    let style, average, economyrate, wickets: String?

    enum CodingKeys: String, CodingKey {
        case style = "Style"
        case average = "Average"
        case economyrate = "Economyrate"
        case wickets = "Wickets"
    }
}

// MARK: - Style
enum BowlingStyle: String {
    case ob = "Off Break"
    case lb = "Leg Break"
    case lbg = "Leg Break Googly"
    case slc = "Slow Left Arm Chinaman"
    case slo = "Slow Left Arm Orthodox"
    case rf = "Right Arm Fast"
    case rfm = "Right Arm Fast Medium"
    case rmf = "Right Arm Fast Medium "
    case rm = "Right Arm Medium"
    case lf = "Left Arm Fast"
    case lfm = "Left Arm Fast Medium"
    case lmf = "Left Arm Fast Medium "
    case lm = "Left Arm Medium"
    
    var displayName: String {
        switch self {
        case .ob:
            return "Off Break"
        case .lb:
            return "Leg Break"
        case .lbg:
            return "Leg Break Googly"
        case .slc:
            return "Slow Left Arm Chinaman"
        case .slo:
            return "Slow Left Arm Orthodox"
        case .rf:
            return "Right Arm Fast"
        case .rfm:
            return "Right Arm Fast Medium"
        case .rmf:
            return "Right Arm Fast Medium"
        case .rm:
            return "Right Arm Medium"
        case .lf:
            return "Left Arm Fast"
        case .lfm:
            return "Left Arm Fast Medium"
        case .lm:
            return "Left Arm Medium"
        case .lmf:
            return "Left Arm Fast Medium"
        }
    }
    
    static func bowlingStyle(for displayName: String) -> BowlingStyle? {
        return BowlingStyle(rawValue: displayName)
    }
}
