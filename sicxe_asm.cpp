#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>
#include <sstream>
#include <iomanip>
#include <cstring>
#include <string>
#include <algorithm>
#include <fstream>

#include "sicxe_asm.h"
#include "file_parser.h"
#include "opcodetab.h"
#include "symtab.h"
#include "file_parse_exception.h"
#include "opcode_error_exception.h"
#include "symtab_exception.h"


using namespace std;

struct asm_line{
        int line_num;
        string address;
        string label;
        string opcode;
        string operand;
        string comment;
        string machine_code;

        asm_line(){
            line_num=0;
            address="";
            label="";
            opcode="";
            operand="";
            comment="";
            machine_code="";
        }
};

std::vector<asm_line> asm_list;
string base = "";
string LOCCTR;
int current_line_num = -1;
symtab our_symtab = symtab();
opcodetab our_opcodetab = opcodetab();
string progname;
asm_line current_asm_line;
file_parser our_file;
string line_num_string;
string the_file_name;
string tmp_operand;
unsigned int find_base;
bool hasBase = false;


//Function to convert string to int
int string_to_int(string s){
        istringstream instr(s);
        int n;
    instr >> n;
        return n;
}

//Function to convert string to uppercase
string to_uppercase(string s){
        transform(s.begin(),s.end(),s.begin(),::toupper);
        return s;
}

//Function to convert decimal integer to string hexidecimal
string int_to_hex(int num, int width){
        stringstream out;
        out << setw(width) << setfill('0') << hex << num;
        return to_uppercase(out.str());
}

//Function to convert string hexadecimal to a decimal integer
int hex_to_int(string s){
        int value;
        sscanf(s.c_str(),"%x",&value);
        return value;
}

//Function to convert decimal string to an integer
int dec_to_int(string s){
        int value;
        sscanf(s.c_str(),"%d",&value);
        return value;
}

//Function to convert string to uppercase
string format_15(int x){
        stringstream tmp;
        tmp << hex << setw(8) << setfill('0') << x;
        string xx = tmp.str();
        stringstream tmmp;
        tmmp << setw(15) << xx;
        return tmmp.str();
}
string update_loc(int x){
        int tmp = hex_to_int(LOCCTR);
        tmp += x;
        return to_uppercase(int_to_hex(tmp, 6));
}


void get_next_line(){
        current_line_num++;
        stringstream converting;
        converting << (current_line_num+1);
        line_num_string = converting.str();
        current_asm_line.label=our_file.get_token(current_line_num,0);
        current_asm_line.opcode=our_file.get_token(current_line_num,1);
        current_asm_line.operand=our_file.get_token(current_line_num,2);
        current_asm_line.comment=our_file.get_token(current_line_num,3);
        current_asm_line.line_num = current_line_num+1;
}

bool contains_directive(string this_opcode){
        if(this_opcode == "BASE") {
                hasBase = true;
                return true;
        }
    else if(this_opcode == "NOBASE") {
                hasBase = false;
                return true;
        }
    else if(this_opcode == "WORD") return true;
        else if(this_opcode == "BYTE") return true;
        else if(this_opcode == "RESW") return true;
        else if(this_opcode == "RESB") return true;
        else if(this_opcode == "EQU") return true;
        else return false;

}



