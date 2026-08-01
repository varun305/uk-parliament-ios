import Foundation
import StoreKit
import SwiftUI

/// Centralises the logic for deciding when to ask the user for an App Store review.
///
/// The goal is to only surface Apple's review prompt at a genuine peak of
/// satisfaction (e.g. after the user has looked up a member or constituency a
/// few times), never on first launch and never more than once per app version.
/// Apple additionally caps `requestReview` to at most three prompts per year, so
/// this class governs *when* we ask rather than whether the system honours it.
@MainActor
final class ReviewManager: ObservableObject {
    static let shared = ReviewManager()

    private let minimumLaunches = 3
    private let minimumSuccessMoments = 2
    private let minimumDaysSinceInstall = 3

    static let appStoreID = ""

    static var writeReviewURL: URL? {
        guard !appStoreID.isEmpty else { return nil }
        return URL(string: "https://apps.apple.com/app/id6474855011?action=write-review")
    }

    private enum Key {
        static let launchCount = "review.launchCount"
        static let successMomentCount = "review.successMomentCount"
        static let firstLaunchDate = "review.firstLaunchDate"
        static let lastPromptedVersion = "review.lastPromptedVersion"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }

    func recordLaunch() {
        defaults.set(defaults.integer(forKey: Key.launchCount) + 1, forKey: Key.launchCount)
        if defaults.object(forKey: Key.firstLaunchDate) == nil {
            defaults.set(Date().timeIntervalSince1970, forKey: Key.firstLaunchDate)
        }
    }

    func recordSuccessMoment() {
        defaults.set(defaults.integer(forKey: Key.successMomentCount) + 1, forKey: Key.successMomentCount)
    }

    private var shouldRequestReview: Bool {
        guard defaults.string(forKey: Key.lastPromptedVersion) != currentVersion else { return false }
        guard defaults.integer(forKey: Key.launchCount) >= minimumLaunches else { return false }
        guard defaults.integer(forKey: Key.successMomentCount) >= minimumSuccessMoments else { return false }

        let firstLaunch = defaults.double(forKey: Key.firstLaunchDate)
        guard firstLaunch > 0 else { return false }
        let daysSinceInstall = (Date().timeIntervalSince1970 - firstLaunch) / 86_400
        guard daysSinceInstall >= Double(minimumDaysSinceInstall) else { return false }

        return true
    }

    func requestReviewIfAppropriate(using requestReview: RequestReviewAction) {
        guard shouldRequestReview else { return }
        defaults.set(currentVersion, forKey: Key.lastPromptedVersion)
        requestReview()
    }
}
