//
//  movable_complex.h
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_movable_complex_h
#define Bistellar_movable_complex_h

class MovableComplex;

#include <vector>
#include <iostream>
#include "types.h"
#include "face.h"
#include "bistellar_move.h"

class MovableComplex
{
    unsigned int _dimension;
    
    std::vector< face_list_t > _faces;
    std::vector< bistellar_move_option_list_t > _moves;
    
public:
    MovableComplex();
    MovableComplex(const face_list_t & facets, unsigned int dimension);
    
    MovableComplex(const MovableComplex & cpy);
    MovableComplex & operator=(const MovableComplex & cpy);
    
    ~MovableComplex();
    
    unsigned int dimension() const;
    unsigned int f(unsigned int d) const;
    
    bool hasValidMoves(unsigned int codimension) const;
    bistellar_move_list_t validMoves(unsigned int codimension) const;
    void moveComplex(const BistellarMove & move);
    
    // serialization methods
    friend std::ostream & operator<< (std::ostream & os, const MovableComplex & complex);
    friend std::istream & operator>> (std::istream & is, MovableComplex & complex);
    
    // helper functions
    friend void updateBallBoundary(MovableComplex & complex, const face_list_t & ballBoundaryFaces);
    friend void updateMoveValidity(MovableComplex & complex);
};

#endif
