################################################################################
##
##  simpcomp / lib.gi
##
##  simplicial complexes library
##
##  $Id$
##
################################################################################


################################################################################
##<#GAPDoc Label="SCIsLibRepository">
## <ManSection>
## <Filt Name="SCIsLibRepository" Arg="object"/>
## <Returns><K>true</K> or <K>false</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Filter for the category of a library repository <C>SCIsLibRepository</C> used by the <Package>simpcomp</Package> library. The category <C>SCLibRepository</C> is derived from the category <C>SCPropertyObject</C>.
## <Example><![CDATA[
## gap> SCIsLibRepository(SCLib); #the global library is stored in SCLib
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################



#library repository object family/type
SCLibRepositoryFamily:=NewFamily("SCLibRepositoryFamily",SCIsLibRepository);
SCLibRepositoryType:=NewType(SCLibRepositoryFamily,SCIsLibRepository and IsAttributeStoringRep and IsListOrCollection);


#standard index attributes for global library
SCIntFunc.LibGlobalStandardAttributes:=
["Name","Dim","ASDet","F","G","H","Chi","Homology","IsConnected","Neighborliness","IsStronglyConnected","IsPure","IsPM","AutomorphismGroup","AutomorphismGroupSize","AutomorphismGroupTransitivity","IsCentrallySymmetric","HasBoundary","HasInterior"];

#standard index attributes for user library
SCIntFunc.LibStandardAttributes:=
["Name","Dim","F","G","H","Chi","Homology","IsPM","IsManifold"];



# create new empty library repository
SCIntFunc.LibRepositoryEmpty:=
function()
	local lib;
	lib:=Objectify(SCLibRepositoryType,rec(
		Properties:=rec(
			Loaded:=false,
			IndexAttributes:=ShallowCopy(SCIntFunc.LibStandardAttributes),
			CalculateIndexAttributes:=true
		),
		PropertiesTmp:=rec(),
		PropertyHandlers:=SCIntFunc.SCLibRepositoryPropertyHandlers));

	if(lib=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.LibRepositoryEmpty: Error creating new instance of ",
		"SCLibRepository!");
	fi;

	return lib;
end;



# create new library repository with given attributes
SCIntFunc.LibRepositoryEmptyWithAttributes:=
function(attrs)
	local lattrs;
	lattrs:=attrs;
	lattrs.Loaded:=false;
	lattrs.CalculateIndexAttributes:=true;

	if(not IsBound(attrs.IndexAttributes)) then
		lattrs.IndexAttributes:=ShallowCopy(SCIntFunc.LibStandardAttributes);
	fi;

	return Objectify(SCLibRepositoryType,
		rec(
			Properties:=lattrs,
			PropertiesTmp:=rec(),
			PropertyHandlers:=SCIntFunc.SCLibRepositoryPropertyHandlers
		));
end;


# view method for SCLibRepository
InstallMethod(ViewObj,"for SCLibRepository",
	[SCIsLibRepository],
function(rep)
	local key,val;

	Print("[Simplicial complex library. Properties:\n");
	for key in Intersection(SCPropertiesNames(rep),["Name", "Path", "Loaded", "IndexAttributes", "CalculateIndexAttributes", "Index"]) do

		val:=SCPropertyByName(rep,key);
		
		if(key="Index") then
			Print("Number of complexes in library=",Length(val),"\n");
			continue;
		fi;

		if(IsStringRep(val)) then
			Print(key,"=\"",val,"\"\n");
		else
			Print(key,"=",val,"\n");
		fi;
	od;
	Print("]");
end);



# print method for SCLibRepository
InstallMethod(PrintObj,"for SCLibRepository",
	[SCIsLibRepository],
function(rep)
	local key,val;

	Print("[Simplicial complex library. Properties:\n");
	for key in RecNames(rep!.props) do
		val:=rep!.props.(key);
		if(IsStringRep(val)) then
			Print(key,"=\"",val,"\"\n");
		else
			Print(key,"=",val,"\n");
		fi;
	od;
	Print("]\n");
end);


################################################################################
##<#GAPDoc Label="SCLibIsLoaded">
## <ManSection>
## <Func Name="SCLibIsLoaded" Arg="repository"/>
## <Returns><K>true</K> or <K>false</K> upon succes, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns <K>true</K> when a given library repository <Arg>repository</Arg> is in loaded state. This means that the directory of this repository is accessible and a repository index file for this repository exists in the repositories' path. If this is not the case <K>false</K> is returned.
## <Example><![CDATA[
## gap> SCLibIsLoaded(SCLib);
## true
## gap> SCLib.IsLoaded;
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibIsLoaded,
function(repository)
	if(not SCIsLibRepository(repository)) then
		Info(InfoSimpcomp,1,"SCLibIsLoaded: first argument must be of type SCLibRepository.");
		return fail;
	fi;
	return SCPropertyByName(repository,"Loaded")=true;
end);

################################################################################
##<#GAPDoc Label="SCLibSize">
## <ManSection>
## <Func Name="SCLibSize" Arg="repository"/>
## <Returns> integer upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns the number of complexes contained in the given repository <Arg>repository</Arg>. Fails if the library repository was not previously loaded with <C>SCLibInit</C>.
## <Example><![CDATA[
## gap> SCLibSize(SCLib); #SCLib is the repository of the global library
## 7648
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibSize,
function(repository)
	local index;

	if(not SCIsLibRepository(repository) or not SCLibIsLoaded(repository)) then
		Info(InfoSimpcomp,1,"SCLibSize: first argument must be of type SCLibRepository and must be loaded.");
		return fail;
	fi;

	index:=SCPropertyByName(repository,"Index");
	if(index=fail) then
		Info(InfoSimpcomp,1,"SCLibSize: error getting index of library.");
		return fail;
	fi;

	return Length(index);
