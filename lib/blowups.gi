################################################################################
##
##  simpcomp / blowups.gi
##
##  Functions for bistellar moves  
##
##  $Id: bistellar.gi 68 2010-04-23 14:08:15Z jonathan $
##
################################################################################

SCIntFunc.MapBoundaries:=function(lk,bd,pseudomanifold,singularity)

	local tmp,element,i,j,n,iso,c,
		dim_A,det_A,faces_A,F_A,F_B,
		mainDim,mainComplex,mainF,minComplex,
		raw_options,validOptions,options,randomelement,rounds,no_options_flag,
		flipsInBoundary,flipsInComplex,projectedFlips,validFlips	,
		heating,relaxation,f_min,F_min,ready_flag,numVerts,reduce,ctr;
	
	iso:=SCIsomorphism(bd,lk);
	if iso = fail then
		return fail;
	fi;
		
	# if boundaries are already isomorphic return isomorphism
	if iso <> [] then
		Info(InfoSimpcomp,1,"SCBlowup: boundaries isomorphic, no PL-homeomorphism ",
      "needed, continuing...");
		return [iso,pseudomanifold];
	fi;
	
	Info(InfoSimpcomp,1,"SCBlowup: boundaries not isomorphic, initializing ",
    "bistellar moves...");
	
	raw_options:=[];
	validOptions := [];
	# list of actual options for bistellar moves
	options:=[];
	# one element of options -> randomelement := [[element],[linkface]]
	randomelement:=[];
	# TECHNICAL VARIABLES #
	# number of rounds executed
	rounds:=0;
	# is set to "1" if no bistellar operations are left
	no_options_flag:=0;
	
	# comlpex A: lk
	dim_A:=SCDim(lk);
	det_A:=SCAltshulerSteinberg(lk);
	faces_A:=SCFaceLattice(lk);
	F_A:=SCFVector(lk);	
	if dim_A = fail or faces_A = fail or det_A = fail or F_A = fail then
		return fail;
	fi;
	
	# comlpex B: bd
	F_B:=SCFVector(bd);	
	if F_B = fail then
		return fail;
	fi;
	
	# main object: pseudomanifold
	# make face lattice and f-vector mutable
	mainComplex := ShallowCopy(SCFaceLattice(pseudomanifold));
	mainComplex:=List(mainComplex,x->ShallowCopy(x));
	mainF := ShallowCopy(SCFVector(pseudomanifold));
	numVerts := mainF[1];
	mainDim := SCDim(pseudomanifold);
	if mainComplex = fail or mainF = fail or mainDim = fail then
		return fail;
	fi;
	
	#############################################
	#                                           #
	#                                           #
	#   computing initial options for moves     #
	#                                           #
	#                                           #
	#############################################
	reduce := false;
	rounds:=1;
	f_min := ShallowCopy(F_A);
	minComplex:=SC(mainComplex[5]);
		
	while no_options_flag = 0 or rounds <= 100000 do
	
		### computing possible flips in complex ###
		flipsInComplex := [];
		for i in [0..mainDim] do
			flipsInComplex[i+1] := SCIntFunc.IRawBistellarRMoves(i,mainComplex,(mainDim+1));
		od;
		
		if not reduce then
			### computing possible flips in boundary ###
			flipsInBoundary := [];
			for i in [0..dim_A] do
				flipsInBoundary[i+1] := SCIntFunc.IRawBistellarRMoves(i,faces_A,(dim_A+1));
			od;
			# remove flips that DO NOT contain "singularity"
			tmp := [];
			n:=Size(flipsInComplex);
			for i in [1..n] do
				tmp[i] := [];
				for element in flipsInComplex[i] do
					if not singularity in element[1] and not singularity in element[2] then
						Add(tmp[i],element);
					fi;
				od;
			od;
			for i in [1..n] do
				flipsInComplex[i] := Difference(flipsInComplex[i],tmp[i]);
			od;
		else	
			# remove flips that DO contain "singularity"
			tmp := [];
			n:=Size(flipsInComplex);
			for i in [1..n] do
				tmp[i] := [];
				for element in flipsInComplex[i] do
					if singularity in element[1] or singularity in element[2] then
						Add(tmp[i],element);
					fi;
				od;
			od;
			for i in [1..n] do
				flipsInComplex[i] := Difference(flipsInComplex[i],tmp[i]);
			od;
		fi;
		
		# remove flips that aren't valid
		validFlips := [];
		for i in [0..mainDim] do
			validFlips[i+1] := SCIntFunc.IBistellarRMoves(i,(mainDim+1),flipsInComplex[i+1],mainComplex);
		od;
		flipsInComplex := ShallowCopy(validFlips);
		
		if not reduce then
			# compute projected flips
			projectedFlips := [];
			for i in [1..Size(flipsInComplex)] do
				projectedFlips[i] := [];
				for element in flipsInComplex[i] do
					tmp := [ Difference(element[1],[singularity]) , Difference(element[2],[singularity]) ];
					Add(projectedFlips[i],tmp);
				od;
			od;
			# computing intersection of projectedFlips and flipsInBoundary
			raw_options := [];
			for i in [1..Size(flipsInBoundary)] do
				raw_options[i] := [];
				for element in flipsInBoundary[i] do
					if element in projectedFlips[i] then
						Add(raw_options[i],element);
					fi;
				od;
			od;
		else
			raw_options := ShallowCopy(flipsInComplex);
		fi;
	
		### initial parameters ###
		heating:=0;
		relaxation:=0;
		if reduce then
			ctr:=0;
		fi;
		
		while no_options_flag = 0 and rounds <= 100000 do    
			### strategy for selecting options ###
			options:=[];
			if reduce then
				ctr:=ctr+1;
			fi;
			
			if reduce and (mainF[1] < 3/2*numVerts or ctr >= 5000) then
				reduce := false;
				# main object: pseudomanifold
				# make face lattice and f-vector mutable
				mainComplex := ShallowCopy(SCFaceLattice(minComplex));
				mainComplex:=List(mainComplex,x->ShallowCopy(x));
				mainF := ShallowCopy(SCFVector(minComplex));
				mainDim := SCDim(minComplex);
				if mainComplex = fail or mainF = fail or mainDim = fail then
					return fail;
				fi;
				lk:=SCLink(minComplex,singularity);
				dim_A:=SCDim(lk);
				det_A:=SCAltshulerSteinberg(lk);
				faces_A:=SCFaceLattice(lk);
				F_A:=SCFVector(lk);	
				if dim_A = fail or faces_A = fail or det_A = fail or F_A = fail then
					return fail;
				fi;
				break;
			fi;
			
			if not reduce and mainF[1] > 3*numVerts then
				reduce := true;
				# main object: pseudomanifold
				# make face lattice and f-vector mutable
				mainComplex := ShallowCopy(SCFaceLattice(minComplex));
				mainComplex:=List(mainComplex,x->ShallowCopy(x));
				mainF := ShallowCopy(SCFVector(minComplex));
				F_min := ShallowCopy(mainF);
				mainDim := SCDim(minComplex);
				if mainComplex = fail or mainF = fail or mainDim = fail then
					return fail;
				fi;
				break;
			fi;
			
			if not reduce then
				
				if heating > 0 then
					if IsInt(heating/15) = true and f_min > F_B then
						tmp := SCIntFunc.IBistellarRMoves(0,(dim_A+1),raw_options[1],faces_A);
						Append(options,tmp);
					else
						tmp := SCIntFunc.IBistellarRMoves(1,(dim_A+1),raw_options[2],faces_A);
						Append(options,tmp);
						if options = [] then
							tmp := SCIntFunc.IBistellarRMoves(2,(dim_A+1),raw_options[3],faces_A);
							Append(options,tmp);
							heating:=0;
						fi;
					fi;
					heating:=heating-1;
				else
					tmp := SCIntFunc.IBistellarRMoves(3,(dim_A+1),raw_options[4],faces_A);
					Append(options,tmp);
					if options = [] then
						tmp := SCIntFunc.IBistellarRMoves(2,(dim_A+1),raw_options[3],faces_A);
						Append(options,tmp);
						if options = [] then
							tmp := SCIntFunc.IBistellarRMoves(1,(dim_A+1),raw_options[2],faces_A);
							Append(options,tmp);
							if relaxation = 10 then
								heating:=15;
								relaxation:=0;
							fi;
							relaxation:=relaxation+1;
							if options = [] then
								tmp := SCIntFunc.IBistellarRMoves(0,(dim_A+1),raw_options[1],faces_A);
								options := Union(options,tmp);
							fi;
						fi;
					fi;
				fi;
				
				# choosing move at random
				if no_options_flag <> 0 then
					Info(InfoSimpcomp,1,"SCBlowup: no valid flip found.");
					return fail;
				fi;
				# check, if possible options are available
				if options = [] then
					Info(InfoSimpcomp,1,"SCBlowup: no options left for bistellar moves...");
					return fail;
				fi;
				
				# chose move in boundary
				tmp:=RandomList(options);
				
				# check, if there's a corresponding move in the main complex
				ready_flag := 0;
				for i in [1..Size(flipsInComplex)] do
					if ready_flag = 0 then
						for element in flipsInComplex[i] do
							if IsSubset(element[1],tmp[1]) and IsSubset(element[2],tmp[2]) then
								randomelement := element;
								ready_flag := 1;
								break;
							fi;
						od;
					else
						break;
					fi;
				od;
				
				# re-check existence of randomelement in complex
				ready_flag := 0;
				for i in [1..Size(flipsInComplex)] do
					if Intersection(flipsInComplex[i],[randomelement]) <> [] then
						ready_flag := 1;
						break;
					fi;
				od;
					
			else
				
				if heating > 0 then
					if IsInt(heating/20) = true then
						 tmp := SCIntFunc.IBistellarRMoves(0,(mainDim+1),raw_options[1],mainComplex);
						 Append(options,tmp);
					else
						 tmp := SCIntFunc.IBistellarRMoves(1,(mainDim+1),raw_options[2],mainComplex);
						 Append(options,tmp);
						 tmp := SCIntFunc.IBistellarRMoves(2,(mainDim+1),raw_options[3],mainComplex);
						 Append(options,tmp);
						 if options = [] then
								tmp := SCIntFunc.IBistellarRMoves(3,(mainDim+1),raw_options[4],mainComplex);
								Append(options,tmp);
						 fi;
					fi;
					heating:=heating-1;
				else
					tmp := SCIntFunc.IBistellarRMoves(4,(mainDim+1),raw_options[5],mainComplex);
					Append(options,tmp);
					if options = [] then
						 tmp := SCIntFunc.IBistellarRMoves(3,(mainDim+1),raw_options[4],mainComplex);
						 Append(options,tmp);
						 if options = [] then
								tmp := SCIntFunc.IBistellarRMoves(1,(mainDim+1),raw_options[2],mainComplex);
								Append(options,tmp); 
								tmp := SCIntFunc.IBistellarRMoves(2,(mainDim+1),raw_options[3],mainComplex);
								Append(options,tmp); 
								if relaxation = 15 then 
									 heating:=20;
									 relaxation:=0;
								fi;
								relaxation:=relaxation+1;
								if options = [] then
									 tmp := SCIntFunc.IBistellarRMoves(0,(mainDim+1),raw_options[1],mainComplex);
									 Append(options,tmp);
								fi;
				
						 fi;
					fi;
				fi;
				
				# choosing move at random
				if no_options_flag <> 0 then
					Info(InfoSimpcomp,1,"SCBlowup: no valid flip found.");
					return fail;
				fi;
				# check, if possible options are available
				if options = [] then
					Info(InfoSimpcomp,1,"SCBlowup: no options left for bistellar moves...");
					return fail;
				fi;
				# chose move in boundary
				randomelement:=RandomList(options);
				ready_flag:=1;	
			fi;
			
			# if valid flip exists in complex perform flip
			if ready_flag <> 1 then
				Info(InfoSimpcomp,1,"SCBlowup: no valid flip found.");
				return fail;
			fi;
							
			tmp := SCIntFunc.Move((mainDim+1)-Length(randomelement[1]),
			(mainDim+1),mainComplex,mainF,randomelement,flipsInComplex,0,[]);
			mainComplex := tmp[1];
			mainF := tmp[2];
			flipsInComplex := tmp[3];
			Info(InfoSimpcomp,2,"SCBlowup: ",mainDim+1-Length(randomelement[1]),"-Move   (",rounds," rounds)");
			if reduce then
				Info(InfoSimpcomp,2,"SCBlowup: ",mainF);
			fi;
			
			if not reduce then
			
				# remove flips that DO NOT contain "singularity"
				tmp := [];
				for i in [1..Size(flipsInComplex)] do
					for element in flipsInComplex[i] do
						if not singularity in element[1] and not singularity in element[2] then
							Add(tmp,element);
						fi;
					od;
					flipsInComplex[i] := Difference(flipsInComplex[i],tmp);
				od;
			
			else
			
				# remove flips that DOES contain "singularity"
				tmp := [];
				for i in [1..Size(flipsInComplex)] do
					for element in flipsInComplex[i] do
						if singularity in element[1] or singularity in element[2] then
							Add(tmp,element);
						fi;
					od;
					flipsInComplex[i] := Difference(flipsInComplex[i],tmp);
				od;
			
			fi;
			
			# remove flips that aren't valid
			validFlips := [];
			for i in [0..mainDim] do
				validFlips[i+1] := SCIntFunc.IBistellarRMoves(i,(mainDim+1),flipsInComplex[i+1],mainComplex);
			od;
			flipsInComplex := ShallowCopy(validFlips);
			
			if not reduce then
				# compute projected flips
				projectedFlips := [];
				for i in [1..Size(flipsInComplex)] do
					projectedFlips[i] := [];
					for element in flipsInComplex[i] do
						tmp := [ Difference(element[1],[singularity]) , Difference(element[2],[singularity]) ];
						Add(projectedFlips[i],tmp);
					od;
				od;
								
				# update boundary
				c:=SCLink(SC(mainComplex[mainDim+1]),singularity);
				faces_A := SCFaceLattice(c); 
				F_A := SCFVector(c); 
				det_A := SCAltshulerSteinberg(c);
				dim_A := SCDim(c);
				
				if faces_A = fail or F_A = fail or det_A = fail or dim_A = fail then
					return fail;
				fi;
				
				### computing possible flips in boundary ###
				flipsInBoundary := [];
				for i in [0..dim_A] do
					flipsInBoundary[i+1] := SCIntFunc.IRawBistellarRMoves(i,faces_A,(dim_A+1));
				od;
				
				# computing intersection of projectedFlips and flipsInBoundary
				raw_options := [];
				for i in [1..Size(flipsInBoundary)] do
					raw_options[i] := [];
					for element in flipsInBoundary[i] do
						for j in [1..Size(projectedFlips)] do
							if element in projectedFlips[j] then
								Add(raw_options[i],element);
							fi;
						od;
					od;
				od;
				
				if F_A < f_min then
					f_min := ShallowCopy(F_A);
					minComplex:=SC(mainComplex[mainDim+1]);
					Info(InfoSimpcomp,1,"SCBlowup: found complex with smaller boundary: f = ",f_min,".");
				fi;
				
				Info(InfoSimpcomp,2,"SCBlowup: ",mainF," - ",F_A);
				
				
				###########################
				### test, if isomorphic ###
				###########################
				
				iso:=SCIsomorphism(bd,SC(faces_A[dim_A+1]));
				if iso = fail then
					return fail;
				fi;
				
				# if boundaries are isomorphic return isomorphism
				if iso <> [] then
					Info(InfoSimpcomp,1,"SCBlowup: found complex with isomorphic boundaries.");
					return [iso,minComplex];
				fi;
			else
				
				if mainF < F_min then
					F_min := ShallowCopy(mainF);
					minComplex:=SC(mainComplex[mainDim+1]);
					Info(InfoSimpcomp,1,"SCBlowup: reduced complex: f = ",F_min,".");
				fi;
			
				raw_options:=ShallowCopy(flipsInComplex);						
			fi;
			rounds:=rounds+1;
		od; # end: map boundaries
		
	od; # end: no_options_flag = 0 and rounds <= 100000
	
	
	Info(InfoSimpcomp,1,"SCBlowup: no flip sequence found, stopping.");
	return fail;

