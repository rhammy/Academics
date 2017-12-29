#include <map>
#include <string>
#include "symtab.h"
#include "symtab_error_exception.h"

//populate the table with user tokens and addresses
void symtab::insert(string label, string address){
	userTab.insert(label, address);
	// userTab.insert(pair<string, string>(label, address);
	return;
}


//checks the table 
bool symtab::contains(string key){
	if(key.size()<1) return false;    //checks size of string 

	if(userTab.find(key)==m.end()){
		return false;
	}
	return true;
}


//get address from label
string symtab::getAddress(string key){
	if(key.size() == 0) throw symtab_error_exception("Error: Symbol " + key + " not found.");

	if(contains(key)) {
		user_iter = userTab.find(key);
		return user_iter->second;
	}
	else throw symtab_error_exception("Error: Symbol " + key + " not found.")
}

