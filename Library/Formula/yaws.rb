require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'https://github.com/klacke/yaws/archive/yaws-1.97.tar.gz'
  sha1 'b280e8e181ec3ded73c6ba7fa0ec9ebf7af32b1a'
  head 'https://github.com/klacke/yaws.git'

  option "without-yapp", "Omit yaws applications"
  option '32-bit'

  depends_on 'erlang'
  depends_on 'autoconf' => :build

  # the default config expects these folders to exist
  skip_clean 'var/log/yaws'
  skip_clean 'lib/yaws/examples/ebin'
  skip_clean 'lib/yaws/examples/include'

  def install
    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    unless build.include? 'without-yapp'
      cd 'applications/yapp' do
        system "make"
        system "make install"
      end
    end

    # the default config expects these folders to exist
    (lib/'yaws/examples/ebin').mkpath
    (lib/'yaws/examples/include').mkpath

    (var/'log/yaws').mkpath
    (var/'yaws/www').mkpath
  end

  def test
    system bin/'yaws', '--version'
  end

end
