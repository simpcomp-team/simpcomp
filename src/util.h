//
//  util.h
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#ifndef Bistellar_util_h
#define Bistellar_util_h

#include <iostream>
#include <vector>
#include <deque>
#include <utility>

// prints a list in the format [a,b,...,z].
template< class Iterator >
void list_print(std::ostream & os, Iterator first, Iterator last)
{
    os << "[";
    if (first != last)
        os << *first << std::flush;
    for (first++; first != last; first++)
        os << "," << *first << std::flush;
    os << "]";
}

template< class Container, class Object >
void list_read(std::istream & is, Container & list)
{
    is.ignore(1, '[');
    
    if (is.eof() || is.peek() == ']')
    {
        is.ignore(1, ']');
    }
    else
    {
        is.unget();
        do {
            is.ignore(1, ',');
            Object newObject;
            is >> newObject;
            list.push_back(newObject);
        } while (!is.eof() && is.peek() != ']');
        
        is.ignore(1, ']');
    }
}

template< class T >
void list_read(std::istream & is, std::vector< T > & list)
{
    list_read< std::vector< T >, T >(is, list);
}

template< class T >
void list_read(std::istream & is, std::deque< T > & list)
{
    list_read< std::deque< T >, T >(is, list);
}


template< class T, class U >
std::ostream & operator<< (std::ostream & os, const std::pair<T,U> & pair )
{
    os << pair.first << "," << pair.second;
    return os;
}


// removes all duplivates from the !sorted! array base.
size_t remove_duplicates(void * base, size_t num, size_t size, int (* comparison)(const void *, const void *));
// removes all elements of the !sorted! array base2 from the !sorted! array base.
size_t remove_from_set(void * base, size_t num, const void * base2, size_t num2, size_t size, int (* comparison)(const void *, const void *));

#endif
