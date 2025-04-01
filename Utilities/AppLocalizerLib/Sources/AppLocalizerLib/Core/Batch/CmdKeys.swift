//
//  CmdKeys.swift
//  AppLocalizerLib
//
//  Created by mc on 2025.03.31.
//

import Foundation

enum Cmd: String {
    case CLEAR_ALL
    case DIFF_TSV_A
    case DIFF_TSV_B
    case DIFF_XML_A
    case DIFF_XML_B
    case DO_DIFF_KEYS
    case OUTPUT_LANG_TSV
    case SOURCE_ENUS_TSV /// `English_US`
    case SOURCE_ENUS_DROID /// `English_US`
    case SOURCE_LANG_DROID
    case SOURCE_ENUS_APPLE /// `English_US`
    case SOURCE_LANG_APPLE
    case DO_EXPORT_TSV
    case SOURCE_STRINGS
    case SOURCE_TSV_INCLUDE
    case BASE_JSON_DIR
    case BASE_TSV_INCLUDE
    case BASE_XML_URL
    case URL_FRAGMENTS_TSV
    case URL_TOPICS_TSV
    case SOURCE_XML
    case OUTPUT_APPLE
    case OUTPUT_DROID
    case DIRNAME_OUTPUT_NORMAL
    case DO_IMPORT_TSV
    case DO_INSET_BATCH
    case DO_NORMALIZE_BATCH
    case LOGGER_FILENAME
    case LOGGER_LEVEL_
    case LOGGER_LEVEL_ALL
    case LOGGER_LEVEL_VERBOSE
    case LOGGER_LEVEL_DEBUG
    case LOGGER_LEVEL_INFO
    case LOGGER_LEVEL_WARNING
    case LOGGER_LEVEL_ERROR
    case LOGGER_LEVEL_OFF
    case QUIT
    // :NEW:
    case REBASE_TSV
    case INTAKE_SPLIT_TSV
    // :OBSOLETE:
    case DIFF_XLIFF_A
    case DIFF_XLIFF_B
    case SOURCE_XLIFF
    
    var txt: String {
        rawValue
    }
    
}
