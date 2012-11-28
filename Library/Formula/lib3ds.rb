require 'formula'

class Lib3ds < Formula
  homepage ''
  url 'http://lib3ds.googlecode.com/files/lib3ds-1.3.0.zip'
  version '1.3.0'
  sha1 '544262eac73c1e4a1d77f0f1cbd90b990a996db8'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
end