end);



################################################################################
##<#GAPDoc Label="SCLibLoad">
## <ManSection>
## <Func Name="SCLibLoad" Arg="repository, id"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C>, <K>fail</K> otherwise.</Returns>
## <Description>
## Loads a simplicial complex from the given library repository <Arg>repository</Arg> by its id <C>id</C>. The id is repository specific and ranges from 1 to N where N are the number of complexes currently in the repository (this number can be determined by <C>SCLibSize</C>). If the id is not valid (non-positive or bigger than maximal id), an error is signalled. Ids in the global library repository of <Package>simpcomp</Package>, <C>SCLib</C>, are sorted by in ascending order by the f-vector of the complexes. 
## <Example><![CDATA[
## gap> SCLib.SearchByName("S^2~S^1"){[1..3]};
## gap> id:=last[1][1];;
## gap> SCLibLoad(SCLib,id);
## gap> SCLib.Load(id);; #the same operation in alternative syntax
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibLoad,
function(repository,id)
	local index;

	if(not SCIsLibRepository(repository) or not IsPosInt(id) or not SCLibIsLoaded(repository)) then
		Info(InfoSimpcomp,1,"SCLibLoad: first argument must be of type SCLibRepository and loaded, second argument must be a positive integer.");
		return fail;
	fi;

	index:=SCPropertyByName(repository,"Index");
	if(index=fail or not IsBound(index[id])) then
		Info(InfoSimpcomp,1,"SCLibLoad: error getting index of library or index not bound at given position.");
		return fail;
	fi;

	return SCLoad(Filename(Directory(SCPropertyByName(repository,"Path")),index[id].File));
end);


#init library repository for given directory
SCIntFunc.SCLibInit:=
function(dir)
	local a,b,c,id,ldir,data,r,repository,fh;

	if(IsDirectory(dir)) then
		ldir:=dir;
		dir:=Filename(ldir,"");
	elif(IsString(dir)) then
		ldir:=Directory(dir);
	else
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibInit: first argument must be a valid path name.");
		return fail;
	fi;

	#check for directory existence
	if(not IsReadableFile(dir)) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibInit: repository path ",dir," does not exist or is not readable!");
		return fail;
	fi;
	
	
	if(IsReadableFile(Filename(ldir,"complexes.idxb"))) then
		#first try to read binary format
		fh:=IO_File(Filename(ldir,"complexes.idxb"),"r");
		repository:=IO_Unpickle(fh);
		IO_Close(fh);
		
		if(IO_Result(repository) and repository<>IO_OK) then
			Info(InfoSimpcomp,1,"SCIntFunc.SCLibInit: error loading binary index  -- trying to reconstruct it.");
			return SCLibUpdate(ldir);
		fi;
	else
		#if not found, fall back to xml format
		data:=StringFile(Filename(ldir,"complexes.idx"));
		if(data=fail or IsEmptyString(data)) then
			#index not found or not readable -- try to (re)construct
			Info(InfoSimpcomp,1,"SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.");
			return SCLibUpdate(ldir);
		fi;
		repository:=SCIntFunc.SCXMLToObject(data);
		
		if(repository=fail or Length(repository)<1 or not SCIsLibRepository(repository[1])) then
			Info(InfoSimpcomp,1,"SCIntFunc.SCLibInit: loading index failed.");
			return fail;
		fi;
		
		repository:=repository[1];
	fi;

	if(SCPropertyByName(repository,"IndexAttributes")=fail) then
		SCPropertySet(repository,"IndexAttributes",ShallowCopy(SCIntFunc.LibStandardAttributes));
	fi;

	if(SCPropertyByName(repository,"Index")=fail) then
		SCPropertySet(repository,"Index",SCIntFunc.SCPositionalObjectFromList([]));
	fi;
	SCPropertySet(repository,"Loaded",true);
	SCLibIsLoaded(repository);;
	SCPropertySet(repository,"Path",dir);

	return repository;
end;


#save a given repositories index
SCIntFunc.SCLibSave:=
function(rep)
	local file,fh;
	if(not SCIsLibRepository(rep) or not SCLibIsLoaded(rep)) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibSave: first argument must be of type SCLibRepository and must be loaded.");
		return fail;
	fi;

	file:=Filename(Directory(SCPropertyByName(rep,"Path")),"complexes.idxb");
	fh:=IO_File(file,"w");
	
	if(IO_Result(fh) and fh=IO_Error) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibSave: \"",file,"\" not writeable!");
		return fail;
	else
		if(IO_Pickle(fh,rep)<>IO_OK) then
			Info(InfoSimpcomp,1,"SCIntFunc.SCLibSave: Error saving repository to file \"",file,"\".");
			IO_Close(fh);
			return fail;
		else
			Info(InfoSimpcomp,2,"SCIntFunc.SCLibSave: Saved repository to file \"",file,"\".");
			IO_Close(fh);
			return true;
		fi;
	fi;
end;