end;



################################################################################
##<#GAPDoc Label="SCBlowup">
## <ManSection>
## <Prop Name="SCBlowup" Arg="pseudomanifold,singularity[,mappingCyl]"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## If <C>singularity</C> is an ordinary double point of a combinatorial 
## <M>4</M>-pseudomanifold <Arg>pseudomanifold</Arg> 
## (lk(<C>singularity</C><M>) = \mathbb{R}P^3</M>) the blowup of 
## <C>pseudomanifold</C> at <C>singularity</C> is computed. If it is a 
## singularity of type <M>S^2 \times S^1</M>, <M>S^2 \dtimes S^1</M> or 
## <M>L(k,1)</M>, <M>k \leq 4</M>, the canonical resolution of 
## <C>singularity</C> is computed using the bounded complexes provided in 
## the source code below. <P/>
##
## If the optional argument <C>mappingCyl</C> of type 
## <C>SCIsSimplicialComplex</C> is given, this complex will be used to to 
## resolve the singularity <C>singularity</C>.<P/>
##
## Note that bistellar moves do not necessarily preserve any orientation. 
## Thus, the orientation of the blowup has to be checked in order to verify 
## which type of blowup was performed. Normally, repeated computation results 
## in both versions.
## <Example><![CDATA[
## gap> SCLib.SearchByName("Kummer variety");
## [ [ 519, "4-dimensional Kummer variety (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;                
## gap> d:= SCBlowup(c,1);
## ]]></Example>
## <Example><![CDATA[ NOEXECUTE
## gap> # resolving the singularities of a 4 dimensional Kummer variety
## gap> SCLib.SearchByName("Kummer variety");
## [ [ 519, "4-dimensional Kummer variety (VT)" ] ]
## gap> c:=SCLib.Load(last[1][1]);;
## gap> for i in [1..16] do
##        for j in SCLabels(c) do 
##          lk:=SCLink(c,j);
##          if lk.Homology = [[0],[0],[0],[1]] then continue; fi; 
##          singularity := j; break;
##        od;
##        c:=SCBlowup(c,singularity); 
##      od;
## gap> d.IsManifold;
## true
## gap> d.Homology;
## [ [ 0, [ ] ], [ 0, [ ] ], [ 22, [ ] ], [ 0, [ ] ], [ 1, [ ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCBlowup,
	function(arg)

	local pseudomanifold,singularity,
		equivalent,labels,lk,mapCyl,bd,maniflag,iso,minComplex,tmp,i,
		facets,cylinder,c, maxRounds,infLvl,hom;
	
	if Size(arg) < 2 or Size(arg) > 3 then
		Info(InfoSimpcomp,1,"SCBlowup: number of arguments must be 2 or 3.");
		return fail;
	fi;
	
	pseudomanifold:=arg[1];
	singularity:=arg[2];
	if Size(arg) = 3 then
		mapCyl:=arg[3];
	fi;
	
	if(not SCIsSimplicialComplex(pseudomanifold) or SCDim(pseudomanifold) <> 4 or not SCIsMovableComplex(pseudomanifold)) then
		Info(InfoSimpcomp,1,"SCBlowup: first argument must be a combinatorial pseudomanifold of type SCSimplicialComplex and of dimension 4.");
		return fail;
	fi;
	
	labels:=SCLabels(pseudomanifold);
	if labels = fail then
		return fail;
	fi;
	if(not singularity in labels) then
		Info(InfoSimpcomp,1,"SCBlowup: second argument must be a vertex label of the first argument.");
		return fail;
	fi;
	
	if IsBound(mapCyl) and (not SCIsSimplicialComplex(mapCyl) or SCDim(pseudomanifold) <> 4 or not SCHasBoundary(mapCyl)) then
		Info(InfoSimpcomp,1,"SCBlowup: third argument must be a bounded combinatorial 4-manifold of type SCSimplicialComplex.");
		return fail;
	fi;
	
	lk:=SCLink(pseudomanifold,singularity);
	if lk = fail then
		return fail;
	fi;
	
	Info(InfoSimpcomp,1,"SCBlowup: checking if singularity is a combinatorial manifold...");
	
	maniflag:=SCIsManifold(lk);
	if maniflag = fail then
		return fail;
	fi;
	if not maniflag then
		Info(InfoSimpcomp,1,"SCBlowup: singularity is not a manifold.");
		return fail;
	fi;
	
	Info(InfoSimpcomp,1,"SCBlowup: ...true");
	
	Info(InfoSimpcomp,1,"SCBlowup: checking type of singularity...");
	
	hom:=SCHomology(lk);
	if hom = fail then
		return fail;
	fi;
	
	if not IsBound(mapCyl) then
			
		if hom = [ [ 0, [  ] ], [ 1, [  ] ], [ 0, [ 2 ] ], [ 0, [  ] ] ] then
			mapCyl:=SCFromDifferenceCycles([[1,1,1,1,5]]);
			bd:=SCBoundary(mapCyl);
			if bd = fail then
				return fail;
			fi;
			equivalent:=SCEquivalent(lk,bd);
			if equivalent = fail then
				return fail;
			fi;
			if not equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
				return fail;
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: ...3-dimensional Klein bottle (supported type).");	
		elif hom = [ [ 0, [  ] ], [ 1, [  ] ], [ 1, [  ] ], [ 1, [  ] ] ] then
			mapCyl:=SCFromDifferenceCycles([[1,1,1,1,6]]);
			bd:=SCBoundary(mapCyl);
			if bd = fail then
				return fail;
			fi;
			equivalent:=SCEquivalent(lk,bd);
			if equivalent = fail then
				return fail;
			fi;
			if not equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
				return fail;
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: ...S^2 x S^1 (supported type).");	
		elif hom = [ [ 0, [ ] ], [ 0, [ 2 ] ], [ 0, [ ] ], [ 1, [ ] ] ] then
			mapCyl:=SC([
			[1,2,3,5,8],[1,2,3,5,11],[1,2,3,8,11],[1,2,4,5,7],[1,2,4,5,11],
			[1,2,4,9,11],[1,2,5,7,8],[1,2,7,8,10],[1,2,8,10,11],[1,3,4,7,8],
			[1,3,5,6,11],[1,3,6,7,11],	[1,3,7,8,11],[1,4,5,7,9],[1,4,5,9,11],
			[1,4,7,8,9],[1,5,7,8,9],[1,6,7,10,11],[1,7,8,10,11],[2,3,5,6,11],
			[2,3,6,9,11],[2,4,5,6,11],[2,4,6,9,11],[3,4,7,8,11],[3,6,7,9,11],
			[4,5,7,9,11],[4,6,8,9,11],[4,7,8,9,11],[6,7,8,9,11],[6,7,8,10,11]]);
			bd:=SCBoundary(mapCyl);
			if bd = fail then
				return fail;
			fi;
			equivalent:=SCEquivalent(lk,bd);
			if equivalent = fail then
				return fail;
			fi;
			if not equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
				return fail;
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: ...ordinary double point (supported type).");
		elif hom = [ [ 0, [ ] ], [ 0, [ 3 ] ], [ 0, [ ] ], [ 1, [ ] ] ] then
			mapCyl:=SC([
				[1,2,3,5,7],[1,2,3,5,11],[1,2,3,7,12],[1,2,3,11,12],[1,2,4,5,6],
				[1,2,4,5,11],[1,2,4,6,12],[1,2,4,11,12],[1,2,5,6,7],[1,2,6,7,9],
				[1,2,7,8,9],[1,3,4,6,10],[1,3,4,6,11],[1,3,4,10,12],[1,3,4,11,12],
				[1,3,5,7,10],[1,3,7,10,12],[1,4,5,6,8],[1,4,6,7,8],[1,4,6,7,9],
				[1,4,6,9,11],[1,4,6,10,12],[1,4,7,8,9],[1,5,6,7,8],[1,5,7,10,12],
				[2,3,5,7,10],[2,5,6,7,9],[2,5,7,9,10],[2,7,8,9,10],[3,4,6,7,8],
				[3,4,6,7,11],[3,4,7,8,9],[3,4,7,10,11],[3,4,10,11,12],[3,6,7,8,11],
				[3,7,8,9,12],[3,7,8,10,11],[3,7,8,10,12],[3,8,10,11,12],[4,6,7,9,11],
				[5,7,9,10,12],[7,8,9,10,12]]);
			bd:=SCBoundary(mapCyl);
			if bd = fail then
				return fail;
			fi;
			equivalent:=SCEquivalent(lk,bd);
			if equivalent = fail then
				return fail;
			fi;
			if not equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
				return fail;
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: ...L(3,1) (supported type).");
		elif hom = [ [ 0, [ ] ], [ 0, [ 4 ] ], [ 0, [ ] ], [ 1, [ ] ] ] then
			mapCyl:=SC([
				[1,2,4,5,6],[1,2,4,5,12],[1,2,4,6,8],[1,2,4,8,9],[1,2,4,9,12],
				[1,2,5,6,11],[1,2,5,11,12],[1,2,6,8,11],[1,2,7,11,14],[1,2,8,11,14],
				[1,2,9,11,12],[1,3,4,7,9],[1,3,4,7,10],[1,3,4,9,12],[1,3,4,10,12],
				[1,3,5,7,9],[1,3,5,7,12],[1,3,5,9,11],[1,3,5,11,12],[1,3,7,10,12],
				[1,3,9,11,12],[1,4,5,12,13],[1,4,6,8,11],[1,4,7,8,9],[1,4,7,8,11],
				[1,4,10,12,13],[1,5,6,9,11],[1,5,7,8,9],[1,5,7,8,13],[1,5,7,12,13],
				[1,7,8,11,14],[1,7,8,13,14],[1,7,12,13,14],[1,8,10,13,14],[1,10,12,13,14],
				[2,5,6,10,14],[2,5,6,11,14],[2,5,10,11,14],[2,6,8,11,14],[2,6,10,13,14],
				[2,7,11,13,14],[2,10,11,13,14],[3,4,9,12,13],[3,4,10,12,13],[3,5,6,9,11],
				[3,5,6,9,14],[3,5,6,11,14],[3,6,9,11,12],[3,6,9,12,13],[3,6,9,13,14],
				[3,6,10,12,13],[5,6,9,10,14],[6,9,10,12,13],[6,9,10,13,14],[7,8,11,13,14],
				[8,10,11,13,14],[9,10,12,13,14]]);
			bd:=SCBoundary(mapCyl);
			if bd = fail then
				return fail;
			fi;
			equivalent:=SCEquivalent(lk,bd);
			if equivalent = fail then
				return fail;
			fi;
			if not equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
				return fail;
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: ...L(4,1) (supported type).");
		elif hom{[1,3,4]} = [ [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ] and hom[2][1] = 0 and IsBound(hom[2][2]) and Size(hom[2][2]) = 1 and hom[2][2][1] in [5..11] then
			Info(InfoSimpcomp,1,"SCBlowup: Might be singularity of type L(",hom[2][2][1],",1), try loading the complex with the name \"Mapping cylinder L(",hom[2][2][1],",1)\" from the library.");			
		elif hom = [ [ 0, [  ] ], [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ] ] then
			equivalent:=SCEquivalent(lk,SCBdSimplex(4));
			if equivalent = fail then
				return fail;
			fi;
			if equivalent then
				Info(InfoSimpcomp,1,"SCBlowup: singularity is a regular vertex, use SCConnectedSum(pseudomanifold,CP^2) or SCConnectedSumMinus(pseudomanifold,CP^2) to perform blowups of ordinary points. Returning SCConnectedSum(pseudomanifold,CP^2).");
				mapCyl:=SC([
					[1,2,3,4,5],[1,2,3,4,7],[1,2,3,5,8],[1,2,3,7,8],[1,2,4,5,6],
					[1,2,4,6,7],[1,2,5,6,8],[1,2,6,7,9],[1,2,6,8,9],[1,2,7,8,9],
					[1,3,4,5,9],[1,3,4,7,8],[1,3,4,8,9],[1,3,5,6,8],[1,3,5,6,9],
					[1,3,6,8,9],[1,4,5,6,7],[1,4,5,7,9],[1,4,7,8,9],[1,5,6,7,9],
					[2,3,4,5,9],[2,3,4,6,7],[2,3,4,6,9],[2,3,5,7,8],[2,3,5,7,9],
					[2,3,6,7,9],[2,4,5,6,8],[2,4,5,8,9],[2,4,6,8,9],[2,5,7,8,9],
					[3,4,6,7,8],[3,4,6,8,9],[3,5,6,7,8],[3,5,6,7,9],[4,5,6,7,8],
					[4,5,7,8,9]]);
				return SCConnectedSum(pseudomanifold,mapCyl);
			fi;
			Info(InfoSimpcomp,1,"SCBlowup: type of singularity not supported.");
			return fail;
		fi;
		
	else
		
		bd:=SCBoundary(mapCyl);
		if bd = fail then
			return fail;
		fi;
		
		equivalent:=SCEquivalent(lk,bd);
		if equivalent = fail then
			return fail;
		fi;
		if not equivalent then
			Info(InfoSimpcomp,1,"SCBlowup: mapping cylinder does not map link of singularity.");
			return fail;
		fi;
		Info(InfoSimpcomp,1,"SCBlowup: ...specified mapping cylinder PL-homeomorphic to link of singularity.");
		
	fi;
	
	Info(InfoSimpcomp,1,"SCBlowup: starting blowup...");
	
	Info(InfoSimpcomp,1,"SCBlowup: map boundaries...");
	
	tmp:=SCIntFunc.MapBoundaries(lk,bd,pseudomanifold,singularity);
	if tmp = fail then
		return fail;
	fi;
	
	Info(InfoSimpcomp,1,"SCBlowup: ...boundaries mapped succesfully.");
	
	Info(InfoSimpcomp,1,"SCBlowup: build complex...");
	
	iso:=tmp[1];
	minComplex:=tmp[2];
	if iso = fail or minComplex = fail then
		return fail;
	fi;

	labels:=[];
	for i in iso do
		labels[i[1]]:=[i[2]];
	od;
	SCRelabel(mapCyl,labels);
	facets:=ShallowCopy(SCFacets(mapCyl));
	if facets = fail then
		return fail;
	fi;
	facets:=List(facets,x->ShallowCopy(x));
	for i in facets do Sort(i); od;
	Sort(facets);
	mapCyl:=SC(facets);
	
	facets:=SCFacets(SCLink(minComplex,singularity));
	if facets = fail then
		return fail;
	fi;
	
	cylinder:=[];
	for i in [1..Size(facets)] do
		Add(cylinder,[facets[i][1],facets[i][2],facets[i][3],facets[i][4],[facets[i][1]]]);
		Add(cylinder,[facets[i][2],facets[i][3],facets[i][4],[facets[i][1]],[facets[i][2]]]);
		Add(cylinder,[facets[i][3],facets[i][4],[facets[i][1]],[facets[i][2]],[facets[i][3]]]);
		Add(cylinder,[facets[i][4],[facets[i][1]],[facets[i][2]],[facets[i][3]],[facets[i][4]]]);
	od;
	cylinder:=SC(cylinder);
	
	c:=Union(Union(Difference(minComplex,SCStar(minComplex,singularity)),cylinder),mapCyl);
	
	Info(InfoSimpcomp,1,"SCBlowup: ...done.");
	
	Info(InfoSimpcomp,1,"SCBlowup: ...blowup completed.");
	Info(InfoSimpcomp,1,"SCBlowup: You may now want to reduce the complex via 'SCReduceComplex'.");
	return c;
	
end);


