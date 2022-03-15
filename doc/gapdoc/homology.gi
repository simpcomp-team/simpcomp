################################################################################
##
##  simpcomp / homology.gi
##
##  Homology related functions
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCBoundarySimplex">
## <ManSection>
## <Func Name="SCBoundarySimplex" Arg="simplex, orientation"/>
## <Returns> a list upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the boundary of a given <Arg>simplex</Arg>. If the flag <Arg>orientation</Arg> is set to <K>true</K>, the function returns the boundary as a list of oriented simplices of the form [ ORIENTATION, SIMPLEX ], where ORIENTATION is either +1 or -1 and a value of +1 means that SIMPLEX is positively oriented and a value of -1 that SIMPLEX is negatively oriented. If <Arg>orientation</Arg> is set to <K>false</K>, an unoriented list of simplices is returned. 
## <Example><![CDATA[
## gap> SCBoundarySimplex([1..5],true);
## [ [ -1, [ 2, 3, 4, 5 ] ], [ 1, [ 1, 3, 4, 5 ] ], [ -1, [ 1, 2, 4, 5 ] ], 
##   [ 1, [ 1, 2, 3, 5 ] ], [ -1, [ 1, 2, 3, 4 ] ] ]
## gap> SCBoundarySimplex([1..5],false);
## [ [ 2, 3, 4, 5 ], [ 1, 3, 4, 5 ], [ 1, 2, 4, 5 ], [ 1, 2, 3, 5 ], 
##   [ 1, 2, 3, 4 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCBoundaryOperatorMatrix">
## <ManSection>
## <Meth Name="SCBoundaryOperatorMatrix" Arg="complex,k"/>
## <Returns> a rectangular matrix  upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the matrix of the boundary operator <M>\partial_{<Arg>k+1</Arg>}</M> of a simplicial complex <Arg>complex</Arg>. Note that each column contains the boundaries of a <Arg>k</Arg><M>+1</M>-simplex as a list of oriented <Arg>k</Arg>-simplices and that the matrix is stored as a list of row vectors (as usual in GAP).
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],\
##                       [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]);;
## gap> mat:=SCBoundaryOperatorMatrix(c,1);
## [ [ 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
##   [ -1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 ], 
##   [ 0, -1, 0, 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0 ], 
##   [ 0, 0, -1, 0, 0, 0, -1, 0, 0, -1, 0, 0, 1, 1, 0 ], 
##   [ 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, -1, 0, -1, 0, 1 ], 
##   [ 0, 0, 0, 0, -1, 0, 0, 0, -1, 0, 0, -1, 0, -1, -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCoboundaryOperatorMatrix">
## <ManSection>
## <Meth Name="SCCoboundaryOperatorMatrix" Arg="complex,k"/>
## <Returns> a rectangular matrix upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates the matrix of the coboundary operator <M>d^{<Arg>k+1</Arg>}</M> as a list of row vectors.
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],\
##                       [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]);
## > <SimplicialComplex: unnamed complex 2 | dim = 2 | n = 6>
## gap> mat:=SCCoboundaryOperatorMatrix(c,1);
## [ [ -1, 1, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
##   [ -1, 0, 0, 0, 1, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0 ], 
##   [ 0, -1, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0 ], 
##   [ 0, 0, -1, 1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0 ], 
##   [ 0, 0, -1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0 ], 
##   [ 0, 0, 0, 0, 0, -1, 1, 0, 0, -1, 0, 0, 0, 0, 0 ], 
##   [ 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0, 0, -1, 0, 0 ], 
##   [ 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0, 0, 0, -1 ], 
##   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 1, 0, -1, 0 ], 
##   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomologyBasis">
## <ManSection>
## <Meth Name="SCHomologyBasis" Arg="complex,k"/>
## <Returns> a list of pairs of the form <C>[ integer, list of linear combinations of simplices ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates a set of basis elements for the <Arg>k</Arg>-dimensional homology group (with integer coefficients) of a simplicial complex <Arg>complex</Arg>. The entries of the returned list are of the form [ MODULUS, [ BASEELM1, BASEELM2, ...] ], where the value MODULUS is 1 for the basis elements of the free part of the <Arg>k</Arg>-th homology group and <M>q\geq 2</M> for the basis elements of the <M>q</M>-torsion part. In contrast to the function <Ref Meth="SCHomologyBasisAsSimplices" /> the basis elements are stored as lists of coefficient-index pairs referring to the simplices of the complex, i.e. a basis element of the form <M>[ [ \lambda_1, i], [\lambda_2, j], \dots ] \dots</M> encodes the linear combination of simplices of the form <M>\lambda_1*\Delta_1+\lambda_2*\Delta_2</M> with <M>\Delta_1</M>=<C>SCSkel(complex,k)[i]</C>, <M>\Delta_2</M>=<C>SCSkel(complex,k)[j]</C> and so on.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#RP^3");
## [ [ 237, "(S^2xS^1)#RP^3" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomologyBasis(c,1);
## [ [ 1, [ [ 1, 12 ], [ -1, 7 ], [ 1, 1 ] ] ], 
##   [ 2, [ [ 1, 68 ], [ -1, 69 ], [ -1, 71 ], [ 2, 72 ], [ -2, 73 ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCohomologyBasis">
## <ManSection>
## <Meth Name="SCCohomologyBasis" Arg="complex,k"/>
## <Returns> a list of pairs of the form <C>[ integer, list of linear combinations of simplices ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates a set of basis elements for the <Arg>k</Arg>-dimensional cohomology group (with integer coefficients) of a simplicial complex <Arg>complex</Arg>. The entries of the returned list are of the form [ MODULUS, [ BASEELM1, BASEELM2, ...] ], where the value MODULUS is 1 for the basis elements of the free part of the <Arg>k</Arg>-th homology group and <M>q\geq 2</M> for the basis elements of the <M>q</M>-torsion part. In contrast to the function <Ref Meth="SCCohomologyBasisAsSimplices" /> the basis elements are stored as lists of coefficient-index pairs referring to the linear forms dual to the simplices in the <M>k</M>-th cochain complex of <Arg>complex</Arg>, i.e. a basis element of the form <M>[ [ \lambda_1, i], [\lambda_2, j], \dots ] \dots</M> encodes the linear combination of simplices (or their dual linear forms in the corresponding cochain complex) of the form <M>\lambda_1*\Delta_1+\lambda_2*\Delta_2</M> with <M>\Delta_1</M>=<C>SCSkel(complex,k)[i]</C>, <M>\Delta_2</M>=<C>SCSkel(complex,k)[j]</C> and so on.
## <Example><![CDATA[
## gap> SCLib.SearchByName("SU(3)/SO(3)");   
## [ [ 219, "SU(3)/SO(3) (VT)" ], [ 477, "SU(3)/SO(3) (VT)" ], 
##   [ 484, "SU(3)/SO(3) (VT)" ], [ 486, "SU(3)/SO(3) (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCCohomologyBasis(c,3); 
## [ [ 2, [ [ -9, 259 ], [ 9, 262 ], [ 9, 263 ], [ -9, 270 ], [ 9, 271 ], 
##           [ -9, 273 ], [ -9, 274 ], [ -18, 275 ], [ -9, 276 ], [ 9, 278 ], 
##           [ -9, 279 ], [ -9, 280 ], [ 3, 283 ], [ -3, 285 ], [ 3, 289 ], 
##           [ -3, 294 ], [ 3, 310 ], [ -3, 313 ], [ 3, 316 ], [ -1, 317 ], 
##           [ -6, 318 ], [ 3, 319 ], [ -6, 320 ], [ 6, 321 ], [ 1, 322 ], 
##           [ 3, 325 ], [ -1, 328 ], [ 6, 330 ], [ -2, 331 ], [ 12, 332 ], 
##           [ 7, 333 ], [ -5, 334 ], [ 1, 345 ], [ 3, 355 ], [ -9, 357 ], 
##           [ 9, 358 ], [ 1, 363 ], [ 12, 365 ], [ -9, 366 ], [ -3, 370 ], 
##           [ -1, 371 ], [ -3, 372 ], [ 8, 373 ], [ -1, 374 ], [ 6, 375 ], 
##           [ 9, 376 ], [ 3, 377 ], [ 1, 380 ], [ 3, 383 ], [ -8, 385 ], 
##           [ -9, 386 ], [ -9, 388 ], [ -18, 404 ], [ 9, 410 ], [ -9, 425 ], 
##           [ -18, 426 ], [ -9, 427 ], [ 9, 428 ], [ -9, 429 ], [ 3, 433 ], 
##           [ -3, 435 ], [ -9, 437 ], [ 10, 442 ], [ 12, 445 ], [ 1, 447 ], 
##           [ -19, 448 ], [ 2, 449 ], [ -1, 450 ], [ -9, 451 ], [ 3, 453 ], 
##           [ 1, 455 ], [ 1, 457 ], [ -11, 458 ], [ -9, 459 ], [ 9, 461 ], 
##           [ 9, 462 ], [ -9, 468 ], [ 9, 469 ], [ -18, 471 ], [ -9, 472 ], 
##           [ 9, 474 ], [ -9, 475 ], [ 9, 488 ], [ 9, 495 ], [ -9, 500 ], 
##           [ -3, 504 ], [ 9, 505 ], [ 9, 512 ], [ 9, 515 ], [ 6, 519 ], 
##           [ 18, 521 ], [ -15, 523 ], [ 9, 524 ], [ -3, 525 ], [ 18, 527 ], 
##           [ -18, 528 ], [ 6, 529 ], [ 6, 531 ], [ 12, 532 ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomologyBasisAsSimplices">
## <ManSection>
## <Meth Name="SCHomologyBasisAsSimplices" Arg="complex, k"/>
## <Returns> a list of pairs of the form <C>[ integer, list of linear combinations of simplices ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates a set of basis elements for the <Arg>k</Arg>-dimensional homology group (with integer coefficients) of a simplicial complex <Arg>complex</Arg>. The entries of the returned list are of the form [ MODULUS, [ BASEELM1, BASEELM2, ...] ], where the value MODULUS is 1 for the basis elements of the free part of the <Arg>k</Arg>-th homology group and <M>q\geq 2</M> for the basis elements of the <M>q</M>-torsion part. In contrast to the function <Ref Meth="SCHomologyBasis" /> the basis elements are stored as lists of coefficient-simplex pairs, i.e. a basis element of the form <M>[ [ \lambda_1, \Delta_1], [\lambda_2, \Delta_2], \dots ]</M> encodes the linear combination of simplices of the form <M>\lambda_1*\Delta_1+\lambda_2*\Delta_2 + \dots</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("(S^2xS^1)#RP^3");
## [ [ 237, "(S^2xS^1)#RP^3" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCHomologyBasisAsSimplices(c,1);
## [ [ 1, [ [ 1, [ 2, 8 ] ], [ -1, [ 1, 8 ] ], [ 1, [ 1, 2 ] ] ] ], 
##   [ 2, 
##       [ [ 1, [ 11, 12 ] ], [ -1, [ 11, 13 ] ], [ -1, [ 12, 13 ] ], 
##           [ 2, [ 12, 14 ] ], [ -2, [ 13, 14 ] ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCohomologyBasisAsSimplices">
## <ManSection>
## <Meth Name="SCCohomologyBasisAsSimplices" Arg="complex, k"/>
## <Returns> a list of pars of the form <C>[ integer, linear combination of simplices ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Calculates a set of basis elements for the <Arg>k</Arg>-dimensional cohomology group (with integer coefficients) of a simplicial complex <Arg>complex</Arg>. The entries of the returned list are of the form [ MODULUS, [ BASEELM1, BASEELM2, ...] ], where the value MODULUS is 1 for the basis elements of the free part of the <Arg>k</Arg>-th homology group and <M>q\geq 2</M> for the basis elements of the <M>q</M>-torsion part. In contrast to the function <Ref Meth="SCCohomologyBasis" /> the basis elements are stored as lists of coefficient-simplex pairs referring to the linear forms dual to the simplices in the <M>k</M>-th cochain complex of <Arg>complex</Arg>, i.e. a basis element of the form <M>[ [ \lambda_1, \Delta_i], [\lambda_2, \Delta_j], \dots ] \dots</M> encodes the linear combination of simplices (or their dual linear forms in the corresponding cochain complex) of the form <M>\lambda_1*\Delta_1+\lambda_2*\Delta_2 + \dots</M>.
## <Example><![CDATA[
## gap> SCLib.SearchByName("SU(3)/SO(3)");   
## [ [ 219, "SU(3)/SO(3) (VT)" ], [ 477, "SU(3)/SO(3) (VT)" ], 
##   [ 484, "SU(3)/SO(3) (VT)" ], [ 486, "SU(3)/SO(3) (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCCohomologyBasisAsSimplices(c,3);
## [ [ 2, 
##       [ [ -9, [ 2, 7, 8, 9 ] ], [ 9, [ 2, 7, 8, 12 ] ], 
##           [ 9, [ 2, 7, 8, 13 ] ], [ -9, [ 2, 7, 11, 12 ] ], 
##           [ 9, [ 2, 7, 11, 13 ] ], [ -9, [ 2, 8, 9, 10 ] ], 
##           [ -9, [ 2, 8, 9, 11 ] ], [ -18, [ 2, 8, 9, 12 ] ], 
##           [ -9, [ 2, 8, 9, 13 ] ], [ 9, [ 2, 8, 10, 12 ] ], 
##           [ -9, [ 2, 8, 10, 13 ] ], [ -9, [ 2, 8, 11, 12 ] ], 
##           [ 3, [ 2, 9, 10, 12 ] ], [ -3, [ 2, 9, 11, 12 ] ], 
##           [ 3, [ 3, 4, 5, 7 ] ], [ -3, [ 3, 4, 5, 12 ] ], 
##           [ 3, [ 3, 4, 10, 12 ] ], [ -3, [ 3, 5, 6, 7 ] ], 
##           [ 3, [ 3, 5, 6, 11 ] ], [ -1, [ 3, 5, 6, 13 ] ], 
##           [ -6, [ 3, 5, 7, 8 ] ], [ 3, [ 3, 5, 7, 10 ] ], 
##           [ -6, [ 3, 5, 7, 11 ] ], [ 6, [ 3, 5, 7, 12 ] ], 
##           [ 1, [ 3, 5, 7, 13 ] ], [ 3, [ 3, 5, 8, 12 ] ], 
##           [ -1, [ 3, 5, 9, 13 ] ], [ 6, [ 3, 5, 10, 12 ] ], 
##           [ -2, [ 3, 5, 10, 13 ] ], [ 12, [ 3, 5, 11, 12 ] ], 
##           [ 7, [ 3, 5, 11, 13 ] ], [ -5, [ 3, 5, 12, 13 ] ], 
##           [ 1, [ 3, 6, 9, 13 ] ], [ 3, [ 3, 7, 10, 12 ] ], 
##           [ -9, [ 3, 7, 11, 12 ] ], [ 9, [ 3, 7, 11, 13 ] ], 
##           [ 1, [ 3, 8, 9, 13 ] ], [ 12, [ 3, 8, 10, 12 ] ], 
##           [ -9, [ 3, 8, 10, 13 ] ], [ -3, [ 3, 9, 10, 12 ] ], 
##           [ -1, [ 3, 9, 10, 13 ] ], [ -3, [ 3, 9, 11, 12 ] ], 
##           [ 8, [ 3, 9, 11, 13 ] ], [ -1, [ 3, 9, 12, 13 ] ], 
##           [ 6, [ 3, 10, 11, 12 ] ], [ 9, [ 3, 10, 11, 13 ] ], 
##           [ 3, [ 3, 10, 12, 13 ] ], [ 1, [ 4, 5, 6, 8 ] ], 
##           [ 3, [ 4, 5, 6, 11 ] ], [ -8, [ 4, 5, 6, 13 ] ], 
##           [ -9, [ 4, 5, 7, 8 ] ], [ -9, [ 4, 5, 7, 11 ] ], 
##           [ -18, [ 4, 6, 8, 9 ] ], [ 9, [ 4, 6, 9, 13 ] ], 
##           [ -9, [ 4, 8, 9, 10 ] ], [ -18, [ 4, 8, 9, 12 ] ], 
##           [ -9, [ 4, 8, 9, 13 ] ], [ 9, [ 4, 8, 10, 12 ] ], 
##           [ -9, [ 4, 8, 10, 13 ] ], [ 3, [ 4, 9, 10, 12 ] ], 
##           [ -3, [ 4, 9, 11, 12 ] ], [ -9, [ 4, 9, 12, 13 ] ], 
##           [ 10, [ 5, 6, 7, 8 ] ], [ 12, [ 5, 6, 7, 11 ] ], 
##           [ 1, [ 5, 6, 7, 13 ] ], [ -19, [ 5, 6, 8, 9 ] ], 
##           [ 2, [ 5, 6, 8, 11 ] ], [ -1, [ 5, 6, 8, 12 ] ], 
##           [ -9, [ 5, 6, 8, 13 ] ], [ 3, [ 5, 6, 9, 11 ] ], 
##           [ 1, [ 5, 6, 9, 13 ] ], [ 1, [ 5, 6, 10, 13 ] ], 
##           [ -11, [ 5, 6, 11, 13 ] ], [ -9, [ 5, 7, 8, 9 ] ], 
##           [ 9, [ 5, 7, 8, 12 ] ], [ 9, [ 5, 7, 8, 13 ] ], 
##           [ -9, [ 5, 7, 11, 12 ] ], [ 9, [ 5, 7, 11, 13 ] ], 
##           [ -18, [ 5, 8, 9, 12 ] ], [ -9, [ 5, 8, 9, 13 ] ], 
##           [ 9, [ 5, 8, 10, 12 ] ], [ -9, [ 5, 8, 11, 12 ] ], 
##           [ 9, [ 6, 7, 8, 13 ] ], [ 9, [ 6, 7, 11, 13 ] ], 
##           [ -9, [ 6, 8, 10, 13 ] ], [ -3, [ 6, 9, 11, 12 ] ], 
##           [ 9, [ 6, 9, 11, 13 ] ], [ 9, [ 7, 8, 9, 13 ] ], 
##           [ 9, [ 7, 8, 11, 12 ] ], [ 6, [ 7, 9, 11, 12 ] ], 
##           [ 18, [ 7, 11, 12, 13 ] ], [ -15, [ 8, 9, 10, 12 ] ], 
##           [ 9, [ 8, 9, 10, 13 ] ], [ -3, [ 8, 9, 11, 12 ] ], 
##           [ 18, [ 8, 10, 11, 12 ] ], [ -18, [ 8, 10, 12, 13 ] ], 
##           [ 6, [ 9, 10, 11, 12 ] ], [ 6, [ 9, 10, 12, 13 ] ], 
##           [ 12, [ 9, 11, 12, 13 ] ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomologyInternal">
## <ManSection>
## <Func Name="SCHomologyInternal" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ integer, list ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the reduced simplicial homology with integer coefficients of a given simplicial complex <Arg>complex</Arg> with integer coefficients. It uses the algorithm described in <Cite Key="Desbrun08DiscDiffFormCompModel"/>. <P/>
## The output is a list of homology groups of the form <M>[H_0,....,H_d]</M>, where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the homology groups <M>H_i</M> is given in terms of their maximal cyclic subgroups, i.e. a homology group <M>H_i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) free part of <M>H_i</M> and <M>t_i</M> denotes the torsion parts of <M>H_i</M> ordered in weakly incresing size. See also <Ref Meth="SCHomology"/> and
## <Ref Func="SCHomologyClassic" />.
## <Example><![CDATA[
## gap> c:=SCSurface(1,false);;
## gap> SCHomologyInternal(c);
## [ [ 0, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCohomology">
## <ManSection>
## <Meth Name="SCCohomology" Arg="complex"/>
## <Returns> a list of pairs of the form <C>[ integer, list ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the simplicial cohomology groups of a given simplicial complex <Arg>complex</Arg> with integer coefficients. It uses the algorithm described in <Cite Key="Desbrun08DiscDiffFormCompModel"/>.<P/>
## The output is a list of cohomology groups of the form <M>[H^0,....,H^d]</M>, where <M>d</M> is the dimension of <Arg>complex</Arg>. The format of the cohomology groups <M>H^i</M> is given in terms of their maximal cyclic subgroups, i.e. a cohomology group <M>H^i\cong \mathbb{Z}^f + \mathbb{Z} / t_1 \mathbb{Z} \times \dots \times \mathbb{Z} / t_n \mathbb{Z}</M> is returned in form of a list <M>[ f, [t_1,...,t_n] ]</M>, where <M>f</M> is the (integer) free part of <M>H^i</M> and <M>t_i</M> denotes the torsion parts of <M>H^i</M> ordered in weakly increasing size.
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],
##                       [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]);
## > <SimplicialComplex: unnamed complex 4 | dim = 2 | n = 6>
## gap> SCCohomology(c);
## [ [ 1, [  ] ], [ 0, [  ] ], [ 0, [ 2 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCCupProduct">
## <ManSection>
## <Func Name="SCCupProduct" Arg="complex,cocycle1,cocycle2"/>
## <Returns> a list of pairs of the form <C>[ ORIENTATION, SIMPLEX ]</C> upon success, <K>fail</K> otherwise. </Returns>
## <Description>
## The cup product is a method of adjoining two cocycles of degree <M>p</M> and <M>q</M> to form a composite cocycle of degree <M>p + q</M>. It endows the cohomology groups of a simplicial complex with the structure of a ring. <P/>
## The construction of the cup product starts with a product of cochains: if <Arg>cocycle1</Arg> is a p-cochain and <Arg>cocylce2</Arg> is a q-cochain of a simplicial complex <Arg>complex</Arg> (given as list of oriented p- (q-)simplices), then<P/>
## <Arg>cocycle1</Arg> <M>\smile</M> <Arg>cocycle2</Arg><M>(\sigma) = </M><Arg>cocycle1</Arg><M>(\sigma \circ \iota_{0,1, ... p}) \cdot</M> <Arg>cocycle2</Arg><M>(\sigma \circ \iota_{p, p+1 ,..., p + q})</M><P/>
## where <M>\sigma</M> is a <M>p + q</M>-simplex and <M>\iota_S</M>, <M>S \subset \{0,1,...,p+q \}</M> is the canonical embedding of the simplex spanned by <M>S</M> into the <M>(p + q)</M>-standard simplex.<P/>
## <M>\sigma \circ \iota_{0,1, ..., p}</M> is called the <M>p</M>-th front face and <M>\sigma \circ \iota_{p, p+1, ..., p + q}</M> is the <M>q</M>-th back face of <M>\sigma</M>, respectively.<P/>
## Note that this function only computes the cup product in the case that <Arg>complex</Arg> is an orientable weak pseudomanifold of dimension <M>2k</M> and <M>p = q = k</M>. Furthermore, <Arg>complex</Arg> must be given in standard labeling, with sorted facet list and <Arg>cocylce1</Arg> and <Arg>cocylce2</Arg> must be given in simplex notation and labeled accordingly. Note that the latter condition is usually fulfilled in case the cocycles were computed using <Ref Meth="SCCohomologyBasisAsSimplices"/>.  
## <Example><![CDATA[
## gap> SCLib.SearchByName("K3");
## [ [ 520, "K3_16" ], [ 539, "K3_17" ] ]
## gap> c:=SCLib.Load(last[1][1]);;                                     
## gap> basis:=SCCohomologyBasisAsSimplices(c,2);;
## gap> SCCupProduct(c,basis[1][2],basis[1][2]);
## [ [ 1, [ 1, 2, 4, 7, 11 ] ], [ 1, [ 2, 3, 4, 5, 9 ] ] ]
## gap> SCCupProduct(c,basis[1][2],basis[2][2]);
## [ [ -1, [ 1, 2, 4, 7, 11 ] ], [ -1, [ 1, 2, 4, 7, 15 ] ], 
##   [ -1, [ 2, 3, 4, 5, 9 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIntersectionForm">
## <ManSection>
## <Meth Name="SCIntersectionForm" Arg="complex"/>
## <Returns> a square matrix of integer values upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## For <M>2k</M>-dimensional orientable manifolds <M>M</M> the cup product (see <Ref Meth="SCCupProduct"/>) defines a bilinear form <P/>
## H<M>^k ( M ) \times </M>H<M>^k ( M ) \to </M>H<M>^{2k} (M), (a,b) \mapsto a \cup b </M><P/>
## called the intersection form of <M>M</M>. This function returns the intersection form of an orientable combinatorial <M>2k</M>-manifold <Arg>complex</Arg> in form of a matrix <C>mat</C> with respect to the basis of  H<M>^k ( </M><Arg>complex</Arg>M<M>)</M> computed by <Ref Meth="SCCohomologyBasisAsSimplices"/>. The matrix entry <C>mat[i][j]</C> equals the intersection number of the <C>i</C>-th base element with the <C>j</C>-th base element of H<M>^k ( </M><Arg>complex</Arg>M<M>)</M>. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");       
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], [ 97, "CP^2#CP^2" ], 
##   [ 185, "CP^2#(S^2xS^2)" ], [ 397, "Gaifullin CP^2" ], 
##   [ 457, "(S^3~S^1)#(CP^2)^{#5} (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);; 
## gap> c1:=SCConnectedSum(c,c);;
## gap> c2:=SCConnectedSumMinus(c,c);;
## gap> q1:=SCIntersectionForm(c1);;
## gap> q2:=SCIntersectionForm(c2);;
## gap> PrintArray(q1);
## [ [  1,  0 ],
##   [  0,  1 ] ]
## gap> PrintArray(q2);
## [ [   1,   0 ],
##   [   0,  -1 ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIntersectionFormParity">
## <ManSection>
## <Meth Name="SCIntersectionFormParity" Arg="complex"/>
## <Returns> <C>0</C> or <C>1</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the parity of the intersection form of a combinatorial manifold <Arg>complex</Arg> (see <Ref Meth="SCIntersectionForm"/>). If the intersection for is even (i. e. all diagonal entries are even numbers) <C>0</C> is returned, otherwise <C>1</C> is returned.
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^2xS^2");;
## gap> c:=SCLib.Load(last[1][1]);;    
## gap> SCIntersectionFormParity(c);
## 0
## gap> SCLib.SearchByName("CP^2");;     
## gap> c:=SCLib.Load(last[1][1]);; 
## gap> SCIntersectionFormParity(c);
## 1
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIntersectionFormDimensionality">
## <ManSection>
## <Meth Name="SCIntersectionFormDimensionality" Arg="complex"/>
## <Returns> an integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the dimensionality of the intersection form of a combinatorial manifold <Arg>complex</Arg>, i. e. the length of a minimal generating set of H<M>^k (M)</M> (where <M>2k</M> is the dimension of <Arg>complex</Arg>). See <Ref Meth="SCIntersectionForm"/> for further details.
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");;
## gap> c:=SCLib.Load(last[1][1]);; 
## gap> SCIntersectionFormParity(c);
## 1
## gap> SCCohomology(c);
## [ [ 1, [  ] ], [ 0, [  ] ], [ 1, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> SCIntersectionFormDimensionality(c);
## 1
## gap> d:=SCConnectedProduct(c,10);;
## gap> SCIntersectionFormDimensionality(d);
## 10
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCIntersectionFormSignature">
## <ManSection>
## <Meth Name="SCIntersectionFormSignature" Arg="complex"/>
## <Returns> a triple of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Computes the dimensionality (see <Ref Meth="SCIntersectionFormDimensionality"/>) and the signature of the intersection form of a combinatorial manifold <Arg>complex</Arg> as a <M>3</M>-tuple that contains the dimensionality in the first entry and the number of positive / negative eigenvalues in the second and third entry. See <Ref Meth="SCIntersectionForm"/> for further details.<P/>
## Internally calls the &GAP;-functions <C>Matrix_CharacteristicPolynomialSameField</C> and <C>CoefficientsOfLaurentPolynomial</C> to compute the number of positive / negative eigenvalues of the intersection form. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("CP^2");;
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCIntersectionFormParity(c);
## 1
## gap> SCCohomology(c);
## [ [ 1, [  ] ], [ 0, [  ] ], [ 1, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## gap> SCIntersectionFormSignature(c);
## [ 1, 0, 1 ]
## gap> d:=SCConnectedSum(c,c);                           
## <SimplicialComplex: CP^2 (VT)#+-CP^2 (VT) | dim = 4 | n = 13>
## gap> SCIntersectionFormSignature(d);
## [ 2, 2, 0 ]
## gap> d:=SCConnectedSumMinus(c,c);;
## gap> SCIntersectionFormSignature(d);
## [ 2, 1, 1 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