#generate index entry for a library repository
SCIntFunc.LibGenIndexEntry:=
function(rep,relpath,file,calc,force,s)
	local entry,key,sc,p,f,changed,tmp,dim,n;

	Info(InfoSimpcomp,2,"SCIntFunc.LibGenIndexEntry: processing complex \"",file,"\"...");
	
	if(s=fail) then
		sc:=SCLoad(file);
	else
		sc:=s;
	fi;
	
	if(sc=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: error loading complex from file \"",file,"\"!");
		return fail;
	fi;

	#legacy code from xml format v1
	if(not "SCVertices" in KnownAttributesOfObject(sc)) then
		SCRelabelStandard(sc);
	fi;
	
	entry:=rec(File:=file{[Length(relpath)+1..Length(file)]});
	ConvertToStringRep(entry.File);

	if(force) then
		tmp:=SCFromFacets(SCFacetsEx(sc));
		if(SCName(sc)<>fail) then
			SCRename(tmp,SCName(sc));
		fi;
		
		if(SCReference(sc)<>fail) then
			SCSetReference(tmp,SCReference(sc));
		fi;
		
		if(SCDate(sc)<>fail) then
			SCSetDate(tmp,SCDate(sc));
		fi;
		sc:=tmp;
	fi;
	
	changed:=false;
	f:=[];

        dim := SCDim(sc);
        if dim = fail then
	  Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: computing dimension failed!");
	  return fail;
	fi;


        n := SCNumFaces(sc,0);
        if n = fail then
	  Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: computing number of vertices failed!");
	  return fail;
	fi;

        # only compute properties of small complexes
        if dim <= 4 and n < 20 then
	  for key in SCPropertyByName(rep,"IndexAttributes") do
		Info(InfoSimpcomp,3,"SCIntFunc.LibGenIndexEntry: calculating property \"",key,"\" for current complex...");
		p:=SCIntFunc.SCPropertyHandlers.(key)(sc);
		if(p=fail) then
			Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: failed to compute property ",key," for simplicial complex \"",file,"\".");
		fi;
		if(not p=fail) then
			entry.(key):=p;
			changed:=true;	
			if(key="F") then
				f:=p;
			fi;
		fi;
	  od;
        else
          for key in ["Dim", "F", "G", "H", "Chi", "Homology", "Name", "IsPM", "IsManifold"] do
		Info(InfoSimpcomp,3,"SCIntFunc.LibGenIndexEntry: calculating property \"",key,"\" for current complex...");
		p:=SCIntFunc.SCPropertyHandlers.(key)(sc);
		if(p=fail) then
			Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: failed to compute property ",key," for simplicial complex \"",file,"\".");
		fi;
		if(not p=fail) then
			entry.(key):=p;
			changed:=true;
			if(key="F") then
				f:=p;
			fi;
		fi;
	  od;
        fi;

        changed:=true;

	if(changed) then
		Info(InfoSimpcomp,2,"SCIntFunc.LibGenIndexEntry: complex changed, saving.");
		if(SCSave(sc,file)=fail) then
			Info(InfoSimpcomp,1,"SCIntFunc.LibGenIndexEntry: error saving simplicial complex to \"",file,"\".");
		fi;
	else
		Info(InfoSimpcomp,2,"SCIntFunc.LibGenIndexEntry: complex unchanged.");
	fi;

	Info(InfoSimpcomp,2,"SCIntFunc.LibGenIndexEntry: done processing complex \"",file,"\".");

	return [entry,f];
end;


################################################################################
##<#GAPDoc Label="SCLibUpdate">
## <ManSection>
## <Func Name="SCLibUpdate" Arg="repository [, recalc]"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Recreates the index of a given repository (either via a repository object or a base path of a repository <Arg>repository</Arg>) by scanning the base path for all <C>.sc</C> files containing simplicial complexes of the repository. Returns a repository object with the newly created index on success or <K>fail</K> in case of an error. The optional boolean argument <Arg>recalc</Arg> forces <Package>simpcomp</Package> to recompute all the indexed properties (such as f-vector, homology, etc.) of the simplicial complexes in the repository if set to <K>true</K>. 
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");;
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## gap> SCLibUpdate(myRepository);
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=0
## IndexAttributes=["Name", "Date", "Dim", "F", "G", "H", "Chi", "Homology"]
## Loaded=true
## Path="/tmp/repository/"
##]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
#############0###################################################################
InstallGlobalFunction(SCLibUpdate,
function(arg)
	local i,complexes,recurseDirs,processComplex,lpath,dir,calc,force,relpath,rep,fvecs;

	processComplex:=function(file)
		local entry,xmlentry;

		entry:=SCIntFunc.LibGenIndexEntry(rep,relpath,file,calc,force,fail);

		if(entry=fail) then
			return fail;
		fi;

		Add(complexes,entry[1]);
		Add(fvecs,entry[2]);
		return true;
	end;

	recurseDirs:=function(path)
		local contents,item,dir,itempath,lpath;
		if(not IsDirectoryPath(path)) then
			Info(InfoSimpcomp,1,"SCLibUpdate: \"",path,"\" is not a directory!");
			return fail;
		fi;

		contents:=fail;
		lpath:=ShallowCopy(path); #has to be mutable
		contents:=DirectoryContents(lpath);

		if(contents=fail) then
			Info(InfoSimpcomp,1,"SCLibUpdate: could not read directory contents of \"",lpath,"\"!");
			return fail;
		fi;

		dir:=Directory(lpath);

		for item in contents do
			if(item[1]='.' or Length(item)<4) then
				#skip hidden files/directories
				continue;
			fi;
			itempath:=Filename(dir,item);

			if(IsDirectoryPath(itempath)) then
				Info(InfoSimpcomp,2,"SCLibUpdate.recurseDirs: recursing into directory \"",itempath,"\"...");
				recurseDirs(itempath);
			elif(IsReadableFile(itempath)) then
				#load simplicial complexes
				if(Length(item)>4 and item{[Length(item)-3..Length(item)]}=".scb") then
					Info(InfoSimpcomp,2,"SCLibUpdate: processing complex ",itempath);
					if(processComplex(itempath)=fail) then
						Info(InfoSimpcomp,1,"SCLibUpdate: error processing complex ",itempath);
					fi;
				fi;
			else
				Info(InfoSimpcomp,1,"SCLibUpdate: file \"",item,"\" not readable!");
			fi;
		od;
		return true;
	end;

	if (Length(arg)<1 or 
	(Length(arg)>=1 
		and (not SCIsLibRepository(arg[1]) and not (IsDirectory(arg[1]) or (IsString(arg[1]) and IsReadableFile(Filename(Directory(arg[1]),""))))
		or (SCIsLibRepository(arg[1]) and (SCPropertyByName(arg[1],"Path")=fail or not IsReadableFile(SCPropertyByName(arg[1],"Path")))))) 
	or (Length(arg)>1 and not IsBool(arg[2]))) 
	then
		Info(InfoSimpcomp,1,"SCLibUpdate: illegal parameters.");
		return fail;
	fi;

	force:=false;
	if(Length(arg)>1) then
		force:=arg[2];
	fi;

	if(SCIsLibRepository(arg[1])) then
		rep:=arg[1];
		dir:=SCPropertyByName(rep,"Path");
	else
		rep:=SCIntFunc.LibRepositoryEmpty();
		dir:=arg[1];
	fi;

	if(IsDirectory(dir)) then
		dir:=Filename(dir,"");
	elif(IsString(dir)) then
		dir:=Filename(Directory(dir),"");
	fi;
	relpath:=dir;

	calc:=SCPropertyByName(rep,"CalculateIndexAttributes");
	if(calc=fail) then
		calc:=true;
	fi;

	Info(InfoSimpcomp,1,"SCLibUpdate: rebuilding index for ",dir,".");

	complexes:=[];
	fvecs:=[];

	#recurse directory
	recurseDirs(dir);

	#sort entries by f vector	
	complexes:=Permuted(complexes,SortingPerm(fvecs));
	
	Info(InfoSimpcomp,1,"SCLibUpdate: rebuilding index done.");

	SCPropertySet(rep,"Index",SCIntFunc.SCPositionalObjectFromList(complexes));
	SCPropertySet(rep,"Loaded",true);
	SCPropertySet(rep,"Path",relpath);
	SCIntFunc.SCLibSave(rep);

	return rep;
end);


