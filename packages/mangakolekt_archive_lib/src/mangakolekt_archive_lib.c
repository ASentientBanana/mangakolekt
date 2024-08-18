#include "mangakolekt_archive_lib.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zip.h>
#include <zipconf.h>

FFI_PLUGIN_EXPORT intptr_t unzip_cover(char *zip_path, char *output) {
  zip_t *archive = zip_open(zip_path, 0, 0);

  if (!archive) {
    printf("failed to open zip archive");
    return EXIT_FAILURE;
  }
  int number_of_entries = zip_get_num_entries(archive, 0);

  for (int i = 0; i < number_of_entries; i++) {
    zip_stat_t statbuf;
    if (zip_stat_index(archive, i, 0, &statbuf) == 0) {

      const char *filename = statbuf.name;
      const int size = statbuf.size;

      // as a test if its a file will be checking if zize > 0
      if (size <= 0) {
        continue;
      }
      printf("GETTING %s\n", filename);
      printf("GETTING %u\n", size);

      zip_file_t *f = zip_fopen_index(archive, i, ZIP_FL_UNCHANGED);
      if (f == NULL) {
        printf("File is null");
        break;
      }
      char *content = malloc(size);
      zip_int64_t bytesRead;
      if (zip_fread(f, content, size) == 0) {
        printf("Couldnt read zip file\n");
        break;
      }

      FILE *output_file = fopen(output, "wb");
      printf("Content size: %lu \n", sizeof content);
      if (output_file) {
        fwrite(content, sizeof content, size, output_file);
        fclose(output_file);
      }
      break;
    }
  }

  zip_close(archive);
  printf("Number of entries:: %u \n", number_of_entries);
  return EXIT_SUCCESS;
}
