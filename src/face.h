//
//  face.h
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_face_h
#define Bistellar_face_h

#include <iostream>
#include <deque>
#include "types.h"

class Face
{
    vertex_t * _vertices;
    int _dimension;
    
public:
    Face();
    Face(const vertex_t * vertices, int dimension);
    
    Face(const Face & cpy);
    Face & operator=(const Face & cpy);
    
    ~Face();
    
    bool operator==(const Face & cmp) const;
    bool operator!=(const Face & cmp) const;
    
    int dimension() const;
    
    // returns a reference to the i-th vertex.
    const vertex_t & vertex(unsigned int i) const;
    
    // returns the boundary face obtained by omitting the i-th vertex.
    Face * createBoundaryFace(unsigned int i) const;
    
    // tests if the face is a subface of face
    bool isSubfaceOf(const Face & face) const;
    
    
    // create linkFace
    static Face linkFace(const Face & face, const face_list_t & linkFacets);
    // create union
    static Face unite(const Face & face1, const Face & face2);
    
    
    // serialization methods
    friend std::ostream & operator<< (std::ostream & os, const Face & face);
    friend std::istream & operator>> (std::istream & is, Face & face);
};

// adds all boundaryfaces of face to listOfBoundaryfaces
void addBoundaryfacesOfFace(const Face & face, face_list_t & listOfBoundaryfaces);
// adds all subfaces of face to listOfSubfaces
void addSubfacesOfFace(const Face & face, face_list_t & listOfSubfaces);

#endif
