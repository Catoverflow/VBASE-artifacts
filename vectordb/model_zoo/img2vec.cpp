/**
* \file
* The most simple example.
* 
*/

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <string>
// #include <stdio>
#include <iostream>
#include <sstream>
#include <vector>

#include "util.h"

using namespace curlpp::options;

extern "C"{
    std::vector<float> img2vec(char* input);
}

// int main(int, char **)
std::vector<float> img2vec(char* imgpath){
    std::vector<float> result;

    if (FILE *file = fopen(imgpath, "r")) {
        fclose(file);
    } else {
        std::cerr << "File does not exist: " << imgpath << std::endl;
        return result;
    }
    
	try
	{
		// That's all that is needed to do cleanup of used resources (RAII style).
		curlpp::Cleanup myCleanup;

		// Our request to be sent.
		curlpp::Easy myRequest;

        std::string endpoint = "http://172.23.234.85:18001/dog/upload";

        myRequest.setOpt<Url>(endpoint);


        // Forms takes ownership of pointers!
        curlpp::Forms formParts;
        formParts.push_back(new curlpp::FormParts::File("customFile", imgpath));
        myRequest.setOpt(new curlpp::options::HttpPost(formParts));

        std::ostringstream os;
        myRequest.setOpt(new curlpp::options::WriteStream(&os));
        // myRequest.setOpt(Verbose(true));
		myRequest.perform();
        
        // process the output
        std::string str2grep = "[4096]:";
        std::string raw_text = os.str();
        std::size_t begin, end;
        begin = raw_text.find(str2grep);

        if (begin!=std::string::npos) {
            begin+=str2grep.size();
            end=raw_text.find("\n", begin);
            if ( end!= std::string::npos){
                result = str2vec(raw_text.substr(begin, end-begin), "|");
            }

        }


	}

	catch(curlpp::RuntimeError & e)
	{
		std::cout << e.what() << std::endl;
	}

	catch(curlpp::LogicError & e)
	{
		std::cout << e.what() << std::endl;
	}
    
  return result;
}
