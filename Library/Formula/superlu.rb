require 'formula'

class Superlu < Formula
  homepage ''
  url 'http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_4.3.tar.gz'
  version '4.3'
  sha1 'd2863610d8c545d250ffd020b8e74dc667d7cbdd'

  def patches
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "make"
    
	system "cp lib/libsuperlu_4.3.a lib/libsuperlu.a"
	system "cp TESTING/libtmglib.a lib/libtmglib.a"
    lib.install 'lib/libsuperlu.a'
    lib.install 'lib/libtmglib.a'
  end
end

__END__
diff -rupN make.inc make.inc
--- ./make.inc	2012-11-27 19:19:38.000000000 +0000
+++ ./make.inc	2012-11-28 01:43:18.000000000 +0000
@@ -16,25 +16,20 @@
 #
 #  The machine (platform) identifier to append to the library names
 #
-PLAT = _linux
+PLAT = _mac_x
 
 #
 #  The name of the libraries to be created/linked to
 #
-SuperLUroot	= $(HOME)/Codes/SuperLU/SuperLU_4.3
+#SuperLUroot	= $(HOME)/Codes/SuperLU_4.3
+SuperLUroot	=	../
 SUPERLULIB   	= $(SuperLUroot)/lib/libsuperlu_4.3.a
-TMGLIB       	= libtmglib.a
-
-## BLASLIB   	= $(SuperLUroot)/lib/libblas.a
 
 BLASDEF 	= -DUSE_VENDOR_BLAS
-BLASLIB 	= -L$(HOME)/lib/GotoBLAS -lgoto
-
-## ATLAS BLAS causes single-precision to fail
-#BLASLIB   	= -L/usr/lib/atlas -lblas
-## This BLAS causes single-precision to fail the test in SuperLU
-#BLASLIB 	= -L/usr/lib -lblas
+#BLASLIB   	= $(SuperLUroot)/lib/libblas.a
+BLASLIB   	= -lBLAS
 
+TMGLIB       	= libtmglib.a
 LIBS		= $(SUPERLULIB) $(BLASLIB)
 
 #
@@ -46,20 +41,21 @@ ARCHFLAGS    = cr
 RANLIB       = ranlib
 
 CC           = gcc
-CFLAGS       = -DPRNTlevel=0 -O3
+CFLAGS       = -O2 
 NOOPTS       = 
-FORTRAN	     = g77
-FFLAGS       = -O2
+#FORTRAN	     = /Applications/Absoft/bin/f90
+FORTRAN	     = gfortran
+FFLAGS       = -O3 -cpu:g5 -YEXT_NAMES=LCS -s -YEXT_SFX=_
 LOADER       = $(CC)
 LOADOPTS     =
 
 #
 #  C preprocessor defs for compilation for the Fortran interface
-#  (-DNoChange, -DAdd_, -DAdd__, or -DUpCase)
+#  (-DNoChange, -DAdd_, -DUpCase, or -DAdd__)
 #
 CDEFS        = -DAdd_
 #
 # The directory in which Matlab is installed
 #
-MATLAB	     = /usr/sww/matlab
+MATLAB	     = /Applications/Matlab/MATLAB_R2012a.app/bin/matlab
 

