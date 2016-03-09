
Pod::Spec.new do |s|
  s.name             = "GoogleReverseGeoCode"
  s.version          = "0.1.0"
  s.summary          = "Reverse Geo coding using google api"


  s.description      = <<-DESC
This library helps you to reverse geo code for current location or custom location using google api.
                       DESC

  s.homepage         = "https://github.com/kaushaldream11/GoogleReverseGeoCode"
  s.license          = 'MIT'
  s.author           = { "”kaushaldream11”" => "kaushal.bisht@dream11.com" }
  s.source           = { :git => "https://github.com/kaushaldream11/GoogleReverseGeoCode.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'GoogleReverseGeoCode' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'CoreLocation'
end
