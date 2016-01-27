Pod::Spec.new do |spec|
spec.name = "ringcentral"
spec.version = "1.0.0"
spec.summary = "RingCentral Swift SDK supoorting Swift 2.0"
spec.description = <<-DESC
This RingCentral Swift SDK 2.0 has been made to make Swift/ios development easier for developers who are using RingCentral Platform's suite of APIs. It handles authentication and the token lifecycle, makes API requests, and parses API responses. This documentation will help you get set up and going with some example API calls.
DESC
spec.homepage = "http://developers.ringcentral.com"
spec.platform = :osx, "10.10"
spec.platform = :ios, "8.0"
spec.ios.deployment_target = "8.0"
spec.osx.deployment_target = "10.10"
spec.license = "MIT"
spec.authors = { "Anil Kumar" => "anil.kumar@ringcentral.com" }
spec.source = { :git => "https://github.com/anilkumarbp/ringcentral-swiftv2.0.git", :tag => "1.0.0" }
spec.source_files = "src/src/Core","src/src/Http","src/src/Platform","src/src/Subscription"
spec.exclude_files = "Classes/Exclude"
spec.requires_arc = true
spec.dependency 'PubNub', '~>4.0'
spec.dependency 'CryptoSwift'
spec.dependency 'SwiftyJSON'
end
