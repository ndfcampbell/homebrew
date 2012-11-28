require 'formula'

class Gl2ps < Formula
  homepage ''
  url 'http://geuz.org/gl2ps/src/gl2ps-1.3.8.tgz'
  version '1.3.8'
  sha1 '792e11db0fe7a30a4dc4491af5098b047ec378b1'

  depends_on 'cmake' => :build
  depends_on 'libpng'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                      "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end
end
