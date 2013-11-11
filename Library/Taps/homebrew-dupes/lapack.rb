require 'formula'

class Lapack < Formula
  homepage 'http://www.netlib.org/lapack/'
  url 'http://www.netlib.org/lapack/lapack-3.4.2.tgz'
  sha1 '93a6e4e6639aaf00571d53a580ddc415416e868b'

  depends_on :fortran
  depends_on 'cmake' => :build

  keg_only :provided_by_osx

  def install
# <<<<<<< HEAD
# THIS WAS MY VERSION BEFOREHAND, REPLACING IT WITH THE MAVERICKS VERSION..
    # Copy over make.inc, to load in configuration for this platform
    mv "INSTALL/make.inc.gfortran", "make.inc"
    #system "mv INSTALL/make.inc.gfortran make.inc"
    #system "make", "PREFIX=#{prefix}", "install"
    system "make", "lib"
    lib.install "liblapack.a"
# THIS IS WHERE THE CHANGEOVER IS
# =======
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", "-DBUILD_SHARED_LIBS:BOOL=ON", "-DLAPACKE:BOOL=ON"
	system "make", "install"
# END OF CHANGES
# >>>>>>> 0f2ae693a85e8cc3814bfea35096071ad4ee82da
  end
end
