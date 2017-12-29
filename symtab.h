#ifndef SYMTAB_H
#define SYMTAB_H
#include <map>
#include <iostream>

using namespace std;

class symtab {
	public:

		//ctor
		//populate the table with user tokens and addresses
		void insert(string, string);

		//checks the table 
		bool contains(string);

		//get address from label
		string getAddress(string);


	private:

		//table variable of symbols and addresses
		map<string, string> userTab; 

		map<string, string >::iterator user_iter;
};