void handle_directives(){
        string current_opcode = to_uppercase(current_asm_line.opcode);
        string tmp;
        if(current_opcode == "EQU"){
                if(current_asm_line.label == " ") symtab_exception("On line: " + line_num_string + ", invalid to use EQU without label.");
                if (our_symtab.contains(current_asm_line.label)) throw symtab_exception("On line: " + line_num_string + ", Label " + current_asm_line.label + " is duplicate.");

                if(isdigit(current_asm_line.operand.at(0))){
                        our_symtab.insert(current_asm_line.label, int_to_hex(string_to_int(current_asm_line.operand), 6));
                }else if(current_asm_line.operand.at(0) == '#'){
                        tmp = current_asm_line.operand.substr(1);
                        our_symtab.insert(current_asm_line.label, int_to_hex(string_to_int(tmp), 6));
                }else if(current_asm_line.operand.at(0) == '$'){
                        tmp = current_asm_line.operand.substr(1);
                        tmp = int_to_hex(hex_to_int(tmp),6);
                        our_symtab.insert(current_asm_line.label,tmp);
                }
                current_asm_line.address = LOCCTR;
        }
    else{
                if(current_asm_line.label != " "){
                        if(our_symtab.contains(current_asm_line.label) == true){
                                throw symtab_exception("On line: " + line_num_string + ", Label " + current_asm_line.label + " contains invalid duplicate.");
                        } else{
                                our_symtab.insert(current_asm_line.label, LOCCTR);
                        }
                }
        }

    if(current_opcode == "BASE"){
                base = current_asm_line.operand;
                current_asm_line.address = LOCCTR;
        }
    if(current_opcode == "NOBASE"){
                base = "";
                current_asm_line.address = LOCCTR;
        }
    if(current_opcode == "WORD"){
                current_asm_line.address = LOCCTR;
                LOCCTR = update_loc(3);
        }
    if(current_opcode == "BYTE"){
                current_asm_line.address = LOCCTR;
                string token = current_asm_line.operand.substr(2, strlen(current_asm_line.operand.c_str())-3);
                if(to_uppercase(current_asm_line.operand).at(0)=='C'){
                        LOCCTR = update_loc(token.length());
                }
                else if(to_uppercase(current_asm_line.operand).at(0)=='X'){
                        if((strlen(token.c_str()) & 1) == 1) throw symtab_exception("On line: " + line_num_string + ",  hex integers must be in bytes (even length)");          // more efficient
                        LOCCTR = update_loc(strlen(token.c_str()) >> 1);
                } else {
                        throw symtab_exception("On line: " + line_num_string + ",  Invalid operand following BYTE opcode");
                }
        }
    else if(current_opcode == "RESW"){
                current_asm_line.address = LOCCTR;
                LOCCTR = update_loc(3 * string_to_int(current_asm_line.operand));
        }
    else if(current_opcode == "RESB"){
                current_asm_line.address = LOCCTR;
                LOCCTR = update_loc(string_to_int(current_asm_line.operand));
        }
}

void print_sicxe_asm(string file_name){
        string out_file_name = file_name.substr(0, file_name.length()-4) + ".lis";
        ofstream outputFile;
        outputFile.open(out_file_name.c_str());
        for(unsigned int i=0; i<asm_list.size(); i++){
                outputFile << setw(15) << asm_list[i].line_num << setw(15) <<
                asm_list[i].address << setw(15) <<
                asm_list[i].label << setw(15) <<
                asm_list[i].opcode << setw(15) <<
                asm_list[i].operand << setw(15) <<
                asm_list[i].machine_code << endl; //jake added
        }
    outputFile.close();
}

bool base_relative(string s){ //make sure base is delcared in this scope
        string destination = our_symtab.getAddress(s);
        if(!hasBase) return false;
        find_base = hex_to_int(destination) - hex_to_int(our_symtab.getAddress(base));
        if(find_base < 4095 && find_base > 0){
                return true;
        }
    return false;
}

bool pc_relative(string s){
        int destination = hex_to_int(our_symtab.getAddress(s));
        int source = hex_to_int(current_asm_line.address) + 3;
        int find_pc = destination - source;
        if(find_pc < 2047 && find_pc > -2048){
                return true;
        }
    return false;
}

int flag_check(){

        string new_operand = current_asm_line.operand;
        unsigned int flags = 0;
        if(current_asm_line.operand.at(0)!='@' && current_asm_line.operand.at(0)!='#'){
                flags += 32;
                flags += 16;
        }else if(current_asm_line.operand.at(0)== '@'){
                flags += 32;
        }else if(current_asm_line.operand.at(0)== '#'){
                flags += 16;
        }
    if(current_asm_line.operand.find_first_of(",") != std::string::npos){
                flags += 8;
        }


    if(current_asm_line.opcode.at(0)=='+'){
                flags += 1;
        }

    else if(current_asm_line.opcode.at(0)!='+'){

                if(new_operand.at(0) == '#' || new_operand.at(0) == '@'){
                        new_operand = new_operand.substr(1);
                }
                if(isdigit(new_operand.at(0))){

                }else if(pc_relative(tmp_operand)==true){
                        //then 4th bit is 1
                        flags += 2;
                }else if(base_relative(tmp_operand)){
                        //then 5th bit is 1
                        flags += 4;
                }
        }
    return flags;
}

void format1_calc(){
        current_asm_line.machine_code = our_opcodetab.get_machine_code(current_asm_line.opcode);
}