################################################################################
##<#GAPDoc Label="SCMappingCylinder">
## <ManSection>
## <Func Name="SCMappingCylinder" Arg="k"/>
## <Returns> simplicial complex of type <C>SCSimplicialComplex</C> upon 
## success, <K>fail</K> otherwise.</Returns>
## <Description>
## Generates a bounded version of <M>\mathbb{C}P^2</M> (a so-called mapping 
## cylinder for a simplicial blowup, compare 
## <Cite Key="Spreer09CombPorpsOfK3"/>) with boundary 
## <M>L(</M><C>k</C><M>,1)</M>.
## <Example><![CDATA[
## gap> mapCyl:=SCMappingCylinder(3);;
## gap> mapCyl.Homology;              
## [ [ 0, [  ] ], [ 0, [  ] ], [ 1, [  ] ], [ 0, [  ] ], [ 0, [  ] ] ]
## gap> l31:=SCBoundary(mapCyl);;
## gap> l31.Homology;
## [ [ 0, [  ] ], [ 0, [ 3 ] ], [ 0, [  ] ], [ 1, [  ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallGlobalFunction(SCMappingCylinder,
function(k)

	local gridtorus,CSsphere,identification,createlens,
		lens,facets,vertices,i,j,complex,
		cyl,simpcyl,idcyl,rencyl,redcyl;

		gridtorus:=function(k)
			local i,j,a,b,complex;
			complex:=[];
			for i in [1..3*k] do
				for j in [1..3*k] do
					if i = 3*k then
						a:=1;
					else
						a:=i+1;
					fi;
					if j = 3*k then
						b:=1;
					else
						b:=j+1;
					fi;
					Add(complex,[[i,j],[a,j],[a,b]]);
					Add(complex,[[i,j],[i,b],[a,b]]);
				od;
			od;
			return complex;
		end;;

		CSsphere:=function(k)
			local sphere, torus, element, a, b, i;
			sphere:=[];
			torus:=gridtorus(k);
			for element in torus do
				a:=Minimum([element[1][1],element[2][1],element[3][1]]);
				if 3*k in [element[1][1],element[2][1],element[3][1]] and a = 1 then
					Add(sphere,Union(element,[[3*k,0]]));
				else
					Add(sphere,Union(element,[[a,0]]));
				fi;
				if element[1][1] = element[2][1] then
					if element[1][1] = 1 then
						Add(sphere,[[3*k,0],[1,0],element[1],element[2]]);
					else
						Add(sphere,[[element[1][1]-1,0],[element[1][1],0],element[1],element[2]]);
					fi;
				fi;
				b:=Minimum([element[1][2],element[2][2],element[3][2]]);
				if 3*k in [element[1][2],element[2][2],element[3][2]] and b = 1 then
					Add(sphere,Union(element,[[0,3*k]]));
				else
					Add(sphere,Union(element,[[0,b]]));
				fi;
				if element[1][2] = element[2][2] then
					if element[1][2] = 1 then
						Add(sphere,[[0,3*k],[0,1],element[1],element[2]]);
					else
						Add(sphere,[[0,element[1][2]-1],[0,element[1][2]],element[1],element[2]]);
					fi;
				fi;
			od;
			for i in [1..Size(sphere)] do
				Sort(sphere[i]);
			od;
			Sort(sphere);
			return sphere;
		end;;


		identification:=function(sphereOrig)
			local i,j,l,max,sphere;
			sphere:=SCIntFunc.DeepCopy(sphereOrig);
			max:=0;
			for i in sphere do
				for j in i do
					for l in j do
						if l > max then
							max:=l;
						fi;
					od;
				od;
			od;
			for i in [1..Size(sphere)] do
				for j in [1..Size(sphere[i])] do
					if sphere[i][j][1] = 0 then				
						sphere[i][j][2]:=((sphere[i][j][2]-1) mod 3)+1;
					elif sphere[i][j][2] = 0 then
						sphere[i][j][1]:=((sphere[i][j][1]-1) mod 3)+1;
					else
						sphere[i][j]:=sphere[i][j]-1;
						while sphere[i][j][1] >= 3 do
							sphere[i][j]:=sphere[i][j]-3;
						od;
						sphere[i][j]:=(sphere[i][j] mod max) +1;
					fi;
				od;
				Sort(sphere[i]);
			od;
			Sort(sphere);
			return Set(sphere);
		end;;


		createlens:=function(k)
			return SC(identification(CSsphere(k)));
		end;;

	lens:=createlens(k);;
	facets:=lens.Facets;;
	cyl:=[]; 
	for i in [1..Size(facets)] do 
		Add(cyl,Union(facets[i],facets[i]+3*k+1)); 
	od;

	simpcyl:=[]; 
	for i in [1..Size(cyl)] do
		simpcyl:=Union(simpcyl,[cyl[i]{[1..5]},cyl[i]{[2..6]},cyl[i]{[3..7]},cyl[i]{[4..8]}]);
	od;
	idcyl:=[]; 
	for i in [1..Size(simpcyl)] do 
		idcyl[i]:=[]; 
		for j in [1..5] do 
			if Maximum(simpcyl[i][j]) <= 3*k then 
				if simpcyl[i][j][1] = 0 then 
					idcyl[i][j] := 3*k+1; 
				elif simpcyl[i][j][2] = 0 then 
					idcyl[i][j]:=3*k+2; 
				else 
					idcyl[i][j]:= (simpcyl[i][j][1]-simpcyl[i][j][2]) mod (3*k);
				fi; 
			else 
				idcyl[i][j]:=ShallowCopy(simpcyl[i][j]); 
			fi; 
		od; 
	od;
	vertices:=Union(idcyl);
	rencyl:=[]; 
	for i in [1..Size(idcyl)] do 
		rencyl[i]:=[]; 
		for j in [1..5] do 
			rencyl[i][j]:=Position(vertices,idcyl[i][j]); 
		od; 
	od;

	redcyl:=[]; 
	for i in rencyl do 
		if Size(Set(i)) = 5 then 
			AddSet(redcyl,i); 
		fi; 
	od;
	complex:=SCFromFacets(redcyl);
	
	SCRename(complex,Concatenation("Mapping cylinder Bd(CP^2) = L(",String(k),",1)"));	
	return complex;

end);

