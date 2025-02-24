Pod::Spec.new do |s|
  s.name         = "TCPrivacy"
  s.version      = "4.9.7"
  s.homepage     = "https://github.com/TagCommander/pods/tree/master/TCPrivacy"
  s.license      = { :type => 'proprietary', :text => <<-LICENSE
                        Copyright 2013 - present Commanders Act. All rights reserved.
                      LICENSE
                   }
  s.author       = { "Commanders Act" => "support@commandersact.com" }
  s.summary      = "TagCommander pod"
  s.description  = <<-DESC
           Go to https://github.com/TagCommander/pods/tree/master/TCPrivacy for more details
                   DESC
  s.platform     = :ios, '8.0'
  s.source   = { :http => "https://github.com/TagCommander/pods/raw/master/TCPrivacy/4/9/7/TCPrivacy.zip" }
  s.preserve_paths      = 'TCPrivacy.xcframework'
  #s.public_header_files = 'TCPrivacy.framework/Headers/*.h'
  s.vendored_frameworks = 'TCPrivacy.xcframework'
end