#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern uint64_t day01(const char* data);

int main(int argc, char* argv[]) {
	// if (argc < 2) {
    //     fprintf(stderr, "Usage: ./%s <data_file>", argv[0]);
	// 	return 1;
	// }

    // fixed input file
    if (argc > 1) {
        fprintf(stderr, "Expected no arguments\n");
        return 1;
    }
    (void) argv;

	char * buffer = 0;
	long length;
	FILE * f = fopen("input.txt"/*argv[1]*/, "rb");
    if (!f) {
        perror("Could not open the file");
        return 1;
    }
	fseek (f, 0, SEEK_END);
    length = ftell (f);
    fseek (f, 0, SEEK_SET);

    buffer = malloc (length+1);
    if (!buffer) {
        fprintf(stderr, "Could not alloc mem\n");
        return 1;
    }

    fread (buffer, 1, length, f);
    fclose (f);
    buffer[length] = '\0';

    // guesstimate, you may need to adopt this for very large files
	uint64_t res = day01(buffer);
	printf("Part 1: %u\n", (uint32_t) (res>>32));
	printf("Part 2: %u\n", (uint32_t) res);
	free(buffer);
	return 0;
}
