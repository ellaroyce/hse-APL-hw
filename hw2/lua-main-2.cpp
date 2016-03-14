extern "C" {
#include <Python.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
}

// import inspect

// py_eval = eval

static PyObject * lua_eval(PyObject* module, PyObject* args)
{
    PyObject* a = PyTuple_GetItem(args, 0);
    const char* b = PyUnicode_AsUTF8(a);
    
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    
    luaL_loadbuffer(L, b, strlen(b), NULL);
    
    lua_pcall(L, 0, 0, 0);
    lua_close(L);
    
    Py_INCREF(Py_None);
    return Py_None;
}

PyMODINIT_FUNC PyInit_lua(void)
{
    static PyMethodDef ModuleMethods[] = {
        { "eval", lua_eval, METH_VARARGS, "Eval For Lua" },
        { NULL, NULL, 0, NULL }
    };
    static struct PyModuleDef ModuleDef = {
        PyModuleDef_HEAD_INIT,
        "lua",
        "Eval For Lua",
            -1, ModuleMethods};
    PyObject * module = PyModule_Create(&ModuleDef);
    return module;
}
