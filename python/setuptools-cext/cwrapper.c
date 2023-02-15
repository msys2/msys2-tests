#include <Python.h>

static PyObject *
helloworld(PyObject *self, PyObject *args)
{
    printf("Hello World\n");
    Py_RETURN_NONE;
}

static PyMethodDef
myMethods[] = {
    { "helloworld", helloworld, METH_NOARGS, "Prints Hello World" },
    { NULL, NULL, 0, NULL }
};

static struct PyModuleDef cwrapper = {
    PyModuleDef_HEAD_INIT,
    "cwrapper",
    "Test Module",
    -1,
    myMethods
};

PyMODINIT_FUNC
PyInit_cwrapper(void)
{
    return PyModule_Create(&cwrapper);
}
