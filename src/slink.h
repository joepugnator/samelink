#ifndef SLINK_H
#define SLINK_H

/* Core symlink API 
 * Returns 0 on success, -1 on failure with errno set.
 */
typedef struct {
    int force;
    int verbose;
} opts_t;

int make_symlink(const char *target, const char *linkpath, opts_t opts);

#endif
