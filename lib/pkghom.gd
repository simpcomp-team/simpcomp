################################################################################
##
##  simpcomp / pkghom.gd
##
##  Overlay some functions of package `homology' 
##
##  $Id$
##
################################################################################

if(not IsBoundGlobal("SCIntFuncHomologyOverlay")) then
	BindGlobal("SCIntFuncHomologyOverlay",true);
	
	if(IsBoundGlobal("SCLink")) then
		SCIntFunc.SCLinkOld:=SCLink;
		MakeReadWriteGlobal("SCLink");
		UnbindGlobal("SCLink");
	fi;
	DeclareOperation("SCLink",[IsObject,IsObject]);
	
	if(IsBoundGlobal("SCStar")) then
		SCIntFunc.SCStarOld:=SCStar;
		MakeReadWriteGlobal("SCStar");
		UnbindGlobal("SCStar");
	fi;
	DeclareOperation("SCStar",[IsObject,IsObject]);
	
	if(IsBoundGlobal("SCWedge")) then
		SCIntFunc.SCWedgeOld:=SCWedge;
		MakeReadWriteGlobal("SCWedge");
		UnbindGlobal("SCWedge");
	fi;
	DeclareOperation("SCWedge",[IsObject,IsObject]);
	
	if(IsBoundGlobal("SCJoin")) then
		SCIntFunc.SCJoinOld:=SCJoin;
		MakeReadWriteGlobal("SCJoin");
		UnbindGlobal("SCJoin");
	fi;
	DeclareOperation("SCJoin",[IsObject,IsObject]);
	
	if(IsBoundGlobal("SCCone")) then
		SCIntFunc.SCConeOld:=SCCone;
		MakeReadWriteGlobal("SCCone");
		UnbindGlobal("SCCone");
	fi;
	DeclareGlobalFunction("SCCone");
	
	if(IsBoundGlobal("SCSuspension")) then
		SCIntFunc.SCSuspensionOld:=SCSuspension;
		MakeReadWriteGlobal("SCSuspension");
		UnbindGlobal("SCSuspension");
	fi;
	DeclareOperation("SCSuspension",[IsObject]);
	
	if(IsBoundGlobal("SCAlexanderDual")) then
		SCIntFunc.SCAlexanderDualOld:=SCAlexanderDual;
		MakeReadWriteGlobal("SCAlexanderDual");
		UnbindGlobal("SCAlexanderDual");
	fi;
	DeclareOperation("SCAlexanderDual",[IsObject]);
	
	if(IsBoundGlobal("SCDeletedJoin")) then
		SCIntFunc.SCDeletedJoinOld:=SCDeletedJoin;
		MakeReadWriteGlobal("SCDeletedJoin");
		UnbindGlobal("SCDeletedJoin");
	fi;
	DeclareOperation("SCDeletedJoin",[IsObject,IsObject]);
	
	if(IsBoundGlobal("SCMinimalNonFaces")) then
		SCIntFunc.SCMinimalNonFacesOld:=SCMinimalNonFaces;
		MakeReadWriteGlobal("SCMinimalNonFaces");
		UnbindGlobal("SCMinimalNonFaces");
	fi;
	DeclareOperation("SCMinimalNonFaces",[IsObject]); #see glprops.gi
fi;
