//
//  bistellar_move.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include "bistellar_move.h"

BistellarMove::BistellarMove() : _face(), _link()
{
    
}

BistellarMove::BistellarMove(const Face & face, const Face & link) : _face(face), _link(link)
{
    
}

BistellarMove::BistellarMove(const BistellarMove & cpy)
{
    _face = cpy._face;
    _link = cpy._link;
}

BistellarMove & BistellarMove::operator=(const BistellarMove & cpy)
{
    if (this == &cpy)
        return *this;
    
    _face = cpy._face;
    _link = cpy._link;
    
    return *this;
}

BistellarMove::~BistellarMove()
{
    
}

bool BistellarMove::operator==(const BistellarMove & cmp) const
{
    return _face == cmp._face && _link == cmp._link;
}

bool BistellarMove::operator!=(const BistellarMove & cmp) const
{
    return !(*this == cmp);
}

const Face & BistellarMove::face() const
{
    return _face;
}

const Face & BistellarMove::link() const
{
    return _link;
}

unsigned int BistellarMove::dimension() const
{
    return _face.dimension();
}

unsigned int BistellarMove::codimension() const
{
    return (_link.dimension() == -1) ? 0 : _link.dimension();
}

// serialization methods
std::ostream & operator<< (std::ostream & os, const BistellarMove & move)
{
    os << "[" << move._face << "," << move._link << "]";
    return os;
}
std::istream & operator>> (std::istream & is, BistellarMove & move)
{
    return is;
}