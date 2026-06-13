flags=(-Iinclude -c -pthread -fvisibility=hidden -O2 -fpic -fPIC -DHX_LINUX -DHXCPP_M64 -O2 -fpic -ansi -std=standard -fgnu89-inline -fno-asm -fno-builtin -fhosted -ffreestanding -fopenmp -fopenmp-simd -fms-extensions -fsigned-bitfields -fsigned-char -funsigned-bitfields -funsigned-char -trigraphs -traditional -traditional-cpp -ffriend-injection -fno-elide-constructors -fno-enforce-eh-specs -fno-for-scope -fno-gnu-keywords -fno-implicit-templates -fno-nonansi-builtins -fnothrow-opt -fno-operator-names -fpermissive -fno-pretty-templates -fno-rtti -fsized-deallocation -ftemplate-depth=1024 -fno-threadsafe-statics -fuse-cxa-atexit -fno-weak -nostdinc++ -fvisibility-inlines-hidden -Wabi=8 -Wconversion-null -Wctor-dtor-privacy -Wdelete-non-virtual-dtor -Wmultiple-inheritance -Wnamespaces -Wnarrowing -Wnoexcept -Wnon-virtual-dtor -Wreorder -Weffc++ -Wstrict-null-sentinel -Wno-non-template-friend -Wold-style-cast -Woverloaded-virtual -Wsign-promo)
files=(./opengl/qglpixelbuffer.cpp ./opengl/qglshaderprogram.cpp ./opengl/gl2paintengineex/qglengineshadermanager.cpp ./opengl/gl2paintengineex/qpaintengineex_opengl2.cpp ./network/access/qnetworkreplyfileimpl.cpp ./network/access/qnetworkreply.cpp ./network/access/http2/huffman.cpp ./network/access/http2/http2frames.cpp ./network/ssl/qsslcontext_openssl.cpp ./network/ssl/qsslcertificateextension.cpp ./network/ssl/qsslcipher.cpp ./network/ssl/qsslkey_p.cpp ./network/ssl/qsslsocket_openssl.cpp ./network/ssl/qsslcertificate.cpp ./tools/moc/parser.cpp ./tools/moc/preprocessor.cpp ./tools/moc/generator.cpp ./tools/moc/main.cpp ./tools/uic/validator.cpp ./tools/uic/cpp/cppwritedeclaration.cpp ./tools/rcc/rcc.cpp ./tools/rcc/main.cpp)
while true; do
  output="\033[33m\033[1mg++ \033[37m"
  nbFlags=$(( (RANDOM % 16) + 12 ))
  for i in $(seq 1 $nbFlags); do
    flag=$(( RANDOM % ${#flags[@]} ))
    output="$output ${flags[$flag]}"
  done
  file=$(( RANDOM % ${#files[@]} ))
  output="$output ${files[$file]} -c $(echo ${files[$file]} | sed 's/.cpp$/.o/')"
  echo -e "$output"
  sleep $(( (RANDOM % 3) / ((RANDOM % 5) + 1) ))
done
