/**
* \file
* The most simple example.
* 
*/

#include <curlpp/cURLpp.hpp>
#include <curlpp/Easy.hpp>
#include <curlpp/Options.hpp>
#include <string>
#include <iostream>
#include <sstream>
#include <vector>

// #include <stdio>
#include "util.h"

using namespace curlpp::options;

// #define DEBUG

extern "C"{
    std::vector<float> word2vec(char* input);
}

std::vector<float> word2vec(char* input)
{
    std::vector<float> result;
	try
	{
		// That's all that is needed to do cleanup of used resources (RAII style).
		curlpp::Cleanup myCleanup;

		// Our request to be sent.
		curlpp::Easy myRequest;

        std::string query_string = std::string(input);

        std::string endpoint = "http://deeplearning.indexservedlmodelserve2-prod-co4.co4.ap.gbl:86/route/relevance.spacevrc2";
        std::string mkt = "en-us";
        std::string q = curlpp::escape("[{\"query\":\"" + query_string + "\", \"market\":\"" + mkt + "\"}]");
        std::string urlPattern = endpoint + "?q=" + q;

        std::ostringstream os;
        myRequest.setOpt(new curlpp::options::WriteStream(&os));
        // myRequest.setOpt(Verbose(true));
        
		// Set the URL.
        myRequest.setOpt<Url>(urlPattern);

		// Send request and get a result.
		myRequest.perform();
        
        // process the output
        std::string str2grep = "[\"";
        std::string raw_text = os.str();
        std::size_t begin, end;
        begin = raw_text.find(str2grep);

        if (begin!=std::string::npos) {
            begin+=str2grep.size();
            end=raw_text.find("\"]", begin);
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
