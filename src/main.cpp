//
//  main.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include <iostream>
#include <sstream>
#include <string>
#include "types.h"
#include "movable_complex.h"
#include "face.h"
#include "util.h"
#include "randomize_complex.h"
#include "reduce_complex.h"

int main (int argc, const char * argv[])
{
    std::istream & in = std::cin;
    
    while (true)
    {
        std::string line;
        std::getline(in, line);
        std::stringstream sstream(line);
        
        std::string command;
        sstream >> command;
        
        if (command.compare("randomize") == 0)
        {
            MovableComplex complex;
            sstream >> complex;
            
            std::vector< unsigned int > allowedMoves;
            for (unsigned int i = 0; i < complex.dimension()+1; i++)
                allowedMoves.push_back(i);
            
            unsigned int rounds = 50;
            
            std::string nextToken;
            while (sstream >> nextToken)
            {
                std::stringstream token(nextToken);
                
                if (token.str().compare(0,12,"allowedMoves") == 0)
                {
                    token.ignore(token.str().length(),'=');
                    std::vector< unsigned int > newAllowedMoves;
                    list_read(token, newAllowedMoves);
                    allowedMoves = newAllowedMoves;
                }
                else if (token.str().compare(0,6,"rounds") == 0)
                {
                    token.ignore(token.str().length(),'=');
                    token >> rounds;
                }
            }
            
            randomize_complex(complex, allowedMoves, rounds);
            
            std::cout << "resulting complex is " << complex << std::endl;
        }
        else if (command.compare("reduce") == 0)
        {
            MovableComplex complex;
            sstream >> complex;
            
            unsigned int rounds = 10000;
            int heating = 0;
            int relaxation = 4;
            
            std::string nextToken;
            while (sstream >> nextToken)
            {
                std::stringstream token(nextToken);

                if (token.str().compare(0,6,"rounds") == 0)
                {
                    token.ignore(token.str().length(),'=');
                    token >> rounds;
                }
                else if (token.str().compare(0,7,"heating") == 0)
                {
                    token.ignore(token.str().length(),'=');
                    token >> heating;
                }
                else if (token.str().compare(0,9,"relaxation") == 0)
                {
                    token.ignore(token.str().length(),'=');
                    token >> relaxation;
                }
            }
            
            reduce_complex(complex, rounds, heating, relaxation);
            
            std::cout << "resulting complex is " << complex << " with " << complex.f(0) << " vertices" << std::endl;
        }
        else if (command.compare("quit") == 0)
        {
            break;
        }
        else
        {
            std::cout << "possible commands are:" << std::endl;
            std::cout << "- \"reduce %c with %o\", where %c is a complex given as facet list and %o are options." << std::endl;
            std::cout << "\texample: \"reduce [[1,2],[2,3],[3,4],[4,1]] with rounds=10, heating=0 and relaxation=4\"" << std::endl;
            std::cout << "- \"randomize %c with %o\", where %c is a complex given as facet list and %o are options." << std::endl;
            std::cout << "\texample: \"randomize [[1,2,3],[1,2,4],[1,3,4],[2,3,4]] with rounds=10 and allowedMoves=[0,1]\"" << std::endl;
            std::cout << "- \"quit\"" << std::endl;
        }
    }
    
    return 0;
}

