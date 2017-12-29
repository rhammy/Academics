#include <map>
#include <string>
#include <algorithm>
#include "opcodetab.h"
#include "opcode_error_exception.h"

using namespace std;
      
opcodetab::opcodetab(){
  
  m.insert(pair<string, pair<string,int>>("ADD", pair<string,int>("18",3)));
  m.insert(pair<string, pair<string,int>>("ADDF", pair<string,int>("58",3)));
  m.insert(pair<string, pair<string,int>>("ADDR", pair<string,int>("90",2)));
  m.insert(pair<string, pair<string,int>>("AND", pair<string,int>("40",3)));
  m.insert(pair<string, pair<string,int>>("CLEAR", pair<string,int>("B4",2)));
  m.insert(pair<string, pair<string,int>>("COMP", pair<string,int>("28",3)));
  m.insert(pair<string, pair<string,int>>("COMPF", pair<string,int>("88",3)));
  m.insert(pair<string, pair<string,int>>("COMPR", pair<string,int>("A0",2)));
  m.insert(pair<string, pair<string,int>>("DIV", pair<string,int>("24",3)));
  m.insert(pair<string, pair<string,int>>("DIVF", pair<string,int>("64",3)));
  m.insert(pair<string, pair<string,int>>("DIVR", pair<string,int>("9C",2)));
  m.insert(pair<string, pair<string,int>>("FIX", pair<string,int>("C4",1)));
  m.insert(pair<string, pair<string,int>>("FLOAT", pair<string,int>("C0",1)));
  m.insert(pair<string, pair<string,int>>("HIO", pair<string,int>("F4",1)));
  m.insert(pair<string, pair<string,int>>("J", pair<string,int>("3C",3)));
  m.insert(pair<string, pair<string,int>>("JEQ", pair<string,int>("30",3)));
  m.insert(pair<string, pair<string,int>>("JGT", pair<string,int>("34",3)));
  m.insert(pair<string, pair<string,int>>("JLT", pair<string,int>("38",3)));
  m.insert(pair<string, pair<string,int>>("JSUB", pair<string,int>("48",3)));
  m.insert(pair<string, pair<string,int>>("LDA", pair<string,int>("00",3)));
  m.insert(pair<string, pair<string,int>>("LDB", pair<string,int>("68",3)));
  m.insert(pair<string, pair<string,int>>("LDCH", pair<string,int>("50",3)));
  m.insert(pair<string, pair<string,int>>("LDF", pair<string,int>("70",3)));
  m.insert(pair<string, pair<string,int>>("LDL", pair<string,int>("08",3)));
  m.insert(pair<string, pair<string,int>>("LDS", pair<string,int>("6C",3)));
  m.insert(pair<string, pair<string,int>>("LDT", pair<string,int>("74",3)));
  m.insert(pair<string, pair<string,int>>("LDX", pair<string,int>("04",3)));
  m.insert(pair<string, pair<string,int>>("LPS", pair<string,int>("D0",3)));
  m.insert(pair<string, pair<string,int>>("MUL", pair<string,int>("20",3)));
  m.insert(pair<string, pair<string,int>>("MULF", pair<string,int>("60",3))); 
  m.insert(pair<string, pair<string,int>>("MULR", pair<string,int>("98",2)));
  m.insert(pair<string, pair<string,int>>("NORM", pair<string,int>("C8",1)));
  m.insert(pair<string, pair<string,int>>("OR", pair<string,int>("44",3)));
  m.insert(pair<string, pair<string,int>>("RD", pair<string,int>("D8",3)));
  m.insert(pair<string, pair<string,int>>("RMO", pair<string,int>("AC",2)));
  m.insert(pair<string, pair<string,int>>("RSUB", pair<string,int>("4C",3)));
  m.insert(pair<string, pair<string,int>>("SHIFTL", pair<string,int>("A4",2)));
  m.insert(pair<string, pair<string,int>>("SHIFTR", pair<string,int>("A8",2)));
  m.insert(pair<string, pair<string,int>>("SIO", pair<string,int>("F0",1)));
  m.insert(pair<string, pair<string,int>>("SSK", pair<string,int>("EC",3)));
  m.insert(pair<string, pair<string,int>>("STA", pair<string,int>("0C",3)));
  m.insert(pair<string, pair<string,int>>("STB", pair<string,int>("78",3)));
  m.insert(pair<string, pair<string,int>>("STCH", pair<string,int>("54",3)));
  m.insert(pair<string, pair<string,int>>("STF", pair<string,int>("80",3)));
  m.insert(pair<string, pair<string,int>>("STI", pair<string,int>("D4",3)));
  m.insert(pair<string, pair<string,int>>("STL", pair<string,int>("14",3)));
  m.insert(pair<string, pair<string,int>>("STS", pair<string,int>("7C",3)));
  m.insert(pair<string, pair<string,int>>("STSW", pair<string,int>("E8",3)));
  m.insert(pair<string, pair<string,int>>("STT", pair<string,int>("84",3)));
  m.insert(pair<string, pair<string,int>>("STX", pair<string,int>("10",3)));
  m.insert(pair<string, pair<string,int>>("SUB", pair<string,int>("1C",3)));
  m.insert(pair<string, pair<string,int>>("SUBF", pair<string,int>("5C",3)));
  m.insert(pair<string, pair<string,int>>("SUBR", pair<string,int>("94",2)));
  m.insert(pair<string, pair<string,int>>("SVC", pair<string,int>("B0",2)));
  m.insert(pair<string, pair<string,int>>("TD", pair<string,int>("E0",3)));
  m.insert(pair<string, pair<string,int>>("TIO", pair<string,int>("F8",1)));
  m.insert(pair<string, pair<string,int>>("TIX", pair<string,int>("2C",3)));
  m.insert(pair<string, pair<string,int>>("TIXR", pair<string,int>("B8",2)));
  m.insert(pair<string, pair<string,int>>("WD", pair<string,int>("DC",3)));
}


