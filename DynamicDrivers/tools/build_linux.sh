ARCH=$1
COMPILER=$2
PROJECT=$3

if [ "$ARCH" == "" ] ; then
	echo "First parameter needs to be set to the architecture (x86 or x64)"
	exit 1
fi

if [ "$COMPILER" == "" ] ; then 
	echo "Second parameter needs to be set to gcc version"
	exit 1
fi

if [ "$COMPILER" == "gcc44" ] ; then 
	COMPILER_PATH=/usr
	EXTRA_CXX_OPTIONS=
fi

if [ "$COMPILER" == "gcc51" ] ; then 
	COMPILER_PATH=/usr/local/gcc-5.1
	EXTRA_CXX_OPTIONS=-D_GLIBCXX_USE_CXX11_ABI=0 
fi

if [ "$COMPILER" == "gcc83" ] ; then 
	COMPILER_PATH=/usr/local/gcc-8.3
	EXTRA_CXX_OPTIONS=
fi

if [ "$COMPILER_PATH" == "" ] ; then 
	echo "Unknown gcc version $COMPILER"
	exit 1
fi

if [ "$PROJECT" == "" ] ; then
	echo "Third parameter needs to be set to project name, (gdal_webp)"
	exit 1
fi

CURRENT_DIR=$(pwd)
cd ../root
CROCKETT_ROOT=$(pwd)
cd $CURRENT_DIR
cd ../$PROJECT

function really_build(){
	make -f ./GNUmakefile CROCKETT_ROOT=$CROCKETT_ROOT ARCH=$ARCH CONF=$1 COMPILER_PATH=$COMPILER_PATH EXTRA_CXX_OPTIONS=$EXTRA_CXX_OPTIONS clean
	make -f ./GNUmakefile CROCKETT_ROOT=$CROCKETT_ROOT ARCH=$ARCH CONF=$1 COMPILER_PATH=$COMPILER_PATH EXTRA_CXX_OPTIONS=$EXTRA_CXX_OPTIONS
}
function build(){
	really_build Release
	really_build Debug
}

build 

cd $CURRENT_DIR
