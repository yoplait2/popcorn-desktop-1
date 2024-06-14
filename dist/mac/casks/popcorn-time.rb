cask "popcorn-time" do
  version "0.5.1"

  if Hardware::CPU.intel?
    sha256 "da6d993651e57cc88296f93f928ffedac3027313af0eb447ff8ca7a12a60e06a"
    url "https://github.com/popcorn-official/popcorn-desktop/releases/download/v#{version}/Popcorn-Time-#{version}-osx64.zip"
  else
    sha256 "51f11fb0483983dd6c4baddf12938d8a85b8320e3499dbe12cbcf5e4146e7f74"
    url "https://github.com/popcorn-official/popcorn-desktop/releases/download/v#{version}/Popcorn-Time-#{version}-osxarm64.zip"
  end

  name "Popcorn Time"
  desc "BitTorrent client that includes an integrated media player"
  homepage "https://github.com/popcorn-official/popcorn-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: [:x86_64, :arm64]

  app "Popcorn-Time.app"

  uninstall quit: "com.nw-builder.Popcorn-Time"

  zap trash: [
    "~/Library/Application Support/Popcorn-Time",
    "~/Library/Preferences/com.nw-builder.Popcorn-Time.plist",
    "~/Library/Saved Application State/com.nw-builder.Popcorn-Time.savedState",
    "~/Library/Caches/Popcorn-Time",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.nw-builder.Popcorn-Time.sfl*",
    "~/Library/Application Support/configstore/popcorn-time.json"
  ]


  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-c", "/Applications/Popcorn-Time.app/"],
                   sudo: true
  end

end
