#include <errno.h>
#include <stdio.h>
#include <unistd.h>

#include "slink.h"

int make_symlink(const char *target, const char *linkpath, opts_t opts)
{
    if (target == NULL || linkpath == NULL) {
        errno = EINVAL;
        return -1;
    }

    (void)opts.force;

    if (symlink(target, linkpath) != 0) {
        return -1; /* errno preserved for perror in main */
    }

    if (opts.verbose) {
        printf("'%s' -> '%s'\n", linkpath, target);
    }

    return 0;
}
