//
//  movable_complex.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include "movable_complex.h"
#include "face.h"
#include "util.h"
#include <algorithm>
#include <iostream>

MovableComplex::MovableComplex() : _faces(1, face_list_t(0)), _moves(1, bistellar_move_option_list_t(0)), _dimension(0)
{
}

MovableComplex::MovableComplex(const face_list_t & facets, unsigned int dimension) : _faces(dimension+1), _moves(dimension+1), _dimension(dimension)
{
    
    #ifdef Bistellar_debug_output
    std::cout << "Creating "<< dimension <<"-dimensional MovableComplex from Facets: ";
    list_print(std::cout, facets.begin(), facets.end());
    std::cout << std::endl;
    #endif
    
    // init facets
    _faces[dimension] = facets;
    
    // init lower dimensional faces
    for (int codimension = 1; codimension < dimension+1; codimension++)
    {
        if(!_faces[dimension - codimension + 1].empty())
        {
            for (face_list_t::const_iterator it = _faces[dimension - codimension + 1].begin();
             it != _faces[dimension - codimension + 1].end(); it++)
            {
                for (int i = 0; i < dimension - codimension + 2; i++)
                {
                    Face * boundaryFace = it->createBoundaryFace(i);
                    // only add boundaryFace if it is not already contained in complex
                    if (std::find(_faces[dimension - codimension].begin(), _faces[dimension - codimension].end(), *boundaryFace) == _faces[dimension - codimension].end())
                    {
                        _faces[dimension - codimension].push_back(*boundaryFace);
                    }
                    
                    delete boundaryFace;
                }
            }
        }
    }
    
    // init moves
    if (!_faces[dimension].empty())
    {
        for (face_list_t::const_iterator it = _faces[dimension].begin(); it != _faces[dimension].end(); it++)
        {
            // add all 0-moves
            _moves[0].push_back(std::make_pair(BistellarMove(*it, Face()), true));
        }
    }
    for (int codimension = 1; codimension < dimension+1; codimension++)
    {
        if (!_faces[dimension-codimension].empty())
        {
            for (face_list_t::const_iterator it = _faces[dimension-codimension].begin(); it != _faces[dimension-codimension].end(); it++)
            {
                std::deque< Face > linkFacets;
                // copy all Facets that contain (*it) as a subface to linkFacets
                if (!_faces[dimension].empty())
                {
                    for (face_list_t::const_iterator it2 = _faces[dimension].begin(); it2 != _faces[dimension].end(); it2++)
                    {
                        if (it->isSubfaceOf(*it2))
                            linkFacets.push_back(*it2);
                    }
                }
                
                if (linkFacets.size() == codimension+1)
                {
                    // add the move option.
                    Face linkFace = Face::linkFace(*it, linkFacets);
                    if (linkFace.dimension() <= _dimension)
                        _moves[codimension].push_back(std::make_pair(BistellarMove(*it, linkFace), (std::find(_faces[linkFace.dimension()].begin(), _faces[linkFace.dimension()].end(), linkFace) == _faces[linkFace.dimension()].end())));
                }
            }
        }
    }
    
    #ifdef Bistellar_debug_output
    for (int i = 0; i < dimension+1; i++)
    {
        std::cout << i << "-Moves: ";
        if (!_moves[i].empty()) list_print(std::cout, _moves[i].begin(), _moves[i].end());
        std::cout << std::endl;
    }
    #endif
}

MovableComplex::MovableComplex(const MovableComplex & cpy)
{
    _dimension = cpy._dimension;
    _faces = cpy._faces;
    _moves = cpy._moves;
}

MovableComplex & MovableComplex::operator=(const MovableComplex & cpy)
{
    if (this == &cpy)
        return *this;
    
    _dimension = cpy._dimension;
    _faces = cpy._faces;
    _moves = cpy._moves;
    
    return *this;
}

MovableComplex::~MovableComplex()
{
}

unsigned int MovableComplex::dimension() const
{
    return _dimension;
}

unsigned int MovableComplex::f(unsigned int d) const
{
    if (d <= _dimension)
        return static_cast<unsigned int>(_faces[d].size());
    
    return 0;
}