################################################################################
##<#GAPDoc Label="SCLibAllComplexes">
## <ManSection>
## <Func Name="SCLibAllComplexes" Arg="repository"/>
## <Returns> list of entries of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Returns a list with entries of the form <C>[ ID, NAME ]</C> of all the complexes in the given repository <Arg>repository</Arg> of type <C>SCIsLibRepository</C>. 
## <Example><![CDATA[
## gap> all:=SCLibAllComplexes(SCLib);;
## gap> all[1];
## [ 1, "Moebius Strip" ]
## gap> Length(all);
## 7648
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibAllComplexes,
function(repository)
	local i,hits,index;

	if(not SCIsLibRepository(repository) or not SCLibIsLoaded(repository)) then
		Info(InfoSimpcomp,1,"SCLibAllComplexes: first argument must be of type SCLibRepository and must be loaded.");
		return fail;
	fi;

	hits:=[];
	index:=SCPropertyByName(repository,"Index");
	for i in [1..Length(index)] do
		if(not IsBound(index[i])) then continue; fi;
		Add(hits,[i,index[i].Name]);
	od;
	return hits;
end);

################################################################################
##<#GAPDoc Label="SCLibAdd">
## <ManSection>
## <Func Name="SCLibAdd" Arg="repository, complex [, name]"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Adds a given simplicial complex <Arg>complex</Arg> to a given repository <Arg>repository</Arg> of type <C>SCIsLibRepository</C>. <Arg>complex</Arg> is saved to a file with suffix <C>.sc</C> in the repositories base path, where the file name is either formed from the optional argument <Arg>name</Arg> and the current time or taken from the name of the complex, if it is named. 
## <Example><![CDATA[
## gap> info:=InfoLevel(InfoSimpcomp);;
## gap> SCInfoLevel(0);;
## gap> myRepository:=SCLibInit("/tmp/repository");
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## gap> complex1:=SCBdCrossPolytope(4);;
## gap> SCLibAdd(myRepository,complex1);
## #I  SCLibAdd: saving complex to file "complex_Bd(beta4)_2009-10-29_17-12-36.sc\
## ".
## true
## gap> complex2:=SCBdCrossPolytope(4);;
## gap> myRepository.Add(complex2);; # alternative syntax
## gap> SCInfoLevel(info);;
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibAdd,
function(arg)
	local result,file,idxfile,index,name,newfile,newentry,i,path,rep,sc,time;

	if(Length(arg)<2 or not SCIsLibRepository(arg[1]) or not SCLibIsLoaded(arg[1]) or not SCIsSimplicialComplex(arg[2]) or (Length(arg)>2 and not IsString(arg[3])))  then
		Info(InfoSimpcomp,1,"SCLibAdd: invalid arguments.");
		return fail;
	fi;

	rep:=arg[1];
	sc:=arg[2];

	time:=SCIntFunc.GetCurrentTimeString();

	if(time=fail) then
		time:="";
	else
		SCPropertySet(sc,"Date",time);
		time:=Concatenation("_",time);
	fi;

	if(Length(arg)>2) then
		#complex, file
		file:=SCIntFunc.SanitizeFilename(ShallowCopy(arg[3]));
		
		if(Length(file)<4 or file{[Length(file)-3..Length(file)]}<>".scb") then
			Append(file,".scb");
		fi;

		path:=Filename(Directory(SCPropertyByName(rep,"Path")),file);

		if(IsExistingFile(path)) then
			Info(InfoSimpcomp,1,"SCLibAdd: file \"",file,"\" already exists -- please specify other name.");
			return fail;
		fi;

		name:=SCPropertyByName(sc,"Name");
		if(name=fail) then
			SCPropertySet(sc,"Name",file{[1..Length(file)-3]});
		fi;
	else
		#generate filename
		name:=SCPropertyByName(sc,"Name");
		if(name=fail) then
			file:=Concatenation(["complex",time,".scb"]);
		else
			file:=Concatenation(["complex_",SCIntFunc.SanitizeFilename(name),time,".scb"]);
		fi;

		#get new name
		i:=1;
		newfile:=file;
		while(IsExistingFile(Filename(Directory(SCPropertyByName(rep,"Path")),newfile))) do
			newfile:=Concatenation([file{[1..Length(file)-3]},"_",String(i),".scb"]);
			i:=i+1;
		od;

		#found free name
		file:=newfile;
		path:=Filename(Directory(SCPropertyByName(rep,"Path")),file);

		if(name=fail) then
			SCPropertySet(sc,"Name",file{[1..Length(file)-3]});
		fi;

	fi;

	#append new complex to index
	newentry:=SCIntFunc.LibGenIndexEntry(rep,Filename(Directory(SCPropertyByName(rep,"Path")),""),path,SCPropertyByName(rep,"CalculateIndexAttributes"),false,sc);

	Info(InfoSimpcomp,1,"SCLibAdd: saving complex to file \"",file,"\".");

	if(SCSave(sc,path)=fail) then
		return fail;
	fi;

	index:=List(SCPropertyByName(rep,"Index"));
	Add(index,newentry[1]);
	SCPropertySet(rep,"Index",SCIntFunc.SCPositionalObjectFromList(index));

	return SCIntFunc.SCLibSave(rep);
