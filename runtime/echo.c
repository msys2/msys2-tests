#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stringapiset.h>
#include <processenv.h>
#include <assert.h>

/**
 * Takes a zero terminated wide string.
 *
 * Returns a malloced utf-8 encoded, null terminated string, or NULL on error.
 */
static char *encodeUtf8(const wchar_t *wstr)
{
    int nbytes = 0;

    nbytes = WideCharToMultiByte(
        CP_UTF8, WC_ERR_INVALID_CHARS,
        wstr, -1, NULL, 0, NULL, NULL);
    if (nbytes == 0)
    {
        return NULL;
    }

    char *str = malloc(nbytes);
    if (str == NULL)
    {
        return NULL;
    }

    if (WideCharToMultiByte(
            CP_UTF8, WC_ERR_INVALID_CHARS,
            wstr, -1, str, nbytes, NULL, NULL) == 0)
    {
        free(str);
        return NULL;
    }

    return str;
}

/**
 * Prints a zero terminated list of process environment variables as utf-8. The
 * first item is the number of the following list items as a string.
 */
static void printEnvVars()
{
    _setmode(1, _O_BINARY);

    LPWCH vars = GetEnvironmentStringsW();
    LPWCH countVars = vars;
    size_t count = 0;

    while (*countVars)
    {
        count++;
        countVars += wcslen(countVars) + 1;
    }
    printf("%d%c", count, '\0');

    while (*vars)
    {
        char *value = encodeUtf8(vars);
        assert(value != NULL);
        printf("%s%c", value, '\0');
        free(value);
        vars += wcslen(vars) + 1;
    }
}

/**
 * Prints a zero terminated list of process arguments as utf-8. The first item
 * is the number of the following list items as a string.
 */
static void printArgs(int argc, wchar_t **argv)
{
    _setmode(1, _O_BINARY);

    printf("%d%c", argc, '\0');
    for (int i = 0; i < argc; i++)
    {
        char *value = encodeUtf8(argv[i]);
        assert(value != NULL);
        printf("%s%c", value, '\0');
        free(value);
    }
}

/**
 * This tool prints all process arguments and environment variables in a format
 * parsable by other programs, including Unicode support.
 *
 * This can be used to test path and env var conversion in cygwin for example.
 */
int wmain(int argc, wchar_t **argv)
{
    printArgs(argc, argv);
    printEnvVars();
    return 0;
}