bool MovableComplex::hasValidMoves(unsigned int codimension) const
{
    if (!_moves[codimension].empty())
    {
        for (bistellar_move_option_list_t::const_iterator it = _moves[codimension].begin(); it != _moves[codimension].end(); it++)
        {
            if(it->second)
                return true;
        }
    }

    return false;
}

bistellar_move_list_t MovableComplex::validMoves(unsigned int codimension) const
{
    bistellar_move_list_t validMoves;
    if (!_moves[codimension].empty())
    {
        for (bistellar_move_option_list_t::const_iterator it = _moves[codimension].begin(); it != _moves[codimension].end(); it++)
        {
            if(it->second)
                validMoves.push_back(it->first);
        }
    }
    return validMoves;
}

void MovableComplex::moveComplex(const BistellarMove & move)
{
    face_list_t::iterator faceIt = std::find(_faces[move.dimension()].begin(), _faces[move.dimension()].end(), move.face());
    bistellar_move_option_list_t::iterator moveIt = std::find(_moves[move.codimension()].begin(), _moves[move.codimension()].end(), std::make_pair(move, true));
    
    if (faceIt != _faces[move.dimension()].end() && moveIt != _moves[move.codimension()].end() && moveIt->second)
    {
        #ifdef Bistellar_debug_output
        std::cout << "Applying " << move << " to complex ";
        list_print(std::cout, _faces[_dimension].begin(), _faces[_dimension].end());
        std::cout << "." << std::endl;
        #endif
        if (move.codimension() == 0)
        {
            // remove face*∂link
            _faces[move.dimension()].erase(faceIt);
            _moves[move.codimension()].erase(moveIt);
            
            // add ∂face*link
            vertex_t largestVertex = 0;
            if (!_faces[0].empty())
            {
                for (face_list_t::const_iterator it = _faces[0].begin(); it != _faces[0].end(); it++)
                {
                    if (vertex_t_compare(&largestVertex, &(it->vertex(0))) < 0)
                        largestVertex = it->vertex(0);
                }
            }
            largestVertex++;
            Face newVertex(&largestVertex, 0);
            _faces[0].push_back(newVertex);
            
            face_list_t listOfSubfaces;
            addSubfacesOfFace(move.face(), listOfSubfaces);
            face_list_t listOfBoundaryfaces;
            addBoundaryfacesOfFace(move.face(), listOfBoundaryfaces);
            if (!listOfSubfaces.empty())
            {
                for (face_list_t::iterator it = listOfSubfaces.begin(); it != listOfSubfaces.end(); it++)
                {
                    Face newFace = Face::unite(*it, newVertex);
                    // add new face to complex
                    _faces[newFace.dimension()].push_back(newFace);
                    
                    // add new move options
                    if (newFace.dimension() == this->dimension())
                    {
                        _moves[0].push_back(std::make_pair(BistellarMove(newFace, Face()), true));
                    }
                    else
                    {
                        face_list_t listOfLinkFaces;
                        for (face_list_t::iterator it2 = listOfBoundaryfaces.begin(); it2 != listOfBoundaryfaces.end(); it2++)
                        {
                            if (it->isSubfaceOf(*it2))
                                listOfLinkFaces.push_back(*it2);
                        }
                        if (listOfLinkFaces.size() == this->dimension() - it->dimension() + 1)
                        {
                            Face linkFace = Face::linkFace(*it, listOfLinkFaces);
                            if (linkFace.dimension() <= this->dimension())
                                _moves[this->dimension() - it->dimension()].push_back(std::make_pair(BistellarMove(*it, linkFace), false));
                        }
                    }
                }
                updateBallBoundary(*this, listOfSubfaces);
            }
        }
        else
        {
            // remove face*∂link
            face_list_t listOfLinkSubfaces;
            addSubfacesOfFace(move.link(), listOfLinkSubfaces);
            
            _faces[move.dimension()].erase(faceIt);
            _moves[move.codimension()].erase(moveIt);
            if (!listOfLinkSubfaces.empty())
            {
                for (face_list_t::iterator it = listOfLinkSubfaces.begin(); it != listOfLinkSubfaces.end(); it++)
                {
                    // remove old faces
                    Face oldFace = Face::unite(move.face(), *it);
                    face_list_t::iterator oldFaceIt = std::find(_faces[oldFace.dimension()].begin(), _faces[oldFace.dimension()].end(), oldFace);
                    if (oldFaceIt != _faces[oldFace.dimension()].end())
                        _faces[oldFace.dimension()].erase(oldFaceIt);
                    
                    // remove old moves
                    if (!_moves[this->dimension() - oldFace.dimension()].empty())
                    {
                        for (bistellar_move_option_list_t::iterator oldMoveIt = _moves[this->dimension() - oldFace.dimension()].begin(); oldMoveIt != _moves[this->dimension() - oldFace.dimension()].end(); oldMoveIt++)
                        {
                            if (oldMoveIt->first.face() == oldFace)
                            {
                                _moves[this->dimension() - oldFace.dimension()].erase(oldMoveIt);
                                break;
                            }
                        }
                    }
                }
            }
            
            // add ∂face*link
            face_list_t listOfFaceSubfaces;
            addSubfacesOfFace(move.face(), listOfFaceSubfaces);
            listOfFaceSubfaces.push_back(Face());
            if (!listOfFaceSubfaces.empty())
            {
                face_list_t listOfNewFacets;
                face_list_t listOfBallInteriorFaces;
                
                // add the new faces                
                for (face_list_t::iterator it = listOfFaceSubfaces.begin(); it != listOfFaceSubfaces.end(); it++)
                {
                    Face newFace = Face::unite(*it, move.link());

                    if (_faces[newFace.dimension()].empty() || std::find(_faces[newFace.dimension()].begin(), _faces[newFace.dimension()].end(), newFace) == _faces[newFace.dimension()].end())
                    {
                        _faces[newFace.dimension()].push_back(newFace);
                    }

                    if (newFace.dimension() == this->dimension())
                    {
                        listOfNewFacets.push_back(newFace);
                    }
                    else
                    {
                        listOfBallInteriorFaces.push_back(newFace);
                    }
                }
                
                // add the new moves
                for (face_list_t::iterator it = listOfFaceSubfaces.begin(); it != listOfFaceSubfaces.end(); it++)
                {
                    Face newFace = Face::unite(*it, move.link());
                    if (newFace.dimension() == this->dimension())
                    {
                        _moves[0].push_back(std::make_pair(BistellarMove(newFace, Face()),true));
                    }
                    else
                    {
                        face_list_t listOfLinkFaces;
                        for (face_list_t::iterator it2 = listOfNewFacets.begin(); it2 != listOfNewFacets.end(); it2++)
                        {
                            if (newFace.isSubfaceOf(*it2))
                                listOfLinkFaces.push_back(*it2);
                        }
                        if (listOfLinkFaces.size() == this->dimension() - newFace.dimension() + 1)
                        {
                            Face linkFace = Face::linkFace(newFace, listOfLinkFaces);
                            if (linkFace.dimension() <= this->dimension())
                                _moves[this->dimension() - newFace.dimension()].push_back(std::make_pair(BistellarMove(newFace, linkFace), false));
                        }
                    }
                }
                
                face_list_t listOfBallBounaryFaces;
                if (!listOfNewFacets.empty())
                {
                    for (face_list_t::iterator it = listOfNewFacets.begin(); it != listOfNewFacets.end(); it++)
                    {
                        face_list_t listOfNewFacetSubfaces;
                        addSubfacesOfFace(*it, listOfNewFacetSubfaces);
                        if (!listOfNewFacetSubfaces.empty())
                        {
                            for (face_list_t::iterator it2 = listOfNewFacetSubfaces.begin(); it2 != listOfNewFacetSubfaces.end(); it2++)
                            {
                                if ((listOfBallInteriorFaces.empty() || std::find(listOfBallInteriorFaces.begin(), listOfBallInteriorFaces.end(), *it2) == listOfBallInteriorFaces.end())
                                    && (listOfBallBounaryFaces.empty() || std::find(listOfBallBounaryFaces.begin(), listOfBallBounaryFaces.end(), *it2) == listOfBallBounaryFaces.end()))
                                    listOfBallBounaryFaces.push_back(*it2);
                            }
                        }
                    }
                }
                
                updateBallBoundary(*this, listOfBallBounaryFaces);
            }
        }
        
        updateMoveValidity(*this);
        
        #ifdef Bistellar_debug_output
        std::cout << "Resulting complex is ";
        list_print(std::cout, _faces[_dimension].begin(), _faces[_dimension].end());
        std::cout << "." << std::endl;
        for (int i = 0; i < _dimension+1; i++)
        {
            std::cout << _moves[i].size() << " " << i << "-Moves: ";
            if (!_moves[i].empty()) list_print(std::cout, _moves[i].begin(), _moves[i].end());
            std::cout << std::endl;
        }
        #endif
    }
    else
    {
        #ifdef Bistellar_debug_output
        std::cout << move << " is not a valid move for the complex " << *this << std::endl;
        #endif
    }
}

