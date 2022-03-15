################################################################################
##
##  simpcomp / io.gi
##
##  simpcomp IO functions 
##
##  $Id$
##
################################################################################
################################################################################
##<#GAPDoc Label="SCLoad">
## <ManSection>
## <Func Name="SCLoad" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex stored in a binary format (using 
## <C>IO_Pickle</C>) from a file specified in <Arg>filename</Arg> (as string). 
## If <Arg>filename</Arg> does not end in <C>.scb</C>, this suffix is 
## appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSave(c,"/tmp/bddelta3");
## true
## gap> d:=SCLoad("/tmp/bddelta3");
## <SimplicialComplex: S^2_4 | dim = 2 | n = 4>
## gap> c=d;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCLoadXML">
## <ManSection>
## <Func Name="SCLoadXML" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex stored in XML format from a file specified in 
## <Arg>filename</Arg> (as string). If <Arg>filename</Arg> does not end in 
## <C>.sc</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSaveXML(c,"/tmp/bddelta3");
## true
## gap> d:=SCLoadXML("/tmp/bddelta3");
## <SimplicialComplex: S^2_4 | dim = 2 | n = 4>
## gap> c=d;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSave">
## <ManSection>
## <Func Name="SCSave" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Saves a simplicial complex in a binary format (using <C>IO_Pickle</C>) to 
## a file specified in <Arg>filename</Arg> (as string). If <Arg>filename</Arg> 
## does not end in <C>.scb</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSave(c,"/tmp/bddelta3");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCSaveXML">
## <ManSection>
## <Func Name="SCSaveXML" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Saves a simplicial complex <Arg>complex</Arg> to a file specified by 
## <Arg>filename</Arg> (as string) in XML format. If <Arg>filename</Arg> does 
## not end in <C>.sc</C>, this suffix is appended to the file name.
## <Example><![CDATA[
## gap> c:=SCBdSimplex(3);;
## gap> SCSaveXML(c,"/tmp/bddelta3");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportMacaulay2">
## <ManSection>
## <Func Name="SCExportMacaulay2" Arg="complex, ring,  filename [, alphalabels]"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list of a given simplicial complex <Arg>complex</Arg> in 
## <C>Macaulay2</C> format to a file specified by <Arg>filename</Arg>. The 
## argument <Arg>ring</Arg> can either be the ring of integers (specified by 
## <C>Integers</C>) or the ring of rationals (sepcified by <C>Rationals</C>). 
## The optional boolean argument <Arg>alphalabels</Arg> labels the complex 
## with characters from <M>a, \dots ,z</M> in the exported file if a value of 
## <K>true</K> is supplied, while the standard labeling of the vertices is 
## <M>v_1, \dots ,v_n</M> where <M>n</M> is the number of vertices of 
## <Arg>complex</Arg>. If <Arg>complex</Arg> has more than <M>26</M> 
## vertices, the argument <Arg>alphalabels</Arg> is ignored. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportMacaulay2(c,Integers,"/tmp/bdbeta4.m2");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportPolymake">
## <ManSection>
## <Func Name="SCExportPolymake" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list with vertex labels of a given simplicial complex 
## <Arg>complex</Arg> in <C>polymake</C> format to a file specified by 
## <Arg>filename</Arg>. Currently, only the export in the format of 
## <C>polymake</C> version 2.3 is supported. 
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportPolymake(c,"/tmp/bdbeta4.poly");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportRecognizer">
## <ManSection>
## <Func Name="SCExportRecognizer" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the gluings of the tetrahedra of a given combinatorial 
## <M>3</M>-manifold <Arg>complex</Arg> in a format compatible with Matveev's 
## <M>3</M>-manifold software <C>Recognizer</C>.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportRecognizer(c,"/tmp/bdbeta4.mv");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportJavaView">
## <ManSection>
## <Func Name="SCExportJavaView" Arg="complex, file, coords"/>
## <Returns><K>true</K> on success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the 2-skeleton of the given simplicial complex <Arg>complex</Arg> 
## (or the facets if the complex is of dimension 2 or less) in <C>JavaView</C> 
## format (file name suffix <C>.jvx</C>) to a file specified by 
## <Arg>filename</Arg> (as string). The list <Arg>coords</Arg> must contain a 
## <M>3</M>-tuple of real coordinates for each vertex of <Arg>complex</Arg>, 
## either as tuple of length three containing the coordinates (Warning: 
## as &GAP; only has rudimentary support for floating point values, currently 
## only integer numbers can be used as coordinates when providing 
## <Arg>coords</Arg> as list of <M>3</M>-tuples) or as string of the form 
## <C>"x.x y.y z.z"</C> with decimal numbers <C>x.x</C>, <C>y.y</C>, 
## <C>z.z</C> for the three coordinates (i.e. <C>"1.0 0.0 0.0"</C>).
## <Example><![CDATA[
## gap> coords:=[[1,0,0],[0,1,0],[0,0,1]];;
## gap> SCExportJavaView(SCBdSimplex(2),"/tmp/triangle.jvx",coords);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCExportLatexTable">
## <ManSection>
## <Func Name="SCExportLatexTable" Arg="complex, filename, itemsperline"/>
## <Returns><K>true</K> on success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list of a given simplicial complex <Arg>complex</Arg> 
## (or any list given as first argument) in form of a &LaTeX; table to a file 
## specified by <Arg>filename</Arg>. The argument <Arg>itemsperline</Arg> 
## specifies how many columns the exported table should have. The faces are 
## exported in the format <M>\langle v_1,\dots,v_k \rangle</M>.  
## <Example><![CDATA[
## gap> c:=SCBdSimplex(5);;
## gap> SCExportLatexTable(c,"/tmp/bd5simplex.tex",5);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
##<#GAPDoc Label="SCImportPolymake">
## <ManSection>
## <Func Name="SCImportPolymake" Arg="filename"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Imports the facet list of a <C>topaz</C> <C>polymake</C> file specified by 
## <Arg>filename</Arg> (discarding any vertex labels) and creates a 
## simplicial complex object from these facets.
## <Example><![CDATA[
## gap> c:=SCBdCrossPolytope(4);;
## gap> SCExportPolymake(c,"/tmp/bdbeta4.poly");
## true
## gap> d:=SCImportPolymake("/tmp/bdbeta4.poly");
## <SimplicialComplex: polymake import '/tmp/bdbeta4.poly' | dim = 3 | n = 8>
## gap> c=d;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
################################################################################
################################################################################
##<#GAPDoc Label="SCExportSnapPy">
## <ManSection>
## <Func Name="SCExportSnapPy" Arg="complex, filename"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Exports the facet list and orientability of a given combinatorial 
## <M>3</M>-pseudomanifold <Arg>complex</Arg> in <C>SnapPy</C> format to a 
## file specified by <Arg>filename</Arg>.
## <Example><![CDATA[
## gap> SCLib.SearchByAttribute("Dim=3 and F=[8,28,56,28]");
## [ [ 8, "PM^3 - TransitiveGroup(8,43), No. 1" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> SCExportSnapPy(c,"/tmp/M38.tri");
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
