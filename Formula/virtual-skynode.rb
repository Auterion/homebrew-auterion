class VirtualSkynode < Formula
  include Language::Python::Virtualenv

  desc "Virtual Skynode simulates an Auterion Skynode for development purposes"
  homepage "https://auterion.com"
  url "https://dl.cloudsmith.io/public/auterion/public/raw/versions/0.0.15/virtual-skynode.tar.gz"
  sha256 "c3099f525b43985247e2e458b6683ef1ed79fccff69c19cb54fc74c9e9da7aa2"
  version "0.0.15"

  depends_on "qemu"
  depends_on "python3"

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("semver")
  
    # Manually copy the necessary binaries to the virtual environment
    libexec_bin = libexec/"bin"
    libexec_bin.install "virtual-skynode"
    libexec_bin.install "virtual-skynode-convert-rootfs"
  
    # Create wrapper scripts to ensure the virtual environment is activated
    (bin/"virtual-skynode").write_env_script libexec_bin/"virtual-skynode", PATH: "#{libexec_bin}:$PATH"
    (bin/"virtual-skynode-convert-rootfs").write_env_script libexec_bin/"virtual-skynode-convert-rootfs", PATH: "#{libexec_bin}:$PATH"
  
    # Create the share/virtual-skynode directory
    (share/"virtual-skynode").mkpath
  
    # Install the bzImage into the created directory
    (share/"virtual-skynode").install "bzImage"
  end
end