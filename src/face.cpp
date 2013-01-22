//
//  face.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include "face.h"
#include <iostream>
#include <vector>
#include <string.h>
#include <stdlib.h>
#include "util.h"


Face::Face() : _vertices(0), _dimension(-1)
{
    
}

Face::Face(const vertex_t * vertices, int dimension) : _vertices(0), _dimension(dimension)
{
    if (_dimension < 0)
    {
        _dimension = -1;
    }
    else
    {
        _vertices = new vertex_t[dimension+1];
        memcpy(_vertices, vertices, (dimension+1)*sizeof(vertex_t));
        qsort(_vertices, dimension+1, sizeof(vertex_t), vertex_t_compare);
    }
}

Face::Face(const Face & cpy) : _vertices(0), _dimension(cpy._dimension)
{
    if (cpy._vertices != 0)
    {
        _vertices = new vertex_t[cpy._dimension+1];
        memcpy(_vertices, cpy._vertices, (cpy._dimension+1)*sizeof(vertex_t));
    }
}

Face::~Face()
{
    if (_vertices != 0)
    {
        delete[] _vertices;
    }
}

Face & Face::operator=(const Face & cpy)
{
    if (this == &cpy)
        return *this;
    
    if (_vertices != 0)
    {
        delete[] _vertices;
        _vertices = 0;
    }
    if (cpy._vertices != 0)
    {
        _vertices = new vertex_t[cpy._dimension+1];
        memcpy(_vertices, cpy._vertices, (cpy._dimension+1)*sizeof(vertex_t));
    }
    
    _dimension = cpy._dimension;
    
    return *this;
}

bool Face::operator==(const Face & cmp) const
{
    if (cmp._dimension != _dimension)
        return false;
    
    if (_vertices == 0 && cmp._vertices == 0)
        return true;
    if (_vertices == 0 || cmp._vertices == 0)
        return false;
        
    for (int i = 0; i < _dimension+1; i++)
    {
        if (vertex_t_compare(&cmp._vertices[i], &_vertices[i]) != 0)
            return false;
    }
    
    return true;
}

bool Face::operator!=(const Face & cmp) const
{
    return !(*this == cmp);
}

int Face::dimension() const
{
    return _dimension;
}

const vertex_t & Face::vertex(unsigned int i) const
{
    return _vertices[i];
}

Face * Face::createBoundaryFace( unsigned int i ) const
{
    if (i > _dimension || _vertices == 0)
        return 0;
    
    if (_dimension == 0)
        std::cout << "ERROR: tried to create boundary of a vertex." << std::endl;
    
    Face * boundaryFace = new Face;
    boundaryFace->_dimension = _dimension-1;
    boundaryFace->_vertices = new vertex_t[_dimension];
    if (i != 0)
        memcpy(&(boundaryFace->_vertices[0]), &(_vertices[0]), i*sizeof(vertex_t));
    if (i != _dimension)
        memcpy(&(boundaryFace->_vertices[i]), &(_vertices[i+1]), (_dimension-i)*sizeof(vertex_t));
    
    return boundaryFace;
}

bool Face::isSubfaceOf(const Face & face) const
{
    if (face._dimension < _dimension || _dimension == -1)
        return false;
    
    /*int j = 0;
    for (int i = 0; i < _dimension+1; i++)
    {
        while (j < face._dimension+1 && vertex_t_compare(&(_vertices[i]), &(face._vertices[j])) != 0)
            j++;
    }
     
    if (j > face._dimension)
        return false;*/
    
    int i = 0;
    int j = 0;
    while (i < _dimension+1 && j < face._dimension+1)
    {
        const int comparison = vertex_t_compare(&(_vertices[i]), &(face._vertices[j]));
        if (comparison == 0)
        {
            i++;
        }
        else if (comparison < 0)
        {
            return false;
        }
        j++;
    }
    
    if (i < _dimension+1)
        return false;
    
    return true;
}

// serialization methods
std::ostream & operator<< (std::ostream & os, const Face & face)
{
    if (face._vertices == 0)
    {
        os<<"[]";
    }
    else
    {
        list_print(os, &(face._vertices[0]), &(face._vertices[face._dimension+1]));
    }
        
    return os;
}
std::istream & operator>> (std::istream & is, Face & face)
{
    std::vector< vertex_t > vertices;
    list_read(is, vertices);
    
    if (vertices.empty())
    {
        face = Face();
    }
    else
    {
        face = Face(&vertices[0], static_cast<int>(vertices.size() - 1));
    }
    
    return is;
}

