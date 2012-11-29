require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Taucs < Formula
  homepage ''
  url 'http://www.tau.ac.il/~stoledo/taucs/2.2/taucs.tgz'
  version '2.2'
  sha1 '9f86bd091d42cad308b5137914fb7aa564bd0aae'

  depends_on 'openblas'
  depends_on 'lapack'
  depends_on 'metis'
  
  def patches
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    
    #system "mv external/lib/darwin/libf2c.a external/lib/darwin/unused_libf2c.a"
    
    system "./configure"
    
    system "make"
    
    lib.install 'lib/darwin/libtaucs.a'

#    system "./configure", "--disable-debug", "--disable-dependency-tracking",
#                          "--prefix=#{prefix}"
#    # system "cmake", ".", *std_cmake_args
#    system "make install" # if this fails, try separate make/make install steps
  end
end

__END__
diff --git a/config/darwin.mk b/config/darwin.mk
index 2cc57cf..7ca8077 100644
--- a/config/darwin.mk
+++ b/config/darwin.mk
@@ -4,16 +4,21 @@
 OBJEXT=.o
 LIBEXT=.a
 EXEEXT= 
-F2CEXT=.c
+#F2CEXT=.c
+F2CEXT=.f
 PATHSEP=/
 DEFFLG=-D
 
-#CC        = gcc
-CFLAGS    = -O3 -faltivec
+CC        = /usr/bin/gcc
+#CFLAGS    = -O3 -faltivec
+CFLAGS    = -O3
 COUTFLG   = -o ./
 
-FC        = $(CC)
-FFLAGS    = $(CFLAGS)
+#FC        = $(CC)
+#FFLAGS    = $(CFLAGS)
+FC        = /usr/local/bin/gfortran
+#FFLAGS    = -ff2c -O3 -g -fno-second-underscore -Wall 
+FFLAGS    = -O3 -g -fno-second-underscore -Wall 
 FOUTFLG   = $(COUTFLG)
 
 LD        = $(CC) 
@@ -26,11 +31,13 @@ AOUTFLG   =
 RANLIB    = ranlib
 RM        = rm -rf
 
-LIBBLAS   = -framework vecLib
-LIBLAPACK = 
-LIBMETIS  = -Lexternal/lib/darwin -lmetis
+#LIBBLAS   = -framework vecLib
+LIBBLAS   = -L/usr/local/opt/openblas/lib -lopenblas
+LIBLAPACK = -L/usr/local/opt/lapack/lib -llapack
+LIBMETIS  = -L/usr/local/opt/metis/lib -lmetis
 
-LIBF77 = -Lexternal/lib/darwin -lf2c
+#LIBF77 = -Lexternal/lidarwin -lf2c
+LIBF77 = -L/usr/local/opt/gfortran/lib/gcc/i686-apple-darwin11/4.2.1/x86_64 -lgfortran
 # crypto is for ftime, which is used by the timing routines
 # the documentation says its in libcompat, but on my system
 # there is no libcompat, but libcrypto provides it
diff --git a/configurator/taucs_config.c b/configurator/taucs_config.c
index 8bcdadc..091676a 100755
--- a/configurator/taucs_config.c
+++ b/configurator/taucs_config.c
@@ -241,8 +241,8 @@ void emit_configfile(char* configuration_name)
     sprintf(name,"%s%c%s",  configdir,pathsep,ostype);
 
   if (win32) {
-    mkdir(configdir);
-    mkdir(name);
+    mkdir(configdir,0777);
+    mkdir(name,0777);
   }
   else {
     mkdir(configdir,0777);
@@ -300,8 +300,8 @@ void emit_makefile(char* configuration_name)
     sprintf(name,"%s%c%s",  configdir,pathsep,ostype);
 
   if (win32) {
-    mkdir(configdir);
-    mkdir(name);
+    mkdir(configdir,0777);
+    mkdir(name,0777);
   }
   else {
     mkdir(configdir,0777);
diff --git a/configure b/configure
index caeef13..58113d9 100755
--- a/configure
+++ b/configure
@@ -1,5 +1,7 @@
 #!/bin/sh 
 
+OSTYPE="darwin"
+
 # The first task is to figure out OSTYPE.
 # In most cases it is set automatically before
 # the user's shell begins, but sometimes it is