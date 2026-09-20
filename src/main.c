#include <stdio.h>

#include "slink.h"

static void usage(const char *prog)
{
    fprintf(stderr, "usage: %s <target> <linkpath>\n", prog);
}

int main(int argc, char *argv[])
{
    if (argc != 3) {
        usage(argv[0]);
        return 2;
    }

    opts_t opts = {0, 0};

    if (make_symlink(argv[1], argv[2], opts) != 0) {
        perror("samelink");
        return 1;
    }

    return 0;
}