int register_int_equivalent(string temp_register) { // Don't forget to add this to the pass_2.h
        if(temp_register == "A") //should this be double quoted
                return 0;
        else if(temp_register == "X")
                return 1;
        else if(temp_register == "L")
                return 2;
        else if(temp_register == "B")
                return 3;
        else if(temp_register == "S")
                return 4;
        else if(temp_register == "T")
                return 5;
        else if(temp_register == "F")
                return 6;
        else if(temp_register == "PC")
                return 8;
        else if(temp_register == "SW")
                return 9;
        else if(temp_register == "1")
                return 0;
        else if(temp_register == "2")
                return 1;
        else if(temp_register == "3")
                return 2;
        else if(temp_register == "4")
                return 3;
        else if(temp_register == "5")
                return 4;
        else if(temp_register == "6")
                return 5;
        else if(temp_register == "7")
                return 6;
        else if(temp_register == "8")
                return 7;
        else if(temp_register == "9")
                return 8;
        else if(temp_register == "10")
                return 9;
        else if(temp_register == "11")
                return 10;
       else if(temp_register == "11")
                return 10;
        else if(temp_register == "12")
                return 11;
        else if(temp_register == "13")
                return 12;
        else if(temp_register == "14")
                return 13;
        else if(temp_register == "15")
                return 14;
        else if(temp_register == "16")
                return 15;
        else
                throw file_parse_exception("On line " + line_num_string + " , invalid register use."); //Make sure this works
}

void format2_calc(){
        string tmp = our_opcodetab.get_machine_code(current_asm_line.opcode);
        char token = ',';
        int position_of_token = (current_asm_line.operand).find(token); // starting count from 0
        string operand_part_one = (current_asm_line.operand).substr(0, position_of_token);
        string operand_part_two = (current_asm_line.operand).substr(position_of_token+1, current_asm_line.operand.length()-1);
        int register_one;
        int register_two;
        if(to_uppercase(current_asm_line.opcode) == "SVC"){
                operand_part_one = current_asm_line.operand;
                operand_part_two = "0";
                register_one = string_to_int(operand_part_one);
                register_two = string_to_int(operand_part_two);
        } else if(to_uppercase(current_asm_line.opcode) == "CLEAR" || to_uppercase(current_asm_line.opcode) == "TIXR"){
                operand_part_one = current_asm_line.operand;
                operand_part_two = "0";
                register_one = string_to_int(operand_part_one);
                register_two = string_to_int(operand_part_two);
        } else if(to_uppercase(current_asm_line.opcode) == "CLEAR" || to_uppercase(current_asm_line.opcode) == "TIXR"){
                operand_part_one = current_asm_line.operand;
                operand_part_two = "0";
                register_one = register_int_equivalent(operand_part_one);
                register_two = string_to_int(operand_part_two);
        } else{
                register_one = register_int_equivalent(to_uppercase(operand_part_one));
                register_two = register_int_equivalent(to_uppercase(operand_part_two));
        }
    current_asm_line.machine_code = tmp + int_to_hex(register_one,1) + int_to_hex(register_two,1);
}

void format3_calc(){
        unsigned int tmp_six_bit = hex_to_int(our_opcodetab.get_machine_code(current_asm_line.opcode))/4; //gets machine code for first 6 bits of opcode
        unsigned int tmp_address;
        string tmp_address_string;
        tmp_operand = current_asm_line.operand;

        if(tmp_operand.at(0) == '#' || tmp_operand.at(0) == '@'){
                tmp_operand = tmp_operand.substr(1);
                if(tmp_operand.at(0) == '#' || tmp_operand.at(0) == '@'){
                        throw symtab_exception("On line: " + line_num_string + ", Invalid addressing mode.");
                }
        }

    // if operand contains comma, grab substr from 0 for string size (size-2)
        else if(tmp_operand.find(',')!=std::string::npos){
                int tmp_found = tmp_operand.find(',');
                tmp_operand = tmp_operand.substr(0, tmp_found); // tmp_found should be string size()-2
        }

    if(our_symtab.contains(tmp_operand)){ //checks for symbol in operand field of current line
                tmp_address = hex_to_int(our_symtab.getAddress(tmp_operand));
                if(pc_relative(tmp_operand) == true){
                        tmp_address -= (hex_to_int(current_asm_line.address)+3);
                        tmp_address_string = int_to_hex(tmp_address,3);
                }
                else if(base_relative(tmp_operand)==true){
                        tmp_address = find_base;
                        tmp_address_string = int_to_hex(tmp_address,3);
                } else throw file_parse_exception("On line: " + line_num_string + ", Operand not in range of a valid addressing mode.");
        } else {
                tmp_address = string_to_int(current_asm_line.operand.substr(1));
                tmp_address_string = int_to_hex(tmp_address, 3);
        }
    if(tmp_address_string.length() > 3){
                tmp_address_string = tmp_address_string.substr(tmp_address_string.length()-3);
        }
    unsigned int tmp_flags = flag_check();

        unsigned int tmp_combine = (tmp_six_bit*64) + tmp_flags;
        current_asm_line.machine_code = int_to_hex(tmp_combine,3) + tmp_address_string;
}

