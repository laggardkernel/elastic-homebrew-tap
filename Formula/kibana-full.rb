class KibanaFull < Formula
  arch = Hardware::CPU.intel? ? "x86_64" : "aarch64"
  version "7.17.17"
  url "https://artifacts.elastic.co/downloads/kibana/kibana-#{version}-darwin-#{arch}.tar.gz?tap=elastic/homebrew-tap"
  revision 1

  homepage "https://www.elastic.co/products/kibana"
  desc "Analytics and search dashboard for Elasticsearch"
  conflicts_with "kibana"

  def install
    libexec.install(
      "bin",
      "config",
      "data",
      "node",
      "node_modules",
      "package.json",
      "plugins",
      "src",
      "x-pack",
    )

    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?
      bin.install libexec/"bin"/f
    end
    bin.env_script_all_files(libexec/"bin", { "KIBANA_PATH_CONF" => etc/"kibana", "DATA_PATH" => var/"lib/kibana/data" })

    cd libexec do
      packaged_config = IO.read "config/kibana.yml"
      IO.write "config/kibana.yml", "path.data: #{var}/lib/kibana/data\n" + packaged_config
      inreplace "config/kibana.yml", %r{#\s*pid\.file: /run/.+$}, "pid.file: #{var}/run/kibana/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
      rm_rf "data"
    end
  end

  def post_install
    (var/"lib/kibana/data").mkpath
    (var/"run/kibana").mkpath
    (prefix/"plugins").mkdir
  end

  def caveats; <<~EOS
    Config: #{etc}/kibana/
    pid.file: #{var}/run/kibana/kibana.pid
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{opt_prefix}/plugins before upgrading, and copy it into the
    new keg location after upgrading.
  EOS
  end

  service do
    run [opt_bin/"kibana"]
    working_dir var
    log_path var/"log/kibana.log"
    error_log_path var/"log/kibana.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end