Face Face::linkFace(const Face & face, const face_list_t & linkFacets)
{
    size_t size = 0;
    for (face_list_t::const_iterator it = linkFacets.begin(); it != linkFacets.end(); it++)
    {
        size += it->_dimension+1;
    }

    vertex_t * linkVertices = new vertex_t[size];
    
    size_t pos = 0;
    for (face_list_t::const_iterator it = linkFacets.begin(); it != linkFacets.end(); it++)
    {
        memcpy(&(linkVertices[pos]), it->_vertices, (it->_dimension+1)*sizeof(vertex_t));
        pos += (it->_dimension+1);
    }
    
    qsort(linkVertices, size, sizeof(vertex_t), &vertex_t_compare);
    size = remove_duplicates(linkVertices, size, sizeof(vertex_t), &vertex_t_compare);
    size = remove_from_set(linkVertices, size, face._vertices, face._dimension+1, sizeof(vertex_t), &vertex_t_compare);
    
    Face linkFace(linkVertices, static_cast< int >(size)-1);
    delete[] linkVertices;
    
    return linkFace;
}

Face Face::unite(const Face & face1, const Face & face2)
{
    if (face1.dimension() == -1)
        return face2;
    if (face2.dimension() == -1)
        return face1;
    
    vertex_t * vertices = new vertex_t[face1._dimension + face2._dimension + 2];
    memcpy(vertices, face1._vertices, (face1._dimension+1)*sizeof(vertex_t));
    memcpy(&(vertices[face1._dimension+1]), face2._vertices, (face2._dimension+1)*sizeof(vertex_t));
    
    qsort(vertices, face1._dimension + face2._dimension + 2, sizeof(vertex_t), &vertex_t_compare);
    size_t size = remove_duplicates(vertices, face1._dimension + face2._dimension + 2, sizeof(vertex_t), &vertex_t_compare);
    
    Face unionFace(vertices, static_cast< int >(size)-1);
    delete[] vertices;
    
    return unionFace;
}


void addBoundaryfacesOfFace(const Face & face, face_list_t & listOfBoundaryfaces)
{
    vertex_t * boundaryfaceVertices = (face.dimension() < 1 ? 0 : new vertex_t[face.dimension()]);
    
    for (unsigned int i = 0; i < face.dimension(); i++)
        boundaryfaceVertices[i] = face.vertex(i+1);
    
    if (face.dimension() > 0)
        listOfBoundaryfaces.push_back(Face(boundaryfaceVertices, face.dimension()-1));
    for (unsigned int i = 0; i < face.dimension(); i++)
    {
        boundaryfaceVertices[i] = face.vertex(i);
        listOfBoundaryfaces.push_back(Face(boundaryfaceVertices, face.dimension()-1));
    }
    
    if (boundaryfaceVertices != 0)
        delete[] boundaryfaceVertices;
}

void incrementBitmask(std::vector< bool > & bitmask);

void addSubfacesOfFace(const Face & face, face_list_t & listOfSubfaces)
{
    vertex_t * subfaceVertices = (face.dimension() < 1 ? 0 : new vertex_t[face.dimension()]);
    
    std::vector< bool > bitmask(face.dimension()+1, false);
    for (unsigned long long int i = 0; i < (face.dimension() < 0 ? 0 : (1<<(face.dimension()+1))-2); i++)
    {
        incrementBitmask(bitmask);
        
        unsigned int subfaceSize = 0;
        std::vector< bool >::const_iterator it;
        unsigned int index;
        
        for (it = bitmask.begin(), index = 0; it != bitmask.end(); it++, index++)
        {
            if (*it)
            {
                subfaceVertices[subfaceSize] = face.vertex(index);
                subfaceSize++;
            }
        }
        
        listOfSubfaces.push_back(Face(subfaceVertices, subfaceSize-1));
    }
    
    if (subfaceVertices != 0)
        delete[] subfaceVertices;
}

void incrementBitmask(std::vector< bool > & bitmask)
{
    std::vector< bool >::iterator it = bitmask.begin();
    while (it != bitmask.end())
    {
        if ((*it = !*it))
            break;
        it++;
    }
}