// used in the implementation of moveComplex
void updateBallBoundary(MovableComplex & complex, const face_list_t & ballBoundaryFaces)
{
    if (!ballBoundaryFaces.empty())
    {
        for (face_list_t::const_iterator it = ballBoundaryFaces.begin(); it != ballBoundaryFaces.end(); it++)
        {
            face_list_t linkFacets;
            // copy all facets that contain (*it) as a subface to linkFacets
            if (!complex._faces[complex._dimension].empty())
            {
                for (face_list_t::const_iterator it2 = complex._faces[complex._dimension].begin(); it2 != complex._faces[complex._dimension].end(); it2++)
                {
                    if (it->isSubfaceOf(*it2))
                        linkFacets.push_back(*it2);
                }
            }
            
            // remove the move option with (*it) as face
            if (!complex._moves[complex._dimension - it->dimension()].empty())
            {
                if (!complex._moves[complex._dimension - it->dimension()].empty())
                {
                    for (bistellar_move_option_list_t::iterator mIt = complex._moves[complex._dimension - it->dimension()].begin(); mIt != complex._moves[complex._dimension - it->dimension()].end(); mIt++)
                    {
                        if (mIt->first.face() == *it)
                        {
                            complex._moves[complex._dimension - it->dimension()].erase(mIt);
                            break;
                        }
                    }
                }
            }
            
            
            if (linkFacets.size() == complex._dimension - it->dimension() + 1)
            {
                // add the move option.
                Face linkFace = Face::linkFace(*it, linkFacets);
                if (linkFace.dimension() <= complex._dimension)
                    complex._moves[complex._dimension - it->dimension()].push_back(std::make_pair(BistellarMove(*it, linkFace), (std::find(complex._faces[linkFace.dimension()].begin(), complex._faces[linkFace.dimension()].end(), linkFace) == complex._faces[linkFace.dimension()].end())));
            }
        }
    }
}
void updateMoveValidity(MovableComplex & complex)
{
    for (unsigned int i = 1; i < complex._dimension + 1; i++)
    {
        if (!complex._moves[i].empty())
        {
            for (bistellar_move_option_list_t::iterator it = complex._moves[i].begin(); it != complex._moves[i].end(); it++)
                it->second = (std::find(complex._faces[it->first.link().dimension()].begin(), complex._faces[it->first.link().dimension()].end(), it->first.link()) == complex._faces[it->first.link().dimension()].end());
        }
    }
}

// serialization methods
std::ostream & operator<< (std::ostream & os, const MovableComplex & complex)
{
    if (!complex._faces[complex._dimension].empty())
    {
        list_print(os ,complex._faces[complex._dimension].begin(), complex._faces[complex._dimension].end());
    }
    else
    {
        os << "[]";
    }
    return os;
}
std::istream & operator>> (std::istream & is, MovableComplex & complex)
{
    std::deque< Face > facets;
    list_read(is, facets);
    
    if (facets.empty())
    {
        complex = MovableComplex();
    }
    else
    {
        complex = MovableComplex(facets, facets.begin()->dimension());
    }
    
    return is;
}