end);



################################################################################
##<#GAPDoc Label="SCLibDelete">
## <ManSection>
## <Func Name="SCLibDelete" Arg="repository, id"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Deletes the simplicial complex with the given id <Arg>id</Arg> from the given repository <Arg>repository</Arg>. Apart from deleting the complexes' index entry, the associated <C>.sc</C> file is also deleted.
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## gap> SCLibAdd(myRepository,SCSimplex(2));;
## gap> SCLibDelete(myRepository,1);
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibDelete,
function(repository,id)
	local path,index;

	if(not SCIsLibRepository(repository) or not SCLibIsLoaded(repository) or not IsPosInt(id)) then
		Info(InfoSimpcomp,1,"SCLibDelete: invalid arguments.");
		return fail;
	fi;

	index:=ShallowCopy(SCPropertyByName(repository,"Index"));

	if(index=fail or index = [] or not IsBound(index[id])) then
		Info(InfoSimpcomp,1,"SCLibDelete: error in index of library repository.");
		return fail;
	fi;

	path:=Filename(Directory(SCPropertyByName(repository,"Path")),index[id].File);
	if(not IsExistingFile(path)) then
		Info(InfoSimpcomp,1,"SCLibDelete: file \"",path,"\" does not exist.");
		return fail;
	fi;

	Exec("rm","-f",Concatenation(["\"",path,"\""]));

	Unbind(index[id]);
	SCPropertySet(repository,"Index",SCIntFunc.SCPositionalObjectFromList(Compacted(index)));

	return SCIntFunc.SCLibSave(repository);
end);



################################################################################
##<#GAPDoc Label="SCLibFlush">
## <ManSection>
## <Func Name="SCLibFlush" Arg="repository, confirm"/>
## <Returns><K>true</K> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Completely empties a given repository <Arg>repository</Arg>. The index and all 
## simplicial complexes in this repository are deleted. The second argument, 
## <Arg>confirm</Arg>, must be the string <C>"yes"</C> in order to confirm the deletion. 
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");;
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## gap> SCLibFlush(myRepository,"yes");
## #I  SCLibUpdate: rebuilding index for /home/effenbfx/testrepo/.
## #I  SCLibUpdate: rebuilding index done.
## true
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibFlush,
function(repository,confirm)
	local path;
	
	if(not SCIsLibRepository(repository) or not IsString(confirm)) then
		Info(InfoSimpcomp,1,"SCLibFlush: invalid arguments.");
		return fail;
	fi;
	
 	if(confirm<>"yes") then
		Info(InfoSimpcomp,1,"SCLibFlush: provide 2nd argument \"yes\" to confirm deletion of all files currently in library.");
		return fail;
	fi;

	path:=Filename(Directory(SCPropertyByName(repository,"Path")),"");
	if(not IsExistingFile(path)) then
		Info(InfoSimpcomp,1,"SCLibFlush: file \"",path,"\" does not exist.");
		return fail;
	fi;

	Exec("rm","-rf",Concatenation(["\"",path,"\""]));	
	SCLibInit(repository);
	return true;
end);



#search index entry by string
SCIntFunc.LibSearchByString:=
function(rep,key,val)
	local i,c,hits,index;

	if(not SCLibIsLoaded(rep) or not IsString(key) or not IsString(val) or not key in SCPropertyByName(rep,"IndexAttributes")) then
		Info(InfoSimpcomp,1,"SCIntFunc.LibSearchByString: invalid arguments.");
		return fail;
	fi;

	hits:=[];
	index:=SCPropertyByName(rep,"Index");
	for i in [1..Length(index)] do
		if(not IsBound(index[i])) then continue; fi;
		c:=index[i];
		if(key in RecNames(c) and PositionSublist(c.(key),val)<>fail) then
			Add(hits,[i,c.(key)]);
		fi;
	od;

	return hits;
end;


