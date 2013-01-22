//
//  randomize_complex.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 19.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include "randomize_complex.h"

#include <stdlib.h>
#include <time.h>

void randomize_complex(MovableComplex & complex, const std::vector< unsigned int > & allowedMoves, unsigned int rounds)
{
    // initialize the RNG
    srand(static_cast<unsigned int>(time(0)));
    
    for (int currentRound = 0; currentRound < rounds; currentRound++)
    {
        int numberOfCodimensions = 0;
        for (int i = 0; i < allowedMoves.size(); i++)
        {
            if (complex.hasValidMoves(allowedMoves[i]))
                numberOfCodimensions++;
        }
        
        if (numberOfCodimensions == 0)
            break;
        
        int codimension = 0;
        for (int i = 0, r = rand() % numberOfCodimensions; i < allowedMoves.size() && r >= 0; i++)
        {
            if (complex.hasValidMoves(allowedMoves[i]))
            {
                codimension = allowedMoves[i];
                r--;
            }
        }
        
        bistellar_move_list_t validMoves = complex.validMoves(codimension);
        BistellarMove move = validMoves.at(rand() % validMoves.size());
        complex.moveComplex(move);
    }
}