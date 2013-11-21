require 'formula'

class Nfft < Formula
  homepage 'http://www-user.tu-chemnitz.de/~potts/nfft'
  url 'http://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.2.3.tar.gz'
  sha1 '9338cb0afbd5f4ddaf2bc5f9be5329ad61dc2ded'

  depends_on 'fftw'
  depends_on 'gcc45'

  fails_with :clang do
    build 425
    cause "dot+=conj(x[k])*x[k] compound not yet supported by clang"
  end

  def install
	ENV['CC'] = '/usr/local/bin/gcc-4.5'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install" 
  end

end
