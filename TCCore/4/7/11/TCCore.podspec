Pod::Spec.new do |s|
  s.name         = "TCCore"
  s.version      = "4.7.11"
  s.homepage     = "https://github.com/TagCommander/pods/tree/master/TCCore"
  s.license      = { :type => 'proprietary', :text => <<-LICENSE
                        Copyright 2013 - present Commanders Act. All rights reserved.
                      LICENSE
                   }
  s.author       = { "Commanders Act" => "support@commandersact.com" }
  s.summary      = "TagCommander pod"
  s.description  = <<-DESC
           Go to https://github.com/TagCommander/pods/tree/master/TCCore for more details
                   DESC
  s.platform     = :ios, '8.0'
  s.source   = { :http => "https://github.com/TagCommander/pods/raw/master/TCCore/4/7/11/TCCore.zip" }
  s.preserve_paths      = 'TCCore.xcframework'
  #s.public_header_files = 'TCCore.framework/Headers/*.h'
  s.vendored_frameworks = 'TCCore.xcframework'
end