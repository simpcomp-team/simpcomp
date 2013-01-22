################################################################################
##
##  simpcomp / pkghomalg.gi
##
##  Loaded when package `homalg' is available
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgBoundaryMatrices">
## <ManSection>
## <Meth Name="SCHomalgBoundaryMatrices" Arg="complex,modulus"/>
## <Returns>a list of <Package>homalg</Package> objects upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the boundary operator matrices for the simplicial complex <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> yields <M>\mathbb{Q}</M>-matrices, a value of <C>1</C> yields <M>\mathbb{Z}</M>-matrices and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-matrices.<P/>
## <Example>
## gap&gt; SCLib.SearchByName("CP^2 (VT)");
## [ [ 16, "CP^2 (VT)" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgBoundaryMatrices(c,0);
## Error, Variable: 'SCHomalgBoundaryMatrices' must have a value
## not in any function at line 7 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgCoboundaryMatrices">
## <ManSection>
## <Meth Name="SCHomalgCoboundaryMatrices" Arg="complex,modulus"/>
## <Returns>a list of <Package>homalg</Package> objects upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the coboundary operator matrices for the simplicial complex <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> yields <M>\mathbb{Q}</M>-matrices, a value of <C>1</C> yields <M>\mathbb{Z}</M>-matrices and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-matrices.<P/>
## <Example>
## gap&gt; SCLib.SearchByName("CP^2 (VT)");
## [ [ 16, "CP^2 (VT)" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgCoboundaryMatrices(c,0);
## Error, Variable: 'SCHomalgCoboundaryMatrices' must have a value
## not in any function at line 13 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgHomology">
## <ManSection>
## <Meth Name="SCHomalgHomology" Arg="complex,modulus"/>
## <Returns>a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the ranks of the homology groups of <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the <M>\mathbb{Q}</M>-homology, a value of <C>1</C> computes the <M>\mathbb{Z}</M>-homology and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-homology ranks.<P/>
## Note that if you are interested not only in the ranks of the homology groups, but rather their full structure, have a look at the function <Ref Meth="SCHomalgHomologyBasis" />.
## <Example>
## gap&gt; SCLib.SearchByName("K3");
## [ [ 7648, "K3_16" ], [ 7649, "K3_17" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgHomology(c,0);
## Error, Variable: 'SCHomalgHomology' must have a value
## not in any function at line 19 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgHomologyBasis">
## <ManSection>
## <Meth Name="SCHomalgHomologyBasis" Arg="complex,modulus"/>
## <Returns>a <Package>homalg</Package> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the homology groups (including explicit bases of the modules involved) of <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the <M>\mathbb{Q}</M>-homology, a value of <C>1</C> computes the <M>\mathbb{Z}</M>-homology and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-homology groups.<P/>
## The <M>k</M>-th homology group <C>hk</C> can be obtained by calling <C>hk:=CertainObject(homology,k);</C>, where <C>homology</C> is the <Package>homalg</Package> object returned by this function. The generators of <C>hk</C> can then be obtained via <C>GeneratorsOfModule(hk);</C>.<P/>
## Note that if you are only interested in the ranks of the homology groups, then it is better to use the funtion <Ref Meth="SCHomalgHomology" /> which is way faster.
## <Example>
## gap&gt; SCLib.SearchByName("K3");
## [ [ 7648, "K3_16" ], [ 7649, "K3_17" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgHomologyBasis(c,0);
## Error, Variable: 'SCHomalgHomologyBasis' must have a value
## not in any function at line 25 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgCohomology">
## <ManSection>
## <Meth Name="SCHomalgCohomology" Arg="complex,modulus"/>
## <Returns>a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the ranks of the cohomology groups of <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the <M>\mathbb{Q}</M>-cohomology, a value of <C>1</C> computes the <M>\mathbb{Z}</M>-cohomology and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-cohomology ranks.<P/>
## Note that if you are interested not only in the ranks of the cohomology groups, but rather their full structure, have a look at the function <Ref Meth="SCHomalgCohomologyBasis" />.
## <Example>
## gap&gt; SCLib.SearchByName("K3");
## [ [ 7648, "K3_16" ], [ 7649, "K3_17" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgCohomology(c,0);
## Error, Variable: 'SCHomalgCohomology' must have a value
## not in any function at line 31 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCHomalgCohomologyBasis">
## <ManSection>
## <Meth Name="SCHomalgCohomologyBasis" Arg="complex,modulus"/>
## <Returns>a <Package>homalg</Package> object upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function computes the cohomology groups (including explicit bases of the modules involved) of <Arg>complex</Arg> with a ring of coefficients as specified by <Arg>modulus</Arg>: a value of <C>0</C> computes the <M>\mathbb{Q}</M>-cohomology, a value of <C>1</C> computes the <M>\mathbb{Z}</M>-cohomology and a value of <C>q</C>, q a prime or a prime power, computes the <M>\mathbb{F}_q</M>-homology groups.<P/>
## The <M>k</M>-th cohomology group <C>ck</C> can be obtained by calling <C>ck:=CertainObject(cohomology,k);</C>, where <C>cohomology</C> is the <Package>homalg</Package> object returned by this function. The generators of <C>ck</C> can then be obtained via <C>GeneratorsOfModule(ck);</C>.<P/>
## Note that if you are only interested in the ranks of the cohomology groups, then it is better to use the funtion <Ref Meth="SCHomalgCohomology" /> which is way faster.
## <Example>
## gap&gt; SCLib.SearchByName("K3");
## [ [ 7648, "K3_16" ], [ 7649, "K3_17" ] ]
## gap&gt; c:=SCLib.Load(last[1][1]);;
## gap&gt; SCHomalgCohomologyBasis(c,0);
## Error, Variable: 'SCHomalgCohomologyBasis' must have a value
## not in any function at line 37 of *stdin*
## </Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
