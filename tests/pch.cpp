// We've had some patches for PCH related things, so make sure we don't break them
// https://github.com/msys2/MINGW-packages/pull/11582

int main (void) {
    if (std::regex_search ("foobar", std::regex(".*") ))
        return 0;
    return 1;
}
