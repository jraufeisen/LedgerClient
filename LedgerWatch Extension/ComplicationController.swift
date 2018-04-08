//
//  ComplicationController.swift
//  LedgerWatch Extension
//
//  Created by Johannes on 11.03.18.
//  Copyright © 2018 Johannes Raufeisen. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Ti meline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let textProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "€")
        let emptyTextProvider = CLKTextProvider.localizableTextProvider(withStringsFileTextKey: "")

      //  var template: CLKComplicationTemplate?
        
        if complication.family == .utilitarianSmallFlat {
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = textProvider
            handler(template)
        } else if complication.family == .utilitarianSmall {
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = textProvider
            handler(template)
        } else if complication.family == .utilitarianLarge {
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = textProvider
            handler(template)
        } else if complication.family == .circularSmall {
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = textProvider
            template.fillFraction = 1.0
            template.ringStyle = .open
            handler(template)
        
        } else if complication.family == .modularSmall {
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = textProvider
            template.line2TextProvider = emptyTextProvider
            handler(template)
        } else if complication.family == .modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = textProvider
            template.body1TextProvider = emptyTextProvider
            template.body2TextProvider = emptyTextProvider

            handler(template)
        } else if complication.family == .extraLarge {
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = textProvider
            template.line2TextProvider = emptyTextProvider

            handler(template)

        }
        
        
    }
    
}
