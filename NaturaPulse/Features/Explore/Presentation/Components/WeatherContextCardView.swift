//
//  WeatherContextCardView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// Shows the current environmental context (temperature, humidity, and
/// air quality) at the selected location as neutral background
/// information. This is presented as context only — never as a claim
/// that weather or air quality causes any observed species behavior.
struct WeatherContextCardView: View {
    let weather: WeatherContext

    private var temperatureText: String? {
        weather.temperatureCelsius.map { "\(Int($0.rounded()))°" }
    }

    private var metrics: [String] {
        var items: [String] = []
        if let humidity = weather.relativeHumidity {
            items.append("Humidity \(Int(humidity.rounded()))%")
        }
        if let pm25 = weather.pm25 {
            items.append("PM2.5 \(Int(pm25.rounded()))")
        }
        return items
    }

    private var metricsText: String {
        metrics.joined(separator: " · ")
    }

    private var temperatureSpoken: String {
        guard let celsius = weather.temperatureCelsius else { return "" }
        return "\(Int(celsius.rounded())) degrees Celsius"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            if let temperatureText {
                Text(temperatureText)
                    .font(AppTypography.title())
                    .foregroundStyle(AppColor.primaryText)
                    .accessibilityLabel("Temperature")
                    .accessibilityValue(temperatureSpoken)
            }

            if !metrics.isEmpty {
                Text(metricsText)
                    .font(AppTypography.body())
                    .foregroundStyle(AppColor.secondaryText)
                    .accessibilityLabel(metrics.joined(separator: ", "))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    WeatherContextCardView(
        weather: WeatherContext(
            temperatureCelsius: 28,
            relativeHumidity: 74,
            precipitation: 0,
            weatherCode: 1,
            pm25: 18,
            capturedAt: .now
        )
    )
    .padding(AppSpacing.md)
    .background(AppColor.background)
}
