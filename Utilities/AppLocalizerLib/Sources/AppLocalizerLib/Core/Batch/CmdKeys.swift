//
//  CmdKeys.swift
//  AppLocalizerLib
//
//  Created by mc on 2025.03.31.
//

import Foundation

enum Cmd: String {
    case DIFF_TSV_A
    case DIFF_TSV_B
    case DIFF_XML_A
    case DIFF_XML_B
    case DO_DIFF_KEYS
    case OUTPUT_LANG_TSV
    
    case SOURCE_ENUS_TSV   /// WORKFLOW: ExportFromApps.md `English_US`
    case SOURCE_ENUS_APPLE /// WORKFLOW: ExportFromApps.md `English_US`
    case SOURCE_ENUS_DROID /// WORKFLOW: ExportFromApps.md `English_US`
    case SOURCE_LANG_DROID
    case SOURCE_LANG_APPLE

    case DO_EXPORT_TSV
    case SOURCE_STRINGS
    
    case SOURCE_TSV_INCLUDE /// WORKFLOW: normalize. catenated array
    case BASE_JSON_DIR
    case BASE_TSV_INCLUDE   /// WORKFLOW: normalize. catenated array
    case BASE_XML_URL
    case URL_FRAGMENTS_TSV
    case URL_TOPICS_TSV
    case SOURCE_XML
    case OUTPUT_APPLE
    case OUTPUT_DROID
    case OUTPUT_CACHE_LOCAL_DIR
    case DO_IMPORT_TSV
    case DO_INSET_BATCH
    case DO_NORMALIZE_BATCH
    
    // --- EXECUTIVE ---
    case QUIT
    case CLEAR_ALL
    
    // --- LOGGER ---
    case LOGGER_FILENAME
    case LOGGER_LEVEL_
    case LOGGER_LEVEL_ALL
    case LOGGER_LEVEL_VERBOSE
    case LOGGER_LEVEL_DEBUG
    case LOGGER_LEVEL_INFO
    case LOGGER_LEVEL_WARNING
    case LOGGER_LEVEL_ERROR
    case LOGGER_LEVEL_OFF
    
    // --- CHANGESET: MULTI ---
    case CS_BASE_TSV
    case CS_DELETE_KEY
    case CS_INSERT_KEY
    case CS_LANG_INPUT_TSV
    case CS_LANG_OUTPUT_TSV
    /// Use `English_US` Change Set to generate all Language Change Sets
    /// `English_US` file may be only a subset of the full TSV file
    /// Outputs to review: language delta TSV, language full TSV, multi changeset TSV
    case DO_CHANGESET_APPLY_TSV
    case DO_CHANGESET_WRITE_MULTI_TSV
    
    /// Use Language Change Sets intake to update Language TSV files
    /// LANG intake MULTI file contains the change set for 1 or more LANG files
    case DO_CHANGESET_INTAKE_MULTI
    
    // --- :OBSOLETE: ---
    case DIFF_XLIFF_A /// :OBSOLETE:
    case DIFF_XLIFF_B /// :OBSOLETE:
    case SOURCE_XLIFF /// :OBSOLETE:
    
    var txt: String {
        rawValue
    }
    
}
