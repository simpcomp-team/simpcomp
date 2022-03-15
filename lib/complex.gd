################################################################################
##
##  simpcomp / complex.gd
##
##  &GAP; object type for simplicial complex   
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="SCObjects">
##
## In order to meet the particular requirements of piecewise linear geometric 
## objects and their invariants, <Package>simpcomp</Package> defines a number 
## of new &GAP; object types.<P/>
##
## All new object types are derived from the object type 
## <C>SCPropertyObject</C> which is a subtype of <C>Record</C>. It is a &GAP; 
## object consisting of permanent and temporary attributes. While 
## <Package>simpcomp</Package> makes use of &GAP;'s internal attribute caching 
## mechanism for permanent attributes (see below), this is not the case for 
## temporary ones.<P/>
##
## The temporary properties of a <C>SCPropertyObject</C> can be accessed 
## directly with the functions <C>SCPropertyTmpByName</C> and changed with  
## <C>SCPropertyTmpSet</C>. But this direct access to property objects is 
## discouraged when working with <Package>simpcomp</Package>, as the internal 
## consistency of the objects cannot be guaranteed when the properties of the 
## objects are modified in this way.<P/>
##
## Important note: The temporary properties of <C>SCPropertyObject</C> are not 
## used to hold properties (in the &GAP; sense) of simplicial complexes or 
## other geometric objects. This is done by the GAP4 type system 
## <Cite Key="Breuer98GAP4TypeSystem"/>. Instead, the properties handled by 
## <Package>simpcomp</Package>'s own caching mechanism are used to store 
## changing information, e.g. the complex library (see Section 
## <Ref Chap="chap:libio" />) of the package or any other data which possibly 
## is subject to changes (and thus not suited to be stored by the &GAP; type 
## system).<P/> 
##
## To realize its complex library (see Section <Ref Chap="chap:libio" />), 
## <Package>simpcomp</Package> defines a &GAP; object type 
## <C>SCLibRepository</C> which provides the possibility to store, load, etc. 
## any defined geometric object to and from the build-in complex library as 
## well as customized user libraries. In addition, a searching mechanism is 
## provided.<P/>
##
## Geometric objects are represented by the &GAP; object type 
## <C>SCPolyhedralComplex</C>, which as well is a subtype of 
## <C>SCPropertyObject</C>. <C>SCPolyhedralComplex</C> is designed to 
## represent any kind of piecewise linear geometric object given by a certain 
## cell decomposition. Here, as already mentioned, the GAP4 type system
## <Cite Key="Breuer98GAP4TypeSystem"/> is used to cache properties of the 
## object. In this way, a property is not calculated multiple times in case 
## the object is not altered  (see <Ref Func="SCPropertiesDropped" /> for a 
## way of dropping previously calculated properties).<P/>
##
## As of Version 1.4, <Package>simpcomp</Package> makes use of two different 
## subtypes of <C>SCPolyhedralComplex</C>: <C>SCSimplicialComplex</C> to 
## handle simplicial complexes and <C>SCNormalSurface</C> to deal with 
## discrete normal surfaces (slicings of dimension 2). Whenever possible, 
## only one method per operations is implemented to deal with all subtypes 
## of <C>SCPolyhedralComplex</C>, these functions are described in Chapter 
## <Ref Chap="chap:polyhedralcomplex"/>. For all other operations, the 
## different methods for <C>SCSimplicialComplex</C> and 
## <C>SCNormalSurface</C> are documented separately.
##
## <Section Label="sec:AcessSC"> 
## <Heading>Accessing properties of a <C>SCPolyhedralComplex</C> 
## object</Heading>
##
## As described above the object type <C>SCPolyhedralComplex</C> 
## (and thus also the &GAP; object types <C>SCSimplicialComplex</C> 
## and <C>SCNormalSurface</C>) has properties that are handled by the 
## GAP4 type system. Hence, GAP takes care of the internal consistency 
## of objects of type <C>SCSimplicialComplex</C>.<P/>
##
## There are two ways of accessing properties of a <C>SCPolyhedralComplex</C> 
## object. The first is to call a property handler function of the property 
## one wishes to calculate. The first argument of such a property handler 
## function is always the simplicial complex for which the property should 
## be calculated, in some cases followed by further arguments of the 
## property handler function. An example would be:
##
##<Example><![CDATA[
## gap> c:=SCBdSimplex(3);; # create a SCSimplicialComplex object
## gap> SCFVector(c);
## [ 4, 6, 4 ]
## gap> SCSkel(c,0);
## [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ]
##]]></Example>
##
## Here the functions <C>SCFVector</C> and <C>SCSkel</C> are the property 
## handler functions, see Chapter <Ref Chap="chap:prophandler" /> for a 
## list of all property handlers of a <C>SCPolyhedralComplex</C>, 
## <C>SCSimplicialComplex</C> or <C>SCNormalSurface</C> object. 
##
## Apart from this (standard) method of calling the property handlers 
## directly with a <C>SCPolyhedralComplex</C> object, 
## <Package>simpcomp</Package> provides the user with another more object 
## oriented method which calls property handlers of a 
## <C>SCPolyhedralComplex</C> object indirectly and more conveniently:
##
##<Example><![CDATA[
## gap> c:=SCBdSimplex(3);; # create a SCSimplicialComplex object
## gap> c.F;
## [ 4, 6, 4 ]
## gap> c.Skel(0);
## [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ]
##]]></Example>
##
## Note that the code in this example calculates the same properties as in 
## the first example above, but the properties of a 
## <C>SCPolyhedralComplex</C> object are accessed via the <C>.</C> 
## operator (the record access operator).<P/>
##
## For each property handler of a <C>SCPolyhedralComplex</C> object the 
## object oriented form of this property handler equals the name of the 
## corresponding operation. However, in most cases abbreviations are available: 
## Usually the prefix ``<C>SC</C>'' can be dropped, in other cases even 
## shorter names are available. See Chapter <Ref Chap="chap:prophandler"/> 
## for a complete list of all abbreviations available. 
##
## </Section>
##	
##<#/GAPDoc>

