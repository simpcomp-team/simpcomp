//
//  types.h
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_types_h
#define Bistellar_types_h

#include <deque>
#include <utility>

class Face;
class BistellarMove;

// type used for vertices. The type in use must provide istream and ostream functionality, be comparable and storable in STL container classes.
typedef unsigned int vertex_t;

inline int vertex_t_compare(const void * v1, const void * v2)
{
    return *(static_cast<const vertex_t *>(v1)) - *(static_cast<const vertex_t *>(v2));
}

// type used for face lists
typedef std::deque< Face > face_list_t;

// type used for bistellar move lists
typedef std::deque< BistellarMove > bistellar_move_list_t;
// type used for bistellar move option lists
typedef std::deque< std::pair< BistellarMove, bool> > bistellar_move_option_list_t;


// uncomment this for debug output
//#define Bistellar_debug_output

#endif
