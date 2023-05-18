// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

print(Bundle.main.bundlePath)

let table = [
    "English_US": "Peanuts",
    "Bulgarian": "Фъстъци",
    "Catalan": "Cacauets",
    "Chinese_Simplified": "花生",
    "Chinese_Traditional": "花生",
    "Czech": "Arašídy",
    "French": "Cacahuètes",
    "German": "Erdnüsse",
    "Greek": "Φιστίκια",
    "Hebrew": "בוטנים",
    "Italian": "Arachidi",
    "Polish": "Orzeszki ziemne",
    "Portuguese_Brazil": "Amendoins",
    "Portuguese_Portugal": "Amendoim",
    "Romanian": "Arahide",
    "Russian": "Арахис",
    "Slovak": "Arašidy",
    "Spanish": "Cacahuete",
]

for key in table.keys {
    let value = table[key]!
    
    let s = """
    key_droid\tkey_apple\tbase_value\tlang_value\tbase_note\tlang_note
    food_info_types_nuts.7\tdozeNuts.Variety.Text.7\tPeanuts\t\(value)\t\t
    """
    
    try? s.write(toFile: "\(key).v05.tsv", atomically: true, encoding: .utf8)
}