## <#GAPDoc Label="polyhedralcomplex">
##
## In the following all operations for the &GAP; object type 
## <C>SCPolyhedralComplex</C> are listed. I. e. for the following operations 
## only one method is implemented to deal with all geometric objects derived 
## from this object type. 
##
## <Section Label="sec:PCglprops"> 
## <Heading>Computing properties of objects of type 
## <C>SCPolyhedralComplex</C></Heading>
##
##The following functions compute basic properties of objects of type 
## <C>SCPolyhedralComplex</C> (and thus also of objects of type 
## <C>SCSimplicialComplex</C> and <C>SCNormalSurface</C>). None of these 
## functions alter the complex. All properties are returned as immutable 
## objects (this ensures data consistency of the cached properties of a 
## simplicial complex). Use <C>ShallowCopy</C> or the internal 
## <Package>simpcomp</Package> function <C>SCIntFunc.DeepCopy</C> to get a 
## mutable copy.<P/>
## Note: every object is internally stored with the standard vertex labeling 
## from <M>1</M> to <M>n</M> and a maptable to restore the original vertex 
## labeling. Thus, we have to relabel some of the complex properties 
## (facets, etc...) whenever we want to return them to the user. As a 
## consequence, some of the functions exist twice, one of them with the 
## appendix "Ex". These functions return the standard labeling whereas the 
## other ones relabel the result to the original labeling.
##
## <#Include Label="SCFacets"/>
## <#Include Label="SCFacetsEx"/>
## <#Include Label="SCVertices"/>
## <#Include Label="SCVerticesEx"/>
##
## </Section><Section> 
## <Heading>Vertex labelings and label operations</Heading>
##
## This section focuses on functions operating on the labels of a complex 
## such as the name or the vertex labeling.<P/>
## Internally, <Package>simpcomp</Package> uses the standard labeling 
## <M>[1, \ldots , n]</M>. It is recommended to use simple vertex labels 
## like integers and, whenever possible, the standard labeling, see also 
## <Ref Func="SCRelabelStandard" />.
## 
## <#Include Label="SCLabelMax"/>
## <#Include Label="SCLabelMin"/>
## <#Include Label="SCLabels"/>
## <#Include Label="SCName"/>
## <#Include Label="SCReference"/>
## <#Include Label="SCRelabel"/>
## <#Include Label="SCRelabelStandard"/>
## <#Include Label="SCRelabelTransposition"/>
## <#Include Label="SCRename"/>
## <#Include Label="SCSetReference"/>
## <#Include Label="SCUnlabelFace"/>
##
## </Section><Section> 
## <Heading>Operations on objects of type <C>SCPolyhedralComplex</C></Heading>
##
##  The following functions perform operations on objects of type 
## <C>SCPolyhedralComplex</C> and all of its subtypes. Most of them return 
## simplicial complexes. Thus, this section is closely related to the Sections 
## <Ref Chap="sec:generateFromOld"/> (for objects of type 
## <C>SCSimplicialComplex</C>), ''Generate new complexes from old''. However, 
## the data generated here is rather seen as an intrinsic attribute of the 
## original complex and not as an independent complex.
##
## <#Include Label="SCAntiStar"/>
## <#Include Label="SCLink"/>
## <#Include Label="SCLinks"/>
## <#Include Label="SCStar"/>
## <#Include Label="SCStars"/>
##
## </Section>
##<#/GAPDoc>


