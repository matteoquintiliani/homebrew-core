class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.1.9.tgz"
  sha256 "d2d25267460573aeb7e4850734e273a3700e371645dedc76342df632a444da48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c36ac86ee82e62ccaa4d0a568df8c9d38151a3c4e6a7570d6a3bab635ed4439"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Make the bottles uniform
    inreplace_file = libexec/"lib/node_modules/zx/node_modules/@types/node/process.d.ts"
    inreplace inreplace_file, "/usr/local/bin", "#{HOMEBREW_PREFIX}/bin"
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