################################################################################
##<#GAPDoc Label="SCLibSearchByName">
## <ManSection>
## <Func Name="SCLibSearchByName" Arg="repository, name"/>
## <Returns>A list of items of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Searches a given repository <Arg>repository</Arg> for complexes that contain the string <Arg>name</Arg> as a substring of their name attribute and returns a list of the complexes found with entries of the form <C>[ID, NAME]</C>. See <Ref Var="SCLib"/> for a naming convention used for the global library of <Package>simpcomp</Package>.
## <Example><![CDATA[
## gap> SCLibSearchByName(SCLib,"K3");
## [ [ 584, "K3 surface" ] ]
## gap> SCLib.SearchByName("K3"); #alternative syntax
## [ [ 584, "K3 surface" ] ]
## gap> SCLib.SearchByName("S^4x"); #search for products with S^4
## [ [ 291, "S^4xS^1 (VT)" ], [ 340, "S^4xS^1 (VT)" ], [ 342, "S^4xS^1 (VT)" ], 
##   [ 571, "S^4xS^2" ], [ 627, "S^4xS^3" ], [ 655, "S^4xS^4" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibSearchByName,
function(repository,name)
	if(not SCIsLibRepository(repository) or not SCLibIsLoaded(repository) or not IsString(name)) then
		Info(InfoSimpcomp,1,"SCLibSearchByName: invalid arguments.");
		return fail;
	fi;

	return SCIntFunc.LibSearchByString(repository,"Name",name);
end);



################################################################################
##<#GAPDoc Label="SCLibSearchByAttribute">
## <ManSection>
## <Func Name="SCLibSearchByAttribute" Arg="repository, expr"/>
## <Returns>A list of items of the form <C>[ integer, string ]</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Searches a given repository <Arg>repository</Arg> for complexes for which the boolean expression <Arg>expr</Arg>, passed as string, evaluates to <K>true</K> and returns a list of complexes with entries of the form <C>[ID, NAME]</C> or <K>fail</K> upon error. The expression may use all &GAP; functions and can access all the indexed attributes of the complexes in the given repository for the query. The standard attributes are: Dim (Dimension), F (f-vector), G (g-vector), H (h-vector), Chi (Euler characteristic), Homology, Name, IsPM, IsManifold. See <C>SCLib</C> for the set of indexed attributes of the global library of <Package>simpcomp</Package>. 
## <Example><![CDATA[
## #search for all 3-neighborly complexes of dimension 4 in the global library
## gap> SCLibSearchByAttribute(SCLib,"Dim=4 and F[3]=Binomial(F[1],3)");
## [ [ 17, "CP^2 (VT)" ], [ 584, "K3 surface" ] ]
## # alternative syntax
## gap> SCLib.SearchByAttribute("Dim=4 and F[3]=Binomial(F[1],3)");
## [ [ 17, "CP^2 (VT)" ], [ 584, "K3 surface" ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
SCLibSearchByAttributeTmp:=[];
InstallGlobalFunction(SCLibSearchByAttribute,
function(repository,expr)
	local i,e,p,hits,lexpr,usedprops,skip,pos,apos,opos,prop,extprops,level,index,iattrs;

	if(not SCIsLibRepository(repository) or not SCLibIsLoaded(repository) or not IsString(expr)) then
		Info(InfoSimpcomp,1,"SCLibSearchByAttribute: invalid arguments.");
		return fail;
	fi;


	lexpr:=NormalizedWhitespace(expr);

	if(IsEmptyString(lexpr)) then
		return SCLibAllComplexes(repository);
	fi;

	usedprops:=[];
	extprops:=[];
	lexpr:=expr;

	iattrs:=List(SCPropertyByName(repository,"IndexAttributes"));
	Sort(iattrs,function(x,y) return Length(x)>Length(y); end);

	for i in iattrs do
		apos:=PositionSublist(lexpr,i);
		if(apos<>fail and (apos=1 or lexpr[apos-1]<>'.')) then
			lexpr:=ReplacedString(lexpr,i,Concatenation(["SCLibSearchByAttributeTmp.",i]));
			Add(usedprops,i);
		fi;

		while(apos<>fail) do
			prop:="";
			pos:=apos+Length(i);
			apos:=pos;

			if(pos<Length(lexpr) and lexpr[pos]='[') then
				level:=1;
				while level>=1 do
					pos:=Position(lexpr,']',pos);
					opos:=Position(lexpr,'[',pos);

					if(pos=fail) then
						#illegal statement
						return fail;
					fi;

					if(opos=fail or opos>pos) then
						level:=level-1;
					else
						level:=level+1;
						pos:=opos;
					fi;
				od;
				prop:=lexpr{[apos..pos]};
			fi;

			if(not IsEmptyString(prop)) then
				Add(extprops,[i,prop]);
				apos:=PositionSublist(lexpr,i,pos);
			else
				apos:=PositionSublist(lexpr,i,apos);
			fi;

		od;
	od;

	hits:=[];
	index:=SCPropertyByName(repository,"Index");
	for i in [1..Length(index)] do
		if(not IsBound(index[i])) then continue; fi;
		SCLibSearchByAttributeTmp:=index[i];

		skip:=false;
		for p in usedprops do
			if(not IsBound(SCLibSearchByAttributeTmp.(p))) then
				Info(InfoSimpcomp,1,"SCLibSearchByAttribute: property '",p,"' not defined for library item ",i," -- please update library with SCLibUpdate.");
				skip:=true;
				break;
			fi;
		od;

		if(skip) then continue; fi;

		for e in extprops do
			SCLibSearchByAttributeTmp:=index[i].(e[1]);

			if(EvalString(Concatenation(["IsBound(SCLibSearchByAttributeTmp",String(e[2]),")"]))=false) then
				skip:=true;
				break;
			fi;
		od;

		if(skip) then continue; fi;

		SCLibSearchByAttributeTmp:=index[i];
		if(EvalString(lexpr)=true) then
			Add(hits,[i,index[i].Name]);
		fi;
	od;
	return hits;
end);