void format4_calc(){
        unsigned int tmp_six_bit = hex_to_int(our_opcodetab.get_machine_code(current_asm_line.opcode))/4; //gets machine code for first 6 bits of opcode
        unsigned int tmp_address;
        string tmp_address_string;
        tmp_operand = current_asm_line.operand;

        if(tmp_operand.at(0) == '#' || tmp_operand.at(0) == '@'){
                tmp_operand = tmp_operand.substr(1);
                if(tmp_operand.at(0) == '#' || tmp_operand.at(0) == '@'){
                tmp_operand = tmp_operand.substr(1);
                if(tmp_operand.at(0) == '#' || tmp_operand.at(0) == '@'){
                        throw symtab_exception("On line: " + line_num_string + ", Invalid addressing mode.");
                }
        }

    // if operand contains comma, grab substr from 0 for string size (size-2)
        else if(tmp_operand.find(',')!=std::string::npos){
                int tmp_found = tmp_operand.find(',');
                tmp_operand = tmp_operand.substr(0, tmp_found); // tmp_found should be string size()-2
        }

    if(our_symtab.contains(tmp_operand)){ //checks for symbol in operand field of current line
                //store symbol value as operand address
                tmp_address_string = our_symtab.getAddress(tmp_operand);
        }       else {
                tmp_address = string_to_int(current_asm_line.operand.substr(1));
                tmp_address_string = int_to_hex(tmp_address, 5);
        }
        if(tmp_address_string.length() > 5){
                tmp_address_string = tmp_address_string.substr(tmp_address_string.length()-5);
        }
    unsigned int tmp_flags = flag_check();

        unsigned int tmp_combine = (tmp_six_bit*64) + tmp_flags;
        current_asm_line.machine_code = int_to_hex(tmp_combine,3) + tmp_address_string;

}

void pass_one(){

        get_next_line();
        while(current_line_num < our_file.size() && to_uppercase(current_asm_line.opcode) != "START"){
                if(current_asm_line.label!=" " || current_asm_line.opcode!=" " || current_asm_line.operand!=" "){
                        throw file_parse_exception("START must be opcode of first line containing more than a comment.");
                }
                get_next_line();
        }

    if(to_uppercase(current_asm_line.opcode) != "START") throw file_parse_exception("Start opcode not found");
        progname = current_asm_line.label;

        if(current_asm_line.operand.at(0) != '$'){
                LOCCTR = int_to_hex(string_to_int(current_asm_line.operand), 6);
                LOCCTR = update_loc(0);
         }
         else {
                 LOCCTR = current_asm_line.operand.substr(1);
                 LOCCTR = update_loc(0);
        }

    asm_list.push_back(current_asm_line);

        get_next_line();

        while (to_uppercase(current_asm_line.opcode) != "END"){

                while(current_asm_line.opcode == " ") get_next_line();

                if(to_uppercase(current_asm_line.opcode) == "LDB" && !hasBase){
                        throw file_parse_exception("On line: " + line_num_string + ", LDB used without prior BASE directive.");
               }
                string current_opcode = to_uppercase(current_asm_line.opcode);
                if(contains_directive(current_opcode)){
                        handle_directives();
                        asm_list.push_back(current_asm_line);
                }
                else{
                        if(current_asm_line.label != " "){
                                if(our_symtab.contains(current_asm_line.label))
                                        throw symtab_exception("On line: " + line_num_string + ", Label " + current_asm_line.label + " contains invalid duplicate.");
                                else
                                        our_symtab.insert(current_asm_line.label, LOCCTR);
                        }
                        if(!our_opcodetab.opcode_exists(current_opcode))
                                throw symtab_exception("On line: " + line_num_string + ", Invalid opcode: " + current_asm_line.opcode);
                        current_asm_line.address = LOCCTR;
                        LOCCTR = update_loc(our_opcodetab.get_instruction_size(current_opcode));
                        asm_list.push_back(current_asm_line);
                }

                get_next_line();
        }
    current_asm_line.address = LOCCTR;
        asm_list.push_back(current_asm_line);
}

void pass_two(){


        int index=0;
        current_asm_line = asm_list[index++];
        stringstream converting;
        converting << current_asm_line.line_num;
        line_num_string = converting.str();

        while(to_uppercase(current_asm_line.opcode) != "END"){

                stringstream converting;
                converting << current_asm_line.line_num;
                line_num_string = converting.str();

                if(to_uppercase(current_asm_line.opcode) == "START") current_asm_line = asm_list[index++];

                while(current_asm_line.opcode == " ") current_asm_line = asm_list[index++];

                string current_opcode = to_uppercase(current_asm_line.opcode);

                if(contains_directive(current_opcode)){

                        if(current_opcode == "BYTE"){

                                string token = current_asm_line.operand.substr(2, strlen(current_asm_line.operand.c_str())-3);
                                current_asm_line.machine_code = " ";
                                if(to_uppercase(current_asm_line.operand).at(0)=='C'){

                                        for(unsigned int i=0; i<token.size(); i++){
                                                std::stringstream hex_value;
                                                hex_value <<  hex << int(token.at(i));
                                                std::string s = hex_value.str();
                                                current_asm_line.machine_code += to_uppercase(s);
                                        }

                                        asm_list[index-1] = current_asm_line;
                                }
                                else if(to_uppercase(current_asm_line.operand).at(0)=='X'){

                                        current_asm_line.machine_code = to_uppercase(token);
                                        asm_list[index-1] = current_asm_line;
                                }
                        }
                        else if(current_opcode == "WORD"){
                                current_asm_line.machine_code = int_to_hex(string_to_int(current_asm_line.operand),6);
                                asm_list[index-1] = current_asm_line;
                        }
                        else{
                                current_asm_line.machine_code = " ";
                                asm_list[index-1] = current_asm_line;
                        }

                }
                //end of machine code for directives
                //start of machine code for opcodes

                else if(current_opcode != " "){

                        if(!our_opcodetab.opcode_exists(current_opcode)){
                                throw symtab_exception("On line: " + line_num_string + ", Invalid opcode: " + current_asm_line.opcode);
                        }
                        else{
                                if(current_opcode.at(0) == '+') current_opcode = current_opcode.substr(1);
                                if(our_opcodetab.get_instruction_size(current_opcode)==1){
                                        format1_calc();
                                        asm_list[index-1] = current_asm_line;
                                }
                                else if(our_opcodetab.get_instruction_size(current_opcode)==2){
                                        format2_calc();
                                        asm_list[index-1] = current_asm_line;
                                }
                                else if(our_opcodetab.get_instruction_size(current_opcode)==3){
                                        if(to_uppercase(current_asm_line.opcode) == "RSUB"){
                                                current_asm_line.machine_code = "4F0000";
                                                asm_list[index-1] = current_asm_line;
                                        }
                                        else if(current_asm_line.opcode.at(0) == '+'){
                                                format4_calc();
                                                asm_list[index-1] = current_asm_line;
                                        }
                                        else{
                                                format3_calc();
                                                asm_list[index-1] = current_asm_line;
                                        }
                                }

                        }
                }
                current_asm_line = asm_list[index++];
        }
}

sicxe_asm::sicxe_asm(void){
        pass_one();
        pass_two();
}


int main(int argc, char *argv[]){

        // parse file
        if(argc!=2){
                cout << "Error, you must provide the name of the file" <<
                "to process at the command line." << endl;
                exit(1);
        }
    the_file_name = argv[1];

        try{
                our_file = file_parser(the_file_name);
                our_file.read_file();
                sicxe_asm();
                print_sicxe_asm(the_file_name);
        } catch(file_parse_exception& e){
                cout << "**Sorry, file_parse_exception " << e.getMessage() << endl;
        } catch(opcode_error_exception& e){
                cout << "**Sorry, opcode_exception " << e.getMessage() << endl;
        } catch(symtab_exception& e){
                cout << "**Sorry, symtab_exception " << e.getMessage() << endl;
        }
}