## <#GAPDoc Label="complex">
##
## Currently, the &GAP; package <Package>simpcomp</Package> supports data 
## structures for two different kinds of geometric objects, namely simplicial 
## complexes (<C>SCSimplicialComplex</C>) and discrete normal surfaces 
## (<C>SCNormalSurface</C>) which are both subtypes of the &GAP; object 
## type <C>SCPolyhedralComplex</C>
## 
## <Section Label="sec:SCSimplComplObj">
## <Heading>The object type <C>SCSimplicialComplex</C></Heading>
##
## A major part of <Package>simpcomp</Package> deals with the object type 
## <C>SCSimplicialComplex</C>. For a complete list of properties that 
## <C>SCSimplicialComplex</C> handles, see Chapter <Ref Chap="chap:scfunc" />. 
## For a few fundamental methods and functions (such as checking the object
## class, copying objects of this type, etc.) for <C>SCSimplicialComplex</C> 
## see below. 
##
## <#Include Label="SCIsSimplicialComplex"/>
## <#Include Label="SCDetails"/>
## <#Include Label="SCCopy"/>
## <#Include Label="SCShallowCopy"/>
## <#Include Label="SCPropertiesDropped"/>
##
## </Section>
## <Section>
## <Heading>Overloaded operators of <C>SCSimplicialComplex</C></Heading>
##
## <Package>simpcomp</Package> overloads some standard operations for the 
## object type <C>SCSimplicialComplex</C> if this definition is intuitive and 
## mathematically sound. See a list of overloaded operators below. 
#
##	
## <#Include Label="SCOpPlusSCInt"/>
## <#Include Label="SCOpMinusSCInt"/>
## <#Include Label="SCOpModSCInt"/>
## <#Include Label="SCOpPowSCInt"/>
## <#Include Label="SCOpPlusSCSC"/>
## <#Include Label="SCOpMinusSCSC"/>
## <#Include Label="SCOpMultSCSC"/>
## <#Include Label="SCOpEqSCSC"/>
##	
## </Section> 
##
## <Section Label="sec:SubtypeOfSet"> 
## <Heading><C>SCSimplicialComplex</C> as a subtype of <C>Set</C></Heading>
##	
## Apart from being a subtype of <C>SCPropertyObject</C>, an object of type 
## <C>SCSimplicialComplex</C> also behaves like a &GAP; <C>Set</C> type. The 
## elements of the set are given by the facets of the simplical complex, 
## grouped by their dimensionality, i.e. if <C>complex</C> is an object of 
## type <C>SCSimplicialComplex</C>, <C>c[1]</C> refers to the 0-faces of 
## <C>complex</C>, <C>c[2]</C> to the 1-faces, etc.
##
## <#Include Label="SCOpUnionSCSC"/>
## <#Include Label="SCOpDiffSCSC"/>
## <#Include Label="SCOpIsecSCSC"/>
## <#Include Label="SCSize"/>
## <#Include Label="SCLength"/>
## <#Include Label="SCAccess"/>
## <#Include Label="SCIterator"/>
##	
## </Section> 
##		
##<#/GAPDoc>

DeclareCategory("SCIsPolyhedralComplex",SCIsPropertyObject and IsSet);
DeclareCategory("SCIsSimplicialComplex",SCIsPolyhedralComplex);

DeclareOperation("SCFromFacets",[IsList]);
DeclareOperation("SC",[IsList]);

DeclareGlobalFunction("SCDetails");


DeclareOperation("SCCopy",[SCIsPropertyObject]);
DeclareGlobalFunction("SCPropertiesDropped");


#face lattice operations
DeclareOperation("SCDifference",[SCIsPolyhedralComplex,SCIsPolyhedralComplex]);
DeclareOperation("SCIntersection",[SCIsPolyhedralComplex,
  SCIsPolyhedralComplex]);
DeclareOperation("SCUnion",[SCIsPolyhedralComplex,SCIsPolyhedralComplex]);

#label operations
DeclareOperation("+",[SCIsPolyhedralComplex,IsInt]);
DeclareOperation("-",[SCIsPolyhedralComplex,IsInt]);
DeclareOperation("*",[SCIsPolyhedralComplex,IsInt]);

#operations on complexes

#cartesian power
DeclareOperation("^",[SCIsSimplicialComplex,IsPosInt]); 
#connected sums
DeclareOperation("+",[SCIsSimplicialComplex,SCIsSimplicialComplex]); 
DeclareOperation("-",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
#cart. product
DeclareOperation("*",[SCIsSimplicialComplex,SCIsSimplicialComplex]);

################################################################################













