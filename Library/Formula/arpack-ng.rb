require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class ArpackNg < Formula
  homepage 'http://forge.scilab.org/index.php/p/arpack-ng'
  url 'http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_3.1.2.tar.gz'
  version '3.1.2'
  sha1 'f5453e2d576f131890ca023e1d853e18920f9c3c'

  # depends_on 'cmake' => :build
  depends_on 'open-mpi'
  depends_on 'openblas'
  depends_on 'lapack'

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    
    ENV['LDFLAGS'] = '-L/usr/local/opt/lapack/lib'
    
    ENV.fortran

    # Include MPIF77, as the arpack-ng build process doesn't autodetect properly
    ENV['MPIF77'] = 'mpif77'
    
    configure_args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-shared"]
    configure_args << "--with-blas=openblas"
    configure_args << "--with-lapack=lapack"

    system "./configure", *configure_args

    system "make install"

#    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
#    system "make install" # if this fails, try separate make/make install steps
  end

#  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test arpack-ng`.
#    system "false"
#  end
end
