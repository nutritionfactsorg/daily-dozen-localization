//
//  BatchChangeset.swift
//  AppLocalizerLib
//

import Foundation

struct BatchChangeset {
    static var shared = BatchChangeset()
    let logger = LogService.shared
    
    // accumulated changeset data
    
    /// `DO_CHANGESET_ENUS_TO_LANG`
    func doChangesetEnusToLang(baseListTsv: [URL], sourceListTsv: [URL], outputLangTsv: URL) {
        guard
            let baseTsv = baseListTsv.first, 
            let sourceTsv = sourceListTsv.first
        else {
            print(
            """
            \nERROR: doChangesetEnusToLang(…)
                baseListTsv.count != 1 … \(baseListTsv.count)
                sourceListTsv.count != 1 … \(sourceListTsv.count)\n
            """)
            return
        }
        
        // --- read & parse baseListTsv   -> baseSheet
        let baseSheet: TsvSheet =  TsvSheet(baseTsv)
        // --- read & parse sourceListTsv -> sourceSheet
        let sourceSheet: TsvSheet =  TsvSheet(sourceTsv)
        
        
        // --- base @@ sourceA            -> sourceB    -> write sourceB (&shadow)
        
        // --- sourceA .diff. sourceB     -> delta      -> write delta   (&shadow)
        
        // --- deltaList.append(delta)
        
    }

    /// `DO_CHANGESET_ENUS_TO_MULTI`
    func doChangesetEnusToMulti(baseListTsv: [URL], outputLangTsv: URL) {
        
    }

    /// `DO_CHANGESET_INTAKE_MULTI`
    func doChangesetIntakeMulti() {
        fatalError("doChangesetIntakeMulti() is not yet implemented.")
    }

}
