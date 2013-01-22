//
//  randomize_complex.h
//  Bistellar
//
//  Created by Alexander Thumm on 19.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_randomize_complex_h
#define Bistellar_randomize_complex_h

#include "movable_complex.h"
#include <vector>

void randomize_complex(MovableComplex & complex, const std::vector< unsigned int > & allowedMoves, unsigned int rounds);

#endif
