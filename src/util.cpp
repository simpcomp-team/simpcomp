//
//  util.cpp
//  Bistellar
//
//  Created by Alexander Thumm on 07.10.11.
//  Copyright 2011 -. All rights reserved.
//

#include "util.h"
#include <stdlib.h>
#include <string.h>

size_t remove_duplicates(void * base, size_t num, size_t size, int (* comparison)(const void *, const void *))
{
    if (num == 0)
        return 0;
    
    size_t new_num = 1;
    
    const unsigned char * read = static_cast< const unsigned char * >(base);
    unsigned char * write = static_cast< unsigned char * >(base);
    
    for (size_t i = 1; i < num; i++)
    {
        read += size;
        if ((*comparison)(read, write) != 0)
        {
            write += size;            
            if (write != read)
                memcpy(write, read, size);
            
            new_num++;
        }
    }
    
    return new_num;
}

size_t remove_from_set(void * base, size_t num, const void * base2, size_t num2, size_t size, int (* comparison)(const void *, const void *))
{
    if (num == 0 || num2 == 0)
        return 0;
    
    size_t new_num = 0;
    
    const unsigned char * read = static_cast< const unsigned char * >(base);
    const unsigned char * read2 = static_cast< const unsigned char *>(base2);
    unsigned char * write = static_cast< unsigned char * >(base);
    
    size_t i = 0;
    size_t j = 0;
    
    while (i < num)
    {
        int difference = (j < num2) ? (*comparison)(read, read2) : -1;

        if (difference < 0)
        {
            if (write != read)
                memcpy(write, read, size);
            read += size;
            write += size;
            new_num++;
            i++;
        }
        else if (difference == 0)
        {
            read += size;
            i++;
        }
        else
        {
            read2 += size;
            j++;
        }
    }
    
    return new_num;
}
