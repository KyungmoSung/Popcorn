//
//  Language.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation

class Language: Codable {
    static var allCases: [Language] = []
    
    let code: ISO_639_1
    let name: String?
    
    private enum CodingKeys : String, CodingKey{
        case code = "iso_639_1"
        case name
    }
    
    init(code: ISO_639_1) {
        self.code = code
        self.name = code.name
    }
}

enum ISO_639_1: String, CaseIterable ,Codable {
    case xx
    case aa
    case af
    case ak
    case an
    case `as`
    case av
    case ae
    case ay
    case az
    case ba
    case bm
    case bi
    case bo
    case br
    case ca
    case cs
    case ce
    case cu
    case cv
    case kw
    case co
    case cr
    case cy
    case da
    case de
    case dv
    case dz
    case eo
    case et
    case eu
    case fo
    case fj
    case fi
    case fr
    case fy
    case ff
    case gd
    case ga
    case gl
    case gv
    case gn
    case gu
    case ht
    case ha
    case sh
    case hz
    case ho
    case hr
    case hu
    case ig
    case io
    case ii
    case iu
    case ie
    case ia
    case id
    case ik
    case `is`
    case it
    case jv
    case ja
    case kl
    case kn
    case ks
    case kr
    case kk
    case km
    case ki
    case rw
    case ky
    case kv
    case kg
    case ko
    case kj
    case ku
    case lo
    case la
    case lv
    case li
    case ln
    case lt
    case lb
    case lu
    case lg
    case mh
    case ml
    case mr
    case mg
    case mt
    case mo
    case mn
    case mi
    case ms
    case my
    case na
    case nv
    case nr
    case nd
    case ng
    case ne
    case nl
    case nn
    case nb
    case no
    case ny
    case oc
    case oj
    case or
    case om
    case os
    case pi
    case pl
    case pt
    case qu
    case rm
    case ro
    case rn
    case ru
    case sg
    case sa
    case si
    case sk
    case sl
    case se
    case sm
    case sn
    case sd
    case so
    case st
    case es
    case sq
    case sc
    case sr
    case ss
    case su
    case sw
    case sv
    case ty
    case ta
    case tt
    case te
    case tg
    case tl
    case th
    case ti
    case to
    case tn
    case ts
    case tk
    case tr
    case tw
    case ug
    case uk
    case ur
    case uz
    case ve
    case vi
    case vo
    case wa
    case wo
    case xh
    case yi
    case za
    case zu
    case ab
    case zh
    case ps
    case am
    case ar
    case bg
    case cn
    case mk
    case el
    case fa
    case he
    case hi
    case hy
    case en
    case ee
    case ka
    case pa
    case bn
    case bs
    case ch
    case be
    case yo
    case unknown
    
