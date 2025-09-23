package main

/*
const char* hello() { return "Hello from C"; }
*/
import "C"
import "fmt"

func main() {
    fmt.Println(C.GoString(C.hello()))
}
