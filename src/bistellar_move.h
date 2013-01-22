//
//  bistellar_move.h
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_bistellar_move_h
#define Bistellar_bistellar_move_h

#include <iostream>
#include "types.h"
#include "face.h"

class BistellarMove
{
    Face _face;
    Face _link;
    
public:
    BistellarMove();
    BistellarMove(const Face & face, const Face & link);
    
    BistellarMove(const BistellarMove & cpy);
    BistellarMove & operator=(const BistellarMove & cpy);
    
    ~BistellarMove();
    
    bool operator==(const BistellarMove & cmp) const;
    bool operator!=(const BistellarMove & cmp) const;
    
    const Face & face() const;
    const Face & link() const;
    
    unsigned int dimension() const;
    unsigned int codimension() const;
    
    // serialization methods
    friend std::ostream & operator<< (std::ostream & os, const BistellarMove & move);
    friend std::istream & operator>> (std::istream & is, BistellarMove & move);
};

#endif
