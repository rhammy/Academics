#include <string>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>
#include "file_parser.h"
#include "file_parse_exception.h"

using namespace std;

void file_parser::read_file(){
    string whitespace = " \t";
    //const char whitespace = ' ';
    const char quote_mark = '\'';
    const char end_of_line = '\n';
    //string current_word = " ";
    //string rest_of_word;
    //tokenized_line current_tokenized_line;
    bool skip_line;
    int not_whitespace_index;
    cout << __LINE__ << endl;
    for(unsigned int row_num=0; row_num<contents.size()-1; row_num++){
        string rest_of_word;
        tokenized_line current_tokenized_line;
        string current_word = " ";
        int begin_string = 0;
        int end_string = 0;
        skip_line = false;
        current_tokenized_line.label = " ";
        current_tokenized_line.opcode = " ";
        current_tokenized_line.operand = " ";
        current_tokenized_line.comment = " ";
        cout << __LINE__ << row_num << endl;
        vector<tokenized_line>::iterator iter_index = tokenized_list.begin() + row_num;
        // check for empty line
        if(contents[row_num].at(0)=='.'){
                current_tokenized_line.comment = contents[row_num];
                //tokenized_list.push_back(current_tokenized_line);
                tokenized_list.insert(iter_index, current_tokenized_line);
                cout << __LINE__ << endl;
                continue;
        }
        not_whitespace_index = contents[row_num].find_first_not_of(whitespace, begin_string);
        if(not_whitespace_index >= 0){
                if(contents[row_num].at(not_whitespace_index) == '\n'){
                        //tokenized_list.push_back(current_tokenized_line);
                        tokenized_list.insert(iter_index, current_tokenized_line);
                        continue;
                }
        } else {
                //tokenized_list.push_back(current_tokenized_line);
                tokenized_list.insert(iter_index, current_tokenized_line);
                continue;
        }

        for(int col_num=0; col_num<4; col_num++){
            // cout << __LINE__ << endl;
            current_word = " ";
            if(skip_line==true) continue;
            cout << __LINE__ << endl;
            not_whitespace_index = contents[row_num].find_first_not_of(whitespace, begin_string);
            if(not_whitespace_index >= 0){
                    if(contents[row_num].at(not_whitespace_index) == '\n'){
                        tokenized_list.push_back(current_tokenized_line);
                        skip_line = true;
                        continue;
                    }
            }
            cout << __LINE__ << endl;
            end_string = contents[row_num].find_first_of(whitespace, begin_string);
            if(end_string == 0){
                col_num++;
            }
            if(end_string == -1){ // no space found
                end_string = contents[row_num].find_first_of(end_of_line);
                //current_word = contents[row_num].substr(begin_string, end_string-1);
            } else {
                //current_word = contents[row_num].substr(begin_string, end_string-1);
                begin_string = contents[row_num].find_first_not_of(whitespace, end_string);
            }
            current_word = contents[row_num].substr(begin_string, end_string-1);
            // handle comments
            if((current_word.at(0)=='.')) {
                  end_string = contents[row_num].find_first_of(end_of_line, end_string);
                  rest_of_word = contents[row_num].substr(begin_string, end_string);
                  // current_word.append(rest_of_word);
                  current_word = rest_of_word;
                  current_tokenized_line.comment = current_word;
                  tokenized_list.push_back(current_tokenized_line);
            }

            cout << "errorspot" << endl;
            // label
            if(col_num==0) {
                if(isalpha(current_word.at(0))){
                    for(unsigned int i=1; i<current_word.length(); i++){
                        if(current_word.at(i) >= 0){
                                if(!isalnum(current_word.at(i))) {
                                    file_parse_exception("labels must only contain alphanumeric characters");
                                }
                        }
                    }
                    if(current_word.length() > 8) current_word = current_word.substr(0,7);
                    current_tokenized_line.label = current_word;
                } else file_parse_exception("label must start with alphabetic character");
                continue;
            }
            cout << __LINE__ << endl;

            // opcode
            if(col_num==1) {
                current_tokenized_line.opcode = current_word;
                continue;
            }

            // operand
            if(col_num==2) {
                if(current_word.at(0)=='C' && current_word.at(0)=='\'') {
                    if(current_word.find_first_of(quote_mark) == current_word.find_last_of(quote_mark)){
                        end_string = contents[row_num].find_last_of(quote_mark, end_string);
                        if(end_string==-1) file_parse_exception("quote was opened and not closed");
                        rest_of_word = contents[row_num].substr(begin_string, end_string);
                        begin_string = contents[row_num].find_first_not_of(whitespace, end_string+1);
                        //current_word.append(rest_of_word);
                        current_word = rest_of_word;
                    }
                }
                current_tokenized_line.operand = current_word;
                continue;
            }
            cout << __LINE__ << endl;

            // comment
            if(col_num==3) {
                if(!(current_word.at(0)=='.')) {
                  file_parse_exception("too many tokens on one line.");
                } else{
                  end_string = contents[row_num].find_last_of(end_of_line, end_string);
                  rest_of_word = contents[row_num].substr(begin_string, end_string);
                  // current_word.append(rest_of_word);
                  current_word = rest_of_word;
                  current_tokenized_line.comment = current_word;
                  tokenized_list.push_back(current_tokenized_line);
                }
                continue;
            }
        }
    }
    cout << "end of file reading" << endl;
}


// only called by programmer so it should always be a valid call
string file_parser::get_token(unsigned int row_num, unsigned int col_num){
    if(col_num==0){
                return tokenized_list[row_num].label;
    }
    if(col_num==1){
                return tokenized_list[row_num].opcode;
    }
    if(col_num==2){
                return tokenized_list[row_num].operand;
    }
    if(col_num==3){
                return tokenized_list[row_num].comment;
    }
    return "this should never happen - get_token";
}

int file_parser::size(){
    return tokenized_list.size();
}

void file_parser::print_file(){
    for(int i=0; i<size(); i++){
        cout << tokenized_list[i].label << '\t' <<
        tokenized_list[i].opcode << '\t'<<
        tokenized_list[i].operand << '\t' <<
        tokenized_list[i].comment << endl;
    }
}

file_parser::file_parser(string file_name){
    std::ifstream infile;
    string current_line;

    infile.open(file_name.c_str());
    if(!infile) file_parse_exception("Sorry, could not open the file for reading");

    while(!infile.eof()) {
        getline(infile,current_line);
        contents.push_back(current_line);
    }
    infile.close();
}

file_parser::~file_parser(){}