string opcodetab::string_to_upper(string opCode){
  	transform(opCode.begin(), opCode.end(), opCode.begin(), ::toupper);
  	return opCode;
}

//checks if the opcode is in the map
bool opcodetab::opcode_exists(string opCode){
  
  if(opCode.size()<1) return false;    //checks size of string 
  
  opCode = string_to_upper(opCode);  //converts valid opcode to uppercase
   //strips the plus sign and finds the opcode in the map
  if(opCode.at(0)=='+'){
  	opCode = string_to_upper(opCode.substr(1,opCode.size()));
  	if(m.find(opCode)==m.end()) return false;
  }
  
  if(m.find(opCode)==m.end()){
  	return false;
  }

  return true;
}

// takes a SIC/XE opcode and returns the machine code
// equivalent as a two byte string in hexadecimal.
  // Example:  get_machine_code("ADD") returns the value 18
  // Note that opcodes may be prepended with a '+'.
  // throws an opcode_error_exception if the opcode is not
  // found in the table.

string opcodetab::get_machine_code(string opCode) {

    //check if opcode is empty string
	if (opCode.size() == 0) throw opcode_error_exception("Opcode" + opCode + " not found");

    //check if opcode exists
    if (opcode_exists(opCode)){
      //make opcode all upercase before running operations
      opCode = string_to_upper(opCode);
      //strip the plus sign, find the opcode, then output the hex digits
      if (opCode.at(0) == '+'){
        opCode = opCode.substr(1, opCode.size());
        m_iter = m.find(opCode);
        return m_iter->second.first;
      }
      //no plus sign, then just ouput hex digits
      m_iter = m.find(opCode);
      return m_iter->second.first;
	}
  //Opcode does not exist, thow error
     else throw opcode_error_exception("Opcode" + opCode + " not found");

}

  // takes a SIC/XE opcode and returns the number of bytes
  // needed to encode the instruction, which is an int in
  // the range 1..4.
  // NOTE: the opcode must be prepended with a '+' for format 4.
  // throws an opcode_error_exception if the opcode is not
  // found in the table.
int opcodetab::get_instruction_size(string opCode) {
  //make opcode uppercase before searching for it
  opCode=string_to_upper(opCode);
  //check if exists
  if(opcode_exists(opCode)){
 	  if(opCode.at(0) == '+') return 4;
    m_iter = m.find(opCode);
 	return m_iter->second.second;
  }
  //does not exist
  else throw (opcode_error_exception("Opcode " + opCode + " not found"));
}


