################################################################################
##
##  simpcomp / labelops.gd
##
##  Functions operating on the labels of a complex such a the name or the
##  vertex labeling.
##
##  $Id$
##
################################################################################


DeclareAttribute("SCName",SCIsPolyhedralComplex);
DeclareAttribute("SCReference",SCIsPolyhedralComplex);
DeclareAttribute("SCDate",SCIsPolyhedralComplex);

DeclareSynonymAttr("SCLabels",SCVertices);
DeclareOperation("SCLabelMax",[SCIsPolyhedralComplex]);
DeclareOperation("SCLabelMin",[SCIsPolyhedralComplex]);
DeclareOperation("SCRelabel",[SCIsPolyhedralComplex,IsList]);
DeclareOperation("SCRelabelStandard",[SCIsPolyhedralComplex]);
DeclareOperation("SCRelabelTransposition",[SCIsPolyhedralComplex,IsList]);
DeclareOperation("SCUnlabelFace",[SCIsPolyhedralComplex,IsList]);
DeclareOperation("SCRename",[SCIsPolyhedralComplex,IsString]);
DeclareOperation("SCSetReference",[SCIsPolyhedralComplex,IsString]);
DeclareOperation("SCSetDate",[SCIsPolyhedralComplex,IsString]);


