//
//  reduce_complex.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 22.10.11.
//  Copyright 2011 -. All rights reserved.
//


#include "reduce_complex.h"

#include <iostream>
#include <stdlib.h>
#include <time.h>

const unsigned int baseHeating = 4;
const unsigned int baseRelaxation = 3;


void reduce_complex(MovableComplex & complex, unsigned int rounds, int heating, int relaxation)
{
    if (complex.dimension() == 0)
        return;
    
    // initialize the RNG
    srand(static_cast<unsigned int>(time(0)));

    MovableComplex minimalComplex = complex;
    
    for (int currentRound = 1; currentRound < rounds; currentRound++)
    {
        // select move
        bistellar_move_list_t moves;
        
        if (complex.dimension() < 3)
        {
            unsigned int i = complex.dimension();
            while (moves.empty())
            {
                moves = complex.validMoves(i);
                i--;
            }
        }
        else if (complex.dimension() == 3)
        {
            if (heating > 0)
            {
                if (heating % 15 == 0)
                {
                    moves = complex.validMoves(0);
                }
                else
                {
                    moves = complex.validMoves(1);
                    if (moves.empty())
                    {
                        moves = complex.validMoves(2);
                        heating = 0;
                    }
                }
                heating--;
            }
            else
            {
                moves = complex.validMoves(3);
                if (moves.empty())
                {
                    moves = complex.validMoves(2);
                    if (moves.empty())
                    {
                        moves = complex.validMoves(1);
                        if (relaxation == 10)
                        {
                            heating = 15;
                            relaxation = 0;
                        }
                        relaxation++;
                    }
                }
            }
        }
        else if (complex.dimension() == 4)
        {
            if (heating > 0)
            {
                if (heating % 20 == 0)
                {
                    moves = complex.validMoves(0);
                }
                else
                {
                    moves = complex.validMoves(1);
                    bistellar_move_list_t temp = complex.validMoves(2);
                    if (!temp.empty())
                        moves.insert(moves.begin(), temp.begin(), temp.end());
                    
                    if (moves.empty())
                        moves = complex.validMoves(3);
                }
                heating--;
            }
            else
            {
                moves = complex.validMoves(4);
                if (moves.empty())
                {
                    moves = complex.validMoves(3);
                    if (moves.empty())
                    {
                        moves = complex.validMoves(2);
                        bistellar_move_list_t temp = complex.validMoves(1);
                        if (!temp.empty())
                            moves.insert(moves.begin(), temp.begin(), temp.end());

                        if (relaxation == 10)
                        {
                            heating = 20;
                            relaxation = 0;
                        }
                        relaxation++;
                    }
                }
            }
        }
        else if (complex.dimension() == 5)
        {
            if (heating > 0)
            {
                if (heating % 40 == 0)
                {
                    moves = complex.validMoves(0);
                }
                else
                {
                    moves = complex.validMoves(1);
                    bistellar_move_list_t temp = complex.validMoves(2);
                    if (!temp.empty())
                        moves.insert(moves.begin(), temp.begin(), temp.end());
                    temp = complex.validMoves(3);
                    if (!temp.empty())
                        moves.insert(moves.begin(), temp.begin(), temp.end());
                    
                    if (moves.empty())
                        moves = complex.validMoves(4);
                }
                heating--;
            }
            else
            {
                moves = complex.validMoves(5);
                if (moves.empty())
                {
                    moves = complex.validMoves(4);
                    if (moves.empty())
                    {
                        moves = complex.validMoves(3);
                        if (moves.empty())
                        {
                            moves = complex.validMoves(2);
                            bistellar_move_list_t temp = complex.validMoves(1);
                            if (!temp.empty())
                                moves.insert(moves.begin(), temp.begin(), temp.end());

                            if (relaxation == 20)
                            {
                                heating = 40;
                                relaxation = 0;
                            }
                            relaxation++;
                        }
                    }
                }
            }
            
        }
        else
        {
            if (heating > 0)
            {
                //if (heating % ((complex.dimension()+2)*baseHeating) == 0)
                //{
                //    moves = complex.validMoves(0);
                //}
                //else
                //{
                    for (unsigned int i = 1; i < complex.dimension()/2 + 1; i++)
                    {
                        bistellar_move_list_t temp = complex.validMoves(i);
                        if (!temp.empty())
                            moves.insert(moves.begin(), temp.begin(), temp.end());
                    }
                //}
                if (moves.empty())
                {
                    for (unsigned int i = 1; i < complex.dimension()+2; i++)
                    {
                        bistellar_move_list_t temp = complex.validMoves(complex.dimension() + 1 - i);
                        if (!temp.empty())
                        {
                            moves.insert(moves.begin(), temp.begin(), temp.end());
                            if (i > (complex.dimension()-1)/2)
                                break;
                        }
                    }
                }
                heating--;
            }
            else
            {
                if (complex.dimension() % 2 == 1)
                {
                    for (unsigned int i = 1; i < (complex.dimension()+1)/2 + 1; i++)
                    {
                        bistellar_move_list_t temp = complex.validMoves(complex.dimension() + 1 - i);
                        if (!temp.empty())
                        {
                            moves = temp;
                            break;
                        }
                    }
                }
                else
                {
                    for (unsigned int i = 1; i < std::min((complex.dimension()+1)/2 + 1, complex.dimension())+1; i++)
                    {
                        bistellar_move_list_t temp = complex.validMoves(complex.dimension() + 1 - i);
                        if (!temp.empty())
                        {
                            moves = temp;
                            break;
                        }
                    }
                }
                if (moves.empty())
                {
                    for (unsigned int i = 1; i < std::min((complex.dimension()+1)/2 + 1, complex.dimension())+1; i++)
                    {
                        bistellar_move_list_t temp = complex.validMoves(i);
                        if (!temp.empty())
                        {
                            moves = temp;
                            break;
                        }
                    }
                }
                if (relaxation == (complex.dimension()+2)*baseRelaxation)
                {
                    //heating = (complex.dimension()+2)*baseHeating;
		    heating = 1;
                    relaxation = 0;
                }
                relaxation++;
            }
        }
            
        // perform move
        if (moves.size() == 0)
            break;

        BistellarMove move = moves.at(rand() % moves.size());
        complex.moveComplex(move);
        
        if (complex.f(0) < minimalComplex.f(0))
        {
            minimalComplex = complex;
            std::cout << "found complex with " << minimalComplex.f(0) << " vertices in round " << currentRound << std::endl;
            
        }
    }
    complex = minimalComplex;
}