################################################################################
##<#GAPDoc Label="SCLibStatus">
## <ManSection>
## <Func Name="SCLibStatus" Arg="repository"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Lets &GAP; print the status of a given library repository <Arg>repository</Arg>. <C>IndexAttributes</C> is the list of attributes indexed for this repository. If <C>CalculateIndexAttributes</C> is true, the index attributes for a complex added to the library are calculated automatically upon addition of the complex, otherwise this is left to the user and only pre-calculated attributes are indexed.
## <Example><![CDATA[
## gap> SCLibStatus(SCLib);
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=N
## IndexAttributes=["Name", "Date", "Dim", "F", "G", "H", "Chi", "Homology"]
## Loaded=true
## Path="GAPROOT/pkg/simpcomp/complexes/"
##]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibStatus,
function(repository)
	if(not SCIsLibRepository(repository)) then
		Info(InfoSimpcomp,1,"SCLibStatus: first argument must be of type SCLibRepositoryRep.");
		return fail;
	else
		return repository;
	fi;
end);


################################################################################
##<#GAPDoc Label="SCLibDetermineTopologicalType">
## <ManSection>
## <Func Name="SCLibDetermineTopologicalType" Arg="[repository,] complex"/>
## <Returns>simplicial complex of type <C>SCSimplicialComplex</C> or a list of integers upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## Tries to determine the topological type of a given complex <Arg>complex</Arg> by first looking for complexes with matching homology in the library repository <Arg>repository</Arg> (if no repository is passed, the global repository <C>SCLib</C> is used) and either returns a simplicial complex object (that is combinatorially isomorphic to the complex given) or a list of library ids of complexes in the library with the same homology as the complex provided.<P/>
## The ids obtained in this way can then be used to compare the corresponding complexes with <Arg>complex</Arg> via the function <Ref Meth="SCEquivalent" />.<P/>
##
## If <Arg>complex</Arg> is a combinatorial manifold of dimension <M>1</M> or <M>2</M> its topological type is computed, stored to the property <C>TopologicalType</C> and <Arg>complex</Arg> is returned.<P/>
##
## If no complexes with matching homology can be found, the empty set is returned.
## <Example><![CDATA[
## gap> c:=SCFromFacets([[1,2,3],[1,2,6],[1,3,5],[1,4,5],[1,4,6],
##                       [2,3,4],[2,4,5],[2,5,6],[3,4,6],[3,5,6]]);;
## gap> SCLibDetermineTopologicalType(c);
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibDetermineTopologicalType,
function(arg)
	local hom,candidates,c,c2,d,f,candidate,hits,repository,sc,dim,isMan,cc,c3,i,facets,topType;

	if(Length(arg)<1 or Length(arg)>2) then
		Info(InfoSimpcomp,1,"SCLibDetermineTopologicalType: invalid arguments.");
		return fail;
	fi;
	
	if(Length(arg)=1) then
		repository:=SCLib;
		sc:=arg[1];
	else
		repository:=arg[1];
		sc:=arg[2];
	fi;
	
	dim:=SCDim(sc);
	if dim = 1 then
		topType:=SCPropertyByName(sc,"TopologicalType");
		if topType <> fail and IsString(topType) then
			return sc;
		fi;
		SCPropertyDrop(sc,"TopologicalType");
		cc:=SCConnectedComponents(sc);
		isMan:=SCIsPseudoManifold(sc);
		if isMan = fail or cc = fail then
			return fail;
		fi;
		if isMan = true then
			if Size(cc) = 1 then
				SCPropertySet(sc,"TopologicalType","S^1");
			else
				SCPropertySet(sc,"TopologicalType",Concatenation(String(Size(cc))," U S^1"));
			fi;
			return sc;
		fi;
	fi;
	
	if dim = 2 then
		topType:=SCPropertyByName(sc,"TopologicalType");
		if topType <> fail and IsString(topType) then
			return sc;
		fi;
		SCPropertyDrop(sc,"TopologicalType");
		isMan:=SCIsPseudoManifold(sc);
		if isMan = fail then
			return fail;
		fi;
		if isMan = true then
			facets:=SCFacets(sc);
			if facets = fail then
				return fail;
			fi;
			c3:=SCNSFromFacets(facets);
			topType:=SCTopologicalType(c3);
			if topType = fail then
				return fail;
		  fi;
		  SCPropertySet(sc,"TopologicalType",topType);
		  return sc;
		fi;
	fi;

	if(not SCIsLibRepository(repository) or not SCIsSimplicialComplex(sc)) then
		Info(InfoSimpcomp,1,"SCLibDetermineTopologicalType: first argument must be of type SCLibRepositoryRep, second of type SCSimplicialComplex.");
		return fail;
	fi;
	
	d:=SCDim(sc);
	f:=SCFVector(sc);
	
	if(d=fail or f=fail) then
		return fail;
	fi;
	
	if(d=-1) then
		return SCEmpty();
	fi;
	
	if(f=SCFVectorBdSimplex(d+1)) then
		c2:=SCBdSimplex(d+1);
		if(SCIsIsomorphic(sc,c2)=true) then
			return c2;
		fi;
	fi;
	
	if(f=SCFVectorBdCrossPolytope(d+1)) then
		c2:=SCBdCrossPolytope(d+1);
		if(SCIsIsomorphic(sc,c2)=true) then
			return c2;
		fi;
	fi;
	
	hom:=SCHomology(sc);
	
	if(hom=fail) then
		return fail;
	fi;
	
	candidates:=SCLibSearchByAttribute(repository,Concatenation("Homology=",String(hom)));
	
	if(candidates=fail) then
		return fail;
	fi;
	
	hits:=[];
	for c in candidates do
		candidate:=SCLibLoad(repository,c[1]);
		
		if(candidate=fail) then
			continue;
		fi;
		
		if(candidate=sc or SCIsIsomorphic(sc,candidate)) then
			return SCLibLoad(repository,c[1]);
		else
			Add(hits,c[1]);
		fi;
	od;
	
	
	return hits;
end);


