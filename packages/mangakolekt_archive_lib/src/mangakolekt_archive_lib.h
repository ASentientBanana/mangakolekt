#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <zip.h>
#include <zipconf.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#define FFI_PLUGIN_EXPORT

FFI_PLUGIN_EXPORT intptr_t unzip_cover(char *zip_path, char *output);