    public init(from decoder: Decoder) throws {
      self = try ISO_639_1(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
    
    var name: String {
        switch self {
        case .xx: return "No Language"
        case .aa: return "Afar"
        case .af: return "Afrikaans"
        case .ak: return "Akan"
        case .an: return "Aragonese"
        case .`as`: return "Assamese"
        case .av: return "Avaric"
        case .ae: return "Avestan"
        case .ay: return "Aymara"
        case .az: return "Azerbaijani"
        case .ba: return "Bashkir"
        case .bm: return "Bambara"
        case .bi: return "Bislama"
        case .bo: return "Tibetan"
        case .br: return "Breton"
        case .ca: return "Catalan"
        case .cs: return "Czech"
        case .ce: return "Chechen"
        case .cu: return "Slavic"
        case .cv: return "Chuvash"
        case .kw: return "Cornish"
        case .co: return "Corsican"
        case .cr: return "Cree"
        case .cy: return "Welsh"
        case .da: return "Danish"
        case .de: return "German"
        case .dv: return "Divehi"
        case .dz: return "Dzongkha"
        case .eo: return "Esperanto"
        case .et: return "Estonian"
        case .eu: return "Basque"
        case .fo: return "Faroese"
        case .fj: return "Fijian"
        case .fi: return "Finnish"
        case .fr: return "French"
        case .fy: return "Frisian"
        case .ff: return "Fulah"
        case .gd: return "Gaelic"
        case .ga: return "Irish"
        case .gl: return "Gallegan"
        case .gv: return "Manx"
        case .gn: return "Guarani"
        case .gu: return "Gujarati"
        case .ht: return "Haitian; Haitian Creole"
        case .ha: return "Hausa"
        case .sh: return "Serbo-Croatian"
        case .hz: return "Herero"
        case .ho: return "Hiri Motu"
        case .hr: return "Croatian"
        case .hu: return "Hungarian"
        case .ig: return "Igbo"
        case .io: return "Ido"
        case .ii: return "Yi"
        case .iu: return "Inuktitut"
        case .ie: return "Interlingue"
        case .ia: return "Interlingua"
        case .id: return "Indonesian"
        case .ik: return "Inupiaq"
        case .`is`: return "Icelandic"
        case .it: return "Italian"
        case .jv: return "Javanese"
        case .ja: return "Japanese"
        case .kl: return "Kalaallisut"
        case .kn: return "Kannada"
        case .ks: return "Kashmiri"
        case .kr: return "Kanuri"
        case .kk: return "Kazakh"
        case .km: return "Khmer"
        case .ki: return "Kikuyu"
        case .rw: return "Kinyarwanda"
        case .ky: return "Kirghiz"
        case .kv: return "Komi"
        case .kg: return "Kongo"
        case .ko: return "Korean"
        case .kj: return "Kuanyama"
        case .ku: return "Kurdish"
        case .lo: return "Lao"
        case .la: return "Latin"
        case .lv: return "Latvian"
        case .li: return "Limburgish"
        case .ln: return "Lingala"
        case .lt: return "Lithuanian"
        case .lb: return "Letzeburgesch"
        case .lu: return "Luba-Katanga"
        case .lg: return "Ganda"
        case .mh: return "Marshall"
        case .ml: return "Malayalam"
        case .mr: return "Marathi"
        case .mg: return "Malagasy"
        case .mt: return "Maltese"
        case .mo: return "Moldavian"
        case .mn: return "Mongolian"
        case .mi: return "Maori"
        case .ms: return "Malay"
        case .my: return "Burmese"
        case .na: return "Nauru"
        case .nv: return "Navajo"
        case .nr: return "South Ndebele"
        case .nd: return "North Ndebele"
        case .ng: return "Ndonga"
        case .ne: return "Nepali"
        case .nl: return "Dutch"
        case .nn: return "Norwegian Nynorsk"
        case .nb: return "Norwegian Bokmål"
        case .no: return "Norwegian"
        case .ny: return "Chichewa; Nyanja"
        case .oc: return "Occitan"
        case .oj: return "Ojibwa"
        case .or: return "Oriya"
        case .om: return "Oromo"
        case .os: return "Ossetian; Ossetic"
        case .pi: return "Pali"
        case .pl: return "Polish"
        case .pt: return "Portuguese"
        case .qu: return "Quechua"
        case .rm: return "Raeto-Romance"
        case .ro: return "Romanian"
        case .rn: return "Rundi"
        case .ru: return "Russian"
        case .sg: return "Sango"
        case .sa: return "Sanskrit"
        case .si: return "Sinhalese"
        case .sk: return "Slovak"
        case .sl: return "Slovenian"
        case .se: return "Northern Sami"
        case .sm: return "Samoan"
        case .sn: return "Shona"
        case .sd: return "Sindhi"
        case .so: return "Somali"
        case .st: return "Sotho"
        case .es: return "Spanish"
        case .sq: return "Albanian"
        case .sc: return "Sardinian"
        case .sr: return "Serbian"
        case .ss: return "Swati"
        case .su: return "Sundanese"
        case .sw: return "Swahili"
        case .sv: return "Swedish"
        case .ty: return "Tahitian"
        case .ta: return "Tamil"
        case .tt: return "Tatar"
        case .te: return "Telugu"
        case .tg: return "Tajik"
        case .tl: return "Tagalog"
        case .th: return "Thai"
        case .ti: return "Tigrinya"
        case .to: return "Tonga"
        case .tn: return "Tswana"
        case .ts: return "Tsonga"
        case .tk: return "Turkmen"
        case .tr: return "Turkish"
        case .tw: return "Twi"
        case .ug: return "Uighur"
        case .uk: return "Ukrainian"
        case .ur: return "Urdu"
        case .uz: return "Uzbek"
        case .ve: return "Venda"
        case .vi: return "Vietnamese"
        case .vo: return "Volapük"
        case .wa: return "Walloon"
        case .wo: return "Wolof"
        case .xh: return "Xhosa"
        case .yi: return "Yiddish"
        case .za: return "Zhuang"
        case .zu: return "Zulu"
        case .ab: return "Abkhazian"
        case .zh: return "Mandarin"
        case .ps: return "Pushto"
        case .am: return "Amharic"
        case .ar: return "Arabic"
        case .bg: return "Bulgarian"
        case .cn: return "Cantonese"
        case .mk: return "Macedonian"
        case .el: return "Greek"
        case .fa: return "Persian"
        case .he: return "Hebrew"
        case .hi: return "Hindi"
        case .hy: return "Armenian"
        case .en: return "English"
        case .ee: return "Ewe"
        case .ka: return "Georgian"
        case .pa: return "Punjabi"
        case .bn: return "Bengali"
        case .bs: return "Bosnian"
        case .ch: return "Chamorro"
        case .be: return "Belarusian"
        case .yo: return "Yoruba"
        case .unknown: return ""
        }
    }
}
