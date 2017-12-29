/*  symtab_error_exception.h
    Exception class for symtab
    CS530 Fall 2017
    Alan Riggins
*/

#ifndef SYMTAB_ERROR_EXCEPTION
#define SYMTAB_ERROR_EXCEPTION_H
#include <string>

using namespace std;

class symtab_error_exception {

public:
    symtab_error_exception(string s) {
        message = s;
        }

    symtab_error_exception() {
        message = "An error has occurred";
        }

    string getMessage() {
        return message;
    }

private:
    string message;
};
#endif
