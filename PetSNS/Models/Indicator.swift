//
//  Indicator.swift
//  PetSNS
//
//  Created by 大西玲音 on 2021/08/31.
//

import PKHUD

enum IndicatorType {
    case progress
    case success
    case error
}

struct Indicator {
    
    func flash(_ type: IndicatorType,
               completion: @escaping () -> Void) {
        let type = convertIndicatorType(from: type)
        HUD.flash(type,
                  onView: nil,
                  delay: 0) { _ in
            completion()
        }
    }
    
    func show(_ type: IndicatorType) {
        let type = convertIndicatorType(from: type)
        HUD.show(type)
    }
    
    func hide() {
        HUD.hide()
    }
    
    private func convertIndicatorType(from type: IndicatorType) -> HUDContentType {
        switch type {
            case .progress: return .progress
            case .success: return .success
            case .error: return .error
        }
    }
    
}
