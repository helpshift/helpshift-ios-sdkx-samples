//
//  Language.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import Foundation

enum Language: String, CaseIterable {
    case custom
    case zh_CN
    case zh_SG
    case zh_HK
    case zh_TW
    case cs
    case nl
    case en
    case fr
    case de
    case iw
    case hu
    case `in`
    case it
    case ja
    case ko
    case pt_BR
    case ru
    case sl
    case es
    case th
    case tr
    case vi
    case ar
    case pl
    case no
    case sv
    case fi
    case ro
    case el
    case da
    case ms
    case sk
    case uk
    case ca
    case hr
    case hi
    case bn
    case bg
    case gu
    case kn
    case lv
    case ml
    case mr
    case pa
    case ta
    case te

    var title: String {
        switch self {
        case .custom:   return "Custom"
        case .zh_CN:    return "Chinese (Simplified) (China)"
        case .zh_SG:    return "Chinese (Simplified) (Singapore)"
        case .zh_HK:    return "Chinese (Traditional) (Hong Kong)"
        case .zh_TW:    return "Chinese (Traditional) (Taiwan)"
        case .cs:       return "Czech"
        case .nl:       return "Dutch"
        case .en:       return "English"
        case .fr:       return "French"
        case .de:       return "German"
        case .iw:       return "Hebrew"
        case .hu:       return "Hungarian"
        case .`in`:     return "Indonesian"
        case .it:       return "Italian"
        case .ja:       return "Japanese"
        case .ko:       return "Korean"
        case .pt_BR:    return "Portuguese"
        case .ru:       return "Russian"
        case .sl:       return "Slovenian"
        case .es:       return "Spanish"
        case .th:       return "Thai"
        case .tr:       return "Turkish"
        case .vi:       return "Vietnamese"
        case .ar:       return "Arabic"
        case .pl:       return "Polish"
        case .no:       return "Norwegian"
        case .sv:       return "Swedish"
        case .fi:       return "Finnish"
        case .ro:       return "Romanian"
        case .el:       return "Greek"
        case .da:       return "Danish"
        case .ms:       return "Malay"
        case .sk:       return "Slovak"
        case .uk:       return "Ukrainian"
        case .ca:       return "Catalan"
        case .hr:       return "Croatian"
        case .hi:       return "Hindi"
        case .bn:       return "Bengali"
        case .bg:       return "Bulgarian"
        case .gu:       return "Gujarati"
        case .kn:       return "Kannada"
        case .lv:       return "Latvian"
        case .ml:       return "Malayalam"
        case .mr:       return "Marathi"
        case .pa:       return "Punjabi"
        case .ta:       return "Tamil"
        case .te:       return "Telugu"
        }
    }
}
