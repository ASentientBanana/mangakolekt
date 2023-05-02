// import 'dart:ffi';

// // Define the C functions you want to call using Dart's FFI library
// typedef zip_t = Pointer<Void>;
// typedef zip_file_t = Pointer<Void>;
// typedef zip_source_t = Pointer<Void>;

// typedef zip_open_func = zip_t Function(Pointer<Utf8>, Int32, Pointer<Int32>);


// typedef zip_fopen_index_func = zip_file_t Function(zip_t, Int64, Int32);
// typedef zip_fread_func = Int32 Function(zip_file_t, Pointer<Void>, Int32);
// typedef zip_fclose_func = Int32 Function(zip_file_t);
// typedef zip_source_buffer_func = zip_source_t Function(Pointer<Void>, Int64, Int32, Pointer<Int32>);
// typedef zip_source_free_func = Void Function(zip_source_t);

// // Load the shared library
// final lib = DynamicLibrary.open('libzip.so');

// // Get references to the C functions
// final zip_open = lib.lookupFunction<zip_open_func, zip_open_func>('zip_open');
// final zip_fopen_index = lib.lookupFunction<zip_fopen_index_func, zip_fopen_index_func>('zip_fopen_index');
// final zip_fread = lib.lookupFunction<zip_fread_func, zip_fread_func>('zip_fread');
// final zip_fclose = lib.lookupFunction<zip_fclose_func, zip_fclose_func>('zip_fclose');
// final zip_source_buffer = lib.lookupFunction<zip_source_buffer_func, zip_source_buffer_func>('zip_source_buffer');
// final zip_source_free = lib.lookupFunction<zip_source_free_func, zip_source_free_func>('zip_source_free');


// // Open the zip archive
// final archive = zip_open(path.toUtf8(), 0, nullptr);
// if (archive == nullptr) {
//   throw Exception('Failed to open archive');
// }

// // Locate the file in the archive
// final file = zip_fopen_index(archive, 0, 0);
// if (file == nullptr) {
//   zip_close(archive);
//   throw Exception('Failed to locate file in archive');
// }

// // Read the contents of the file
// final buffer = allocate<Uint8>(count: bufferSize);
// var bytesRead = zip_fread(file, buffer, bufferSize);
// while (bytesRead > 0) {
//   // Do something with the buffer
//   // ...

//   // Read the next chunk of data
//   bytesRead = zip_fread(file, buffer, bufferSize);
// }

// // Free the memory allocated for the buffer
// free(buffer);

// // Close the file and the archive
// zip_fclose(file);
// zip_close(archive);