################################################################################
##<#GAPDoc Label="SCLibInit">
## <ManSection>
## <Func Name="SCLibInit" Arg="dir"/>
## <Returns>library repository of type <C>SCLibRepository</C> upon success, <K>fail</K> otherwise.</Returns>
## <Description>
## This function initializes a library repository object for the given directory <Arg>dir</Arg> (which has to be provided in form of a &GAP; object of type <C>String</C> or <C>Directory</C>) and returns that library repository object in case of success. The returned object then provides a mean to access the library repository via the <C>SCLib</C>-functions of <Package>simpcomp</Package>.<P/>
## The global library repository of <Package>simpcomp</Package> is loaded automatically at startup and is stored in the variable <C>SCLib</C>. User repositories can be created by calling <C>SCLibInit</C> with a desired destination directory. Note that each repository must reside in a different path since otherwise data may get lost.  <P/>
## The function first tries to load the repository index for the given directory to rebuild it (by calling <C>SCLibUpdate</C>) if loading the index fails.
## The library index of a library repository is stored in its base path in the XML file <C>complexes.idx</C>, the complexes are stored in files with suffix <C>.sc</C>, also in XML format.
## <Example><![CDATA[
## gap> myRepository:=SCLibInit("/tmp/repository");
## #I  SCLibInit: made directory "/tmp/repository/" for user library.
## #I  SCIntFunc.SCLibInit: index not found -- trying to reconstruct it.
## #I  SCLibUpdate: rebuilding index for /tmp/repository/.
## #I  SCLibUpdate: rebuilding index done.
## [Simplicial complex library. Properties:
## CalculateIndexAttributes=true
## Number of complexes in library=0
## IndexAttributes=["Name", "Date", "Dim", "F", "G", "H", "Chi", "Homology"]
## Loaded=true
## Path="/tmp/repository/"
##]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCLibInit,
function(arg)
	local rep,path;

	if(Length(arg)=0) then
		path:=Filename(Directory("~/.simpcomp/library"),"");
	else
		path:=arg[1];
		if(IsDirectory(path)) then
			path:=Filename(path,"");
		elif(IsString(path)) then
			path:=Filename(Directory(path),"");
		else
			Info(InfoSimpcomp,1,"SCLibInit: invalid parameters.");
			return fail;
		fi;
	fi;

	if(not IsReadableFile(path)) then
		Exec("mkdir","-p",path);

		if(not IsDirectoryPath(path) or not IsWritableFile(path)) then
			Info(InfoSimpcomp,1,"SCLibInit: failed to load library -- directory \"",path,"\" does not exist or is not writable. Please create it or grant write access.");
			return fail;
		else
			Info(InfoSimpcomp,1,"SCLibInit: made directory \"",path,"\" for user library.");
		fi;
	fi;

	rep:=SCIntFunc.SCLibInit(path);

	if(rep<>fail) then
		return rep;
	else
		return fail;
	fi;
end);

SCIntFunc.SCLibGlobalInit:=
function()
	local rep,path;

	path:=DirectoriesPackageLibrary("simpcomp", "complexes");
	if(path=fail) then
		Info(InfoSimpcomp,1,"SCIntFunc.SCLibGlobalInit: failed to load library -- directory \"",path,"\" does not exist or is not readable.");
		return fail;
	else
		path:=Filename(path,"");
	fi;

	rep:=SCIntFunc.SCLibInit(path);

	if(rep<>fail) then
		return rep;
	else
		return fail;
	fi;
end;


################################################################################
##<#GAPDoc Label="SCLib">
## <ManSection>
## <Var Name="SCLib" />
## <Description>
## The global variable <C>SCLib</C> contains the library object of the global library of <Package>simpcomp</Package> through which the user can access the library. The path to the global library is <C>GAPROOT/pkg/simpcomp/complexes</C>.<P/>
##
## The naming convention in the global library is the following: complexes are usually named by their topological type. As usual, `<Alt Only="LaTeX"><![CDATA[	S\^{}d]]></Alt><Alt Not="LaTeX"><![CDATA[S^d]]></Alt>' denotes a <M>d</M>-sphere, `T' a torus, `x' the cartesian product, `<Alt Only="LaTeX"><![CDATA[\~{}]]></Alt><Alt Not="LaTeX"><![CDATA[~]]></Alt>' the twisted product and `<Alt Only="LaTeX"><![CDATA[\#]]></Alt><Alt Not="LaTeX"><![CDATA[#]]></Alt>' the connected sum. The Klein Bottle is denoted by `K' or `<Alt Only="LaTeX"><![CDATA[K\^{}2]]></Alt><Alt Not="LaTeX"><![CDATA[K^2]]></Alt>'.
## <Example><![CDATA[
## gap> SCLib;
## [Simplicial complex library. Properties:
##  CalculateIndexAttributes=true
##  Number of complexes in library=689
##  IndexAttributes=["Name", "Date", "Dim", "F", "G", "H", "Chi", "Homology"]
##  Loaded=true
##  Path="GAPROOT/pkg/simpcomp/complexes/"
## ]
## gap> SCLib.Size;
## 689
## gap> SCLib.SearchByName("S^4~");
## [ [ 203, "S^4~S^1 (VT)" ], [ 330, "S^4~S^1 (VT)" ], 
##   [ 332, "S^4~S^1 (VT)" ], [ 395, "S^4~S^1 (VT)" ], 
##   [ 451, "S^4~S^1 (VT)" ], [ 452, "S^4~S^1 (VT)" ], 
##   [ 453, "S^4~S^1 (VT)" ], [ 454, "S^4~S^1 (VT)" ], 
##   [ 455, "S^4~S^1 (VT)" ], [ 458, "S^4~S^1 (VT)" ], 
##   [ 459, "S^4~S^1 (VT)" ], [ 460, "S^4~S^1 (VT)" ] ]
## gap> SCLib.Load(last[1][1]);          
## 
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################


################################################################################
