Pod::Spec.new do |s|
  s.name         = "XDVerticalGradientColorSlider"
  s.version      = "0.1.0"
  s.summary      = "一个竖直方向渐变色的颜色滑竿选择器. A vertical gradient color picker."


  s.description  = <<-DESC
                   一个竖直方向渐变色的颜色滑竿选择器
                   A vertical gradient color picker.

  s.homepage     = "https://github.com/suxinde2009/XDVerticalGradientColorSlider"
  s.license      = "MIT"
  s.author             = { "suxinde2009" => "suxinde2009@126.com" }
  s.social_media_url   = "https://github.com/suxinde2009"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/suxinde2009/XDVerticalGradientColorSlider.git", :tag => "#{s.version}" }



  s.source_files  = "Classes", "Src/**/*.{h,m}"
  s.exclude_files = "Src/Exclude"
  s.public_header_files = "Src/**/*.h"

  s.resources = "Src/Resources/**.*"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  s.requires_arc = true
  s.dependency 'Masonry', '~> 1.0.2'

end
