# This file was generated by GoReleaser. DO NOT EDIT.
class Ecctl < Formula
  desc "Elastic Cloud Control, the official Elastic Cloud and ECE command line interface"
  homepage "https://github.com/elastic/ecctl"
  version "1.14.0"

  if OS.mac?
    url "https://download.elastic.co/downloads/ecctl/1.14.0/ecctl_1.14.0_darwin_amd64.tar.gz", :using => CurlDownloadStrategy
    sha256 "749087e82a3927b8432f1257b248b85236d9f147775d3c66dbe4d5b7e6748690"
  elsif OS.linux?
    url "https://download.elastic.co/downloads/ecctl/1.14.0/ecctl_1.14.0_linux_amd64.tar.gz", :using => CurlDownloadStrategy
    sha256 "43c8c03353343c47bb67f90b7859fca9a634e82e049530328b4a0d8ce609c9c8"
  end

  def install
    bin.install "ecctl"
    system "#{bin}/ecctl", "generate", "completions", "-l", "#{var}/ecctl.auto"
  end

  def caveats; <<~EOS
    To get autocompletions working make sure to run "source <(ecctl generate completions)".
    If you prefer to add to your shell interpreter configuration file run, for bash or zsh respectively:
    * `echo "source <(ecctl generate completions)" >> ~/.bash_profile`
    * `echo "source <(ecctl generate completions)" >> ~/.zshrc`.
  EOS
  end

  test do
    system "#{bin}/ecctl version"
  end
end
