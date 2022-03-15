################################################################################
##
##  simpcomp / homology.gi
##
##  Homology related functions
##
##  $Id$
##
################################################################################

SCIntFunc.HomTransposeSparseMat:=function(A)
	local res,yind,i,j;
	res:=rec(n_row:=A.n_col, n_col:=A.n_row,M:=[]);
	for i in [1..res.n_col]do
		res.M[i]:=rec(n_entries:=0,inds:=[],vals:=[]);
	od;
	for i in [A.n_col,A.n_col-1..1] do
		for j in [1..A.M[i].n_entries] do
			yind:=A.M[i].inds[j];
			res.M[yind].n_entries:=res.M[yind].n_entries+1;
			Add(res.M[yind].inds,i);
			Add(res.M[yind].vals,A.M[i].vals[j]);
		od;
	od;
	return res;
end;;


SCIntFunc.HomSparseToDenseTMat:=function(A)
	local i,j,res;
	res:=NullMat(A.n_col,A.n_row);
	for i in [1..A.n_col] do
		for j in [1..A.M[i].n_entries] do
			res[i][A.M[i].inds[j]]:=A.M[i].vals[j];
		od;
	od;
	return res;
end;;

#=mult_a*a+mult_b*b
SCIntFunc.HomMult_add_mult_to_column:=function(mult_a, a, mult_b, b)
	local  i,j,res;
	res:=rec(n_entries:=0,inds:=[],vals:=[]);
	i:=1;
	j:=1;
	while(i<=a.n_entries and j <=b.n_entries)do
		if(a.inds[i]>b.inds[j]) then
			if ((mult_a*a.vals[i])<>0) then
				res.n_entries:=res.n_entries+1;
				Add(res.inds,a.inds[i]);
				Add(res.vals,(mult_a*a.vals[i]));
			fi;
			i:=i+1;
		elif (b.inds[j]>a.inds[i]) then
			if((mult_b*b.vals[j])<>0) then
				res.n_entries:=res.n_entries+1;
				Add(res.inds,b.inds[j]);
				Add(res.vals,(mult_b*b.vals[j]));
			fi;
			j:=j+1;
		else #b.inds[j]==a.inds[i]
			if ((mult_a*a.vals[i]+mult_b*b.vals[j])<>0) then
				res.n_entries:=res.n_entries+1;
				Add(res.inds,b.inds[j]);
				Add(res.vals,(mult_a*a.vals[i]+mult_b*b.vals[j]));
			fi;
			i:=i+1;
			j:=j+1;
		fi;
	od;
	while(i<=a.n_entries) do  
		#copy rest of a
		if ((mult_a*a.vals[i])<>0) then
			res.n_entries:=res.n_entries+1;
			Add(res.inds,a.inds[i]);
			Add(res.vals,(mult_a*a.vals[i]));
		fi;
		i:=i+1;	
	od;
	while(j <=b.n_entries) do
		#copy rest of b
		if((mult_b*b.vals[j])<>0) then
			res.n_entries:=res.n_entries+1;
			Add(res.inds,b.inds[j]);
			Add(res.vals,(mult_b*b.vals[j]));	
		fi;
		j:=j+1;
	od;
	return res;
end;;



SCIntFunc.HomInsert_col_to_sparse_mat:=function(matrix,vektor,col_ind)
	local i;
	matrix.M[col_ind].n_entries:=Length(vektor);
	matrix.M[col_ind].inds:=[];
	matrix.M[col_ind].vals:=[];
	
	
	for i in [Length(vektor),Length(vektor)-1..1] do
		Add(matrix.M[col_ind].inds,vektor[i][1]);
		Add(matrix.M[col_ind].vals,vektor[i][2]);
	od;

end;;



SCIntFunc.HomCopy_mat:=function(matrix)
	local i, res;
	res:=[];
	for i in [1..matrix.n_col] do
		res[i]:=rec(n_entries:=matrix.M[i].n_entries,inds:=ShallowCopy(matrix.M[i].inds),vals:=ShallowCopy(matrix.M[i].vals));
	od;
	return res;
end;;



SCIntFunc.HomIdentity_mat:=function(n_col)
	local i, res;
	res:=[];
	for i in [1..n_col] do
		res[i]:=rec(n_entries:=1,inds:=[i],vals:=[1]);
	od;
	return res;
end;;



SCIntFunc.HomGet_entry:=function(matrix,col_ind,row_ind)
	local i;
	i:=Position(matrix[col_ind].inds,row_ind);
	return matrix[col_ind].vals[i];
end;;




SCIntFunc.HomBoundaryOperatorMatrix:=function(A,B,d)
	local i,j,m,n, sign, help,dSimplex,pos,res, temp;
	n:=Size(A);
	m:=Size(B);
	
	res:=rec(n_row:=m, n_col:=n, M:=[]);
	for i in [1..res.n_col]do
		res.M[i]:=rec(n_entries:=0,inds:=[],vals:=[]);
	od;

	if (m=0) then 
		return res;
	elif (n=0) then
	
		return res;
	else
	
		for j in [1..n] do 
			sign:=1;
			temp:=[];
	
			dSimplex:=ShallowCopy(A[j]);
			for i in [1..d+1] do
				sign:=sign * (-1);
				help:=dSimplex[i];
				RemoveSet(dSimplex,help);
				pos:=Position(B,dSimplex);
				
				AddSet(temp,[pos,sign]);
				
				AddSet(dSimplex,help);
			od;
			SCIntFunc.HomInsert_col_to_sparse_mat(res,temp,j);
		od;
	
		return res;
	fi;

end;;


SCIntFunc.HomComputeBasis:=function(matrix, im, rowinvvalues) 
	local i,j,k,m,n,done,N,res,Mtemp,gcd,rs,a,b,Nhelp,Mtemphelp,AntModi, AntModj,rowinv,Mtemp_j_k;
	
	res:=rec( free:=[], torsion:=[]);
	m:=matrix.n_row;
	n:=matrix.n_col;
	N:=SCIntFunc.HomIdentity_mat(n);
	Mtemp:=matrix.M;
	
	rowinv:=0*[1..m];
	
	for i in [1..m] do	
		rowinvvalues[i]:=0;
	od;
	
	
	for i in [1..n] do
		
		done:=false;
		k:=m;
	
		while (not done) do
		
	
			if (Mtemp[i].n_entries>0) then
				k:=Mtemp[i].inds[1];
				j:=rowinv[k];
				if (j<>0) then	
	
					 Mtemp_j_k:=SCIntFunc.HomGet_entry(Mtemp,j,k);
	
					AntModi:=Mtemp[i].vals[1];
					AntModj:=Mtemp_j_k;
					if (AntModi mod AntModj=0) then
						#no torsion
						b:=(Mtemp[i].vals[1])/AntModj;
						
	
						N[i]:=SCIntFunc.HomMult_add_mult_to_column((Mtemp_j_k /AntModj),N[i],-b,N[j]);
						Mtemp[i]:=SCIntFunc.HomMult_add_mult_to_column((Mtemp_j_k /AntModj),Mtemp[i],-b,Mtemp[j]);
	
					else
						#torsion
	
						gcd:=Gcd(AntModj,AntModi);
						a:=Mtemp_j_k/gcd;
						b:=-Mtemp[i].vals[1]/gcd;
						rs:=GcdRepresentation(AntModi,AntModj);
						Nhelp:=ShallowCopy(N[j]);
						Mtemphelp:=ShallowCopy(Mtemp[j]);
						rs[1]:=rs[1]*(Mtemp_j_k/AntModj);
						rs[2]:=rs[2]*(Mtemp[i].vals[1]/AntModi);
						
						
	
						N[j]:=SCIntFunc.HomMult_add_mult_to_column(rs[2],N[j],rs[1],N[i] );	
						Mtemp[j]:=SCIntFunc.HomMult_add_mult_to_column(rs[2],Mtemp[j],rs[1],Mtemp[i] );
						
						N[i]:=SCIntFunc.HomMult_add_mult_to_column(a,N[i],b,Nhelp );
						Mtemp[i]:=SCIntFunc.HomMult_add_mult_to_column(a,Mtemp[i],b,Mtemphelp );
						
						rowinvvalues[k]:=AbsoluteValue(SCIntFunc.HomGet_entry(Mtemp,j,k));
	
					fi;
					k:=k-1;
				else			
					done:=true;
					rowinv[k]:=i;
					rowinvvalues[k]:=AbsoluteValue(SCIntFunc.HomGet_entry(Mtemp,i,k));
				fi;
			else
				gcd:=AbsoluteValue(SCIntFunc.HomGet_entry(N,i,i)) ;
				if (im[i] mod gcd<>0) then
					Info(InfoSimpcomp,1,"SCIntFunc.HomComputeBasis: DANGERWILLROBINSON -- entry not annulated. Please contact the authors/maintainers of simpcomp.");
					return fail;
				fi;
				if (im[i]=0) then
					
					AddSet(res.free,N[i]);

				elif (im[i] >gcd)then				

					AddSet(res.torsion,[im[i] /gcd,N[i]]);

				fi;
				done:=true;
			fi;	
		od;
	od;

	matrix.M:=Mtemp;
	return res;
end;;


SCIntFunc.HomCoHomologyD:=function(complex,d,mode)
	local i,s,simplices,boundaries,matrix1, matrix2, row,row2,basis, res, temp,min,smith,smith_base,tors_ord, tors_ord_test,dim;

	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	fi;
	
	simplices:=[];
	simplices[1]:=[];
	for i in [d+1..d+3] do
		simplices[i]:=[];
		if(i-2>=0 and i-2<=dim) then
			simplices[i]:=SCSkelEx(complex,i-2);
		fi;
	od;

	#calculate boundary operator matrix
	if (mode=1) then #cohomology
		matrix1:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+2],simplices[d+1],d );
		matrix2:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+3],simplices[d+2],d+1 );
		matrix1:=SCIntFunc.HomTransposeSparseMat(matrix1);
		matrix2:=SCIntFunc.HomTransposeSparseMat(matrix2);
	else #homology
		matrix2:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+2],simplices[d+1],d );
		matrix1:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+3],simplices[d+2],d+1 );
	fi;

	row:=[];
	SCIntFunc.HomComputeBasis(matrix1, 0*[1..matrix1.n_col], row); #calculate image
	row2:=[];

	basis:=SCIntFunc.HomComputeBasis(matrix2, row, row2); #calculate kernel and kernel/image
	res:=[];

	for s in basis.free do
		temp:=[];
		for i in [1..s.n_entries]do			
			#Add(temp,[s.vals[i],simplices[d+2][s.inds[i]]]);
			Add(temp,[s.vals[i],s.inds[i]]);
		od;
		AddSet(res,[1,temp]);
	od;
	
	#check torsion with smith normal form
	if(basis.torsion<>[]) then
		tors_ord_test:=1;
		tors_ord:=1;
		for i in row do
			if i<>0 then
				tors_ord:=tors_ord*i;
			fi;
		od;
		
		smith:=SmithNormalFormIntegerMatTransforms(SCIntFunc.HomSparseToDenseTMat(matrix1));
		
		if (matrix1.n_col>matrix1.n_row) then
			min:=matrix1.n_row;
		else
			min:=matrix1.n_col;
		fi;
		
		#evaluate smith-normal-form
		for s in [1..min] do		
			if (AbsInt(smith.normal[s][s])>1) then
				tors_ord_test:=tors_ord_test*smith.normal[s][s];
				temp:=[];
				smith_base:=SolutionIntMat(smith.coltrans,smith.normal[s]/smith.normal[s][s]);
				
				for i in [1..matrix1.n_row] do	
					if (smith_base[i]<>0) then
						Add(temp,[smith_base[i],i]);
					fi;
				od;
				AddSet(res,[smith.normal[s][s],temp]);
			fi;
		od;
		if (AbsInt(tors_ord)<>AbsInt(tors_ord_test)) then
			Info(InfoSimpcomp,1,"SCIntFunc.HomCoHomologyD: inconsistent results, (co)homology computation failed. Please contact the authors/maintainers of simpcomp.");		
			return fail;
		fi;
	fi;
	
	return res;
end;

SCIntFunc.HomHomologyBaseD:=function(complex,d)
	return SCIntFunc.HomCoHomologyD(complex,d,0);
end;


SCIntFunc.HomCohomologyBaseD:=function(complex,d)
	return SCIntFunc.HomCoHomologyD(complex,d,1);
end;

SCIntFunc.HomSmithN:=function( basis, matrix1,i)
	local s, temp, smith, min;
	if (basis[i].torsion<>[]) then
		temp:=[];
		smith:=SmithNormalFormIntegerMat(SCIntFunc.HomSparseToDenseTMat(matrix1));
		if (matrix1.n_col>matrix1.n_row) then
			min:=matrix1.n_row;
		else
			min:=matrix1.n_col;
		fi;
		for s in [1..min] do
			if (AbsInt(smith[s][s])>1) then
				
				AddSet(temp,[smith[s][s],[]]);
			fi;
		od;
		basis[i].torsion:=temp;
	fi;
end;



SCIntFunc.HomCoHomology:=function(complex,mode)
	local i,j,d,s,simplices,boundaries,matrix1, matrix2, row,row2,basis, res, temp,min,smith,smith_base,tors_ord, tors_ord_test,dim,globres;

	dim:=SCDim(complex);
	
	if(dim=fail) then
		return fail;
	fi;

	simplices:=[];
	for i in [1..dim+3] do
		simplices[i]:=[];
		if(i-2>=0 and i-2<=dim) then
			simplices[i]:=SCSkelEx(complex,i-2);
		fi;
	od;

	globres:=[];	
	for d in [0..dim] do
		#calculate boundary operator matrix
		if (mode=1) then #cohomology
			matrix1:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+2],simplices[d+1],d);
			matrix2:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+3],simplices[d+2],d+1);
			matrix1:=SCIntFunc.HomTransposeSparseMat(matrix1);
			matrix2:=SCIntFunc.HomTransposeSparseMat(matrix2);
		else #homology
			matrix1:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+3],simplices[d+2],d+1);
			matrix2:=SCIntFunc.HomBoundaryOperatorMatrix(simplices[d+2],simplices[d+1],d);
		fi;

		row:=[];
		SCIntFunc.HomComputeBasis(matrix1,ListWithIdenticalEntries(matrix1.n_col,0),row); #calculate image
		row2:=[];
	
		basis:=SCIntFunc.HomComputeBasis(matrix2, row, row2); #calculate kernel and kernel/image
		res:=[];
	
		for s in basis.free do
			temp:=[];
			for i in [1..s.n_entries]do			
				Add(temp,[s.vals[i],s.inds[i]]);
			od;
			AddSet(res,[1,temp]);
		od;
		
		#check torsion with smith normal form
		if(basis.torsion<>[]) then
			tors_ord_test:=1;
			tors_ord:=1;
			for i in row do
				if i<>0 then
					tors_ord:=tors_ord*i;
				fi;
			od;

			smith:=SmithNormalFormIntegerMatTransforms(SCIntFunc.HomSparseToDenseTMat(matrix1));
				
			if (matrix1.n_col>matrix1.n_row) then
				min:=matrix1.n_row;
			else
				min:=matrix1.n_col;
			fi;

			#evaluate smith-normal-form
			for s in [1..min] do		
				if (AbsInt(smith.normal[s][s])>1) then
					tors_ord_test:=tors_ord_test*smith.normal[s][s];
					temp:=[];
					smith_base:=SolutionIntMat(smith.coltrans,smith.normal[s]/smith.normal[s][s]);
					
					for i in [1..matrix1.n_row] do	
						if (smith_base[i]<>0) then
							#Add(temp,[smith_base[i],simplices[d+2][i]]);
							Add(temp,[smith_base[i],i]);
						fi;
					od;
					AddSet(res,[smith.normal[s][s],temp]);
				fi;
			od;
	
			if (AbsInt(tors_ord)<>AbsInt(tors_ord_test)) then
				Info(InfoSimpcomp,1,"SCIntFunc.HomCoHomologyD: inconsistent results, (co)homology computation failed. Please contact the authors/maintainers of simpcomp.");
				return fail;
			fi;	
		fi;
		Add(globres,res);
	od;
	
	res:=[];
	for i in [1..Length(globres)] do
		temp:=[];
		temp[1]:=0;
		temp[2]:=[];
		for j in globres[i] do
			if(j[1]=1) then
				temp[1]:=temp[1]+1;
			else
				Add(temp[2],j[1]);
			fi;
		od;

		if(i=1 and temp[1]>0 and mode=0) then
			temp[1]:=temp[1]-1;
		fi;
	
		Add(res, temp);
	od;
	return res;

end;


#calculate boundary of one simplex
#-- orientation flag=true: save orientation, false discard
SCIntFunc.boundaryOperator := function(simplex,orientation) 
	
	local b,cur,i,j,pos;

	b:=[];
	#all positions, i=kill entry
	for i in [1..Length(simplex)] do
		cur:=[];
		
		#reverse if i odd
		if((i mod 2)=1) then
			cur[1]:=-1;
			#pos:=Length(simplex)-1;
		else
			cur[1]:=1;
			#pos:=1;
		fi;
		pos:=1;
		cur[2]:=[];
		
		#extract one bounary face
		for j in [1..Length(simplex)] do
			if(i=j) then continue; fi;
			
			cur[2][pos]:=simplex[j];
			if((i mod 2)=1) then
				#pos:=pos-1;
				pos:=pos+1;
			else
				pos:=pos+1;
			fi;
		od;

		#add to list of boundary faces
		if(orientation=true) then
			Add(b,[ShallowCopy(cur[1]),ShallowCopy(cur[2])]);
		else
			Add(b,ShallowCopy(cur[2]));
		fi;
	od;
	
	return b;
end;

#calculate matrix of boundary operator mapping simplices to boundaries
#matrix: *-> d+1 simplices
#        |
#        V
#        d simplices
SCIntFunc.boundaryOperatorMatrix:=function(simplices, boundaries)
	local b,m,i,j,pos;
	
	if(boundaries=[]) then
		return [ListWithIdenticalEntries(Length(simplices),0)];
	fi;
	
	m:=[];
	for i in [1..Length(boundaries)] do
		m[i]:=[];
	od;
	
	for i in [1..Length(simplices)] do
		#get boundary of current simplex
		b:=SCIntFunc.boundaryOperator(simplices[i],true);
		
		#calculate matrix column
		for j in [1..Length(boundaries)] do
			m[j][i]:=0;
		od;

		for j in [1..Length(b)] do
			pos:=Position(boundaries,b[j][2]);
			if(pos<>fail) then
				m[pos][i]:=b[j][1];
			else
				Info(InfoSimpcomp,1,"SCIntFunc.boundaryOperatorMatrix: list of boundary simplices is not complete!");
				return fail;
			fi;
		od;
	od;
	
	return m;
end;







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
InstallGlobalFunction(SCBoundarySimplex,
function(simplex,orientation)
	if(not IsList(simplex) or not IsDuplicateFree(simplex) or not IsBool(orientation)) then
		Info(InfoSimpcomp,1,"SCBoundaryOperator: first argument must be a simplex (given as vertex tuple), second a boolean.");
		return fail;
	fi;

	return SCIntFunc.boundaryOperator(simplex,orientation);
end);



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
InstallMethod(SCBoundaryOperatorMatrixOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local d,bdm,s1,s2;
	
	if k < 0 then
		Info(InfoSimpcomp,1,"SCBoundaryOperatorMatrix: second argument must be an integer >=0.");
		return fail;
	fi;
	
	d:=SCDim(complex);
	if(d=fail) then
		return fail;
	fi;
	
	if(d < 0) then
			return [];
	fi;

	if(k>d) then
			return [[0]];
	fi;
	
	bdm:=[];
	
	s1:=SCSkelEx(complex,k);
	if(d>0) then
		s2:=SCSkelEx(complex,k-1);
	else
		s2:=[];
	fi;
	
	bdm:=SCIntFunc.boundaryOperatorMatrix(s1,s2);
	
	return bdm;
end);




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
InstallMethod(SCCoboundaryOperatorMatrixOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local bd;

	if k < 0 then
		Info(InfoSimpcomp,1,"SCCoboundaryOperatorMatrix: second argument must be an integer >=0.");
		return fail;
	fi;
	
	bd:=SCBoundaryOperatorMatrix(complex,k+1);
	
	if(bd=fail) then
		return fail;
	fi;
	
	return TransposedMat(bd);
end);


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
InstallMethod(SCHomologyBasisOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local hom,dhom,row,t,tmp,tmp2,bd1,bd2,d;

	if k < 0 then
		Info(InfoSimpcomp,1,"SCHomologyBasis: second argument must be an integer >=0.");
		return fail;
	fi;
	
	d:=SCDim(complex);
	if(d=fail) then
		return fail;
	fi;
	
	if(k>d) then
			return [];
	fi;
	
	hom:=SCIntFunc.HomHomologyBaseD(complex,k);
	
	return hom;		
end);




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
InstallMethod(SCCohomologyBasisOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local hom,dhom,row,t,tmp,tmp2,bd1,bd2,d;

	if k < 0 then
		Info(InfoSimpcomp,1,"SCCohomologyBasis: second argument must be an integer >=0.");
		return fail;
	fi;

	d:=SCDim(complex);
	if(d=fail) then
		return fail;
	fi;
	
	if(k>d) then
			return [];
	fi;
	
	hom:=SCIntFunc.HomCohomologyBaseD(complex,k);
	
	return hom;
end);



SCIntFunc.CoHomBasisToSimplexList:=
function(hom,faces)
	if(hom=[]) then
		return [];
	fi;
	
	return List(hom,
		function(x)
			if(x=[]) then
				return [];
			fi;
			return [x[1],List(x[2],y->[y[1],faces[y[2]]])];
		end);
end;


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
##   [ 2, [ [ 1, [ 11, 12 ] ], [ -1, [ 11, 13 ] ], [ -1, [ 12, 13 ] ], 
##          [ 2, [ 12, 14 ] ], [ -2, [ 13, 14 ] ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCHomologyBasisAsSimplicesOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local homsimp,hom,faces;

	if k < 0 then
		Info(InfoSimpcomp,1,"SCHomologyBasisAsSimplices: second argument must be an integer >=0.");
		return fail;
	fi;

	homsimp:=[];
	hom:=SCHomologyBasis(complex,k);
	faces:=SCSkelEx(complex,k);

	if(hom=fail or faces=fail) then
		return fail;
	fi;

	homsimp:=SCIntFunc.CoHomBasisToSimplexList(hom,faces);
	
	return homsimp;
end);

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
## [ [ 2, [ [ -9, [ 2, 7, 8, 9 ] ], [ 9, [ 2, 7, 8, 12 ] ], [ 9, [ 2, 7, 8, 13 ] ], 
##          [ -9, [ 2, 7, 11, 12 ] ], [ 9, [ 2, 7, 11, 13 ] ], [ -9, [ 2, 8, 9, 10 ] ],
##          [ -9, [ 2, 8, 9, 11 ] ], [ -18, [ 2, 8, 9, 12 ] ], [ -9, [ 2, 8, 9, 13 ] ],
##          [ 9, [ 2, 8, 10, 12 ] ], [ -9, [ 2, 8, 10, 13 ] ], 
##          [ -9, [ 2, 8, 11, 12 ] ], [ 3, [ 2, 9, 10, 12 ] ], 
##          [ -3, [ 2, 9, 11, 12 ] ], [ 3, [ 3, 4, 5, 7 ] ], [ -3, [ 3, 4, 5, 12 ] ], 
##          [ 3, [ 3, 4, 10, 12 ] ], [ -3, [ 3, 5, 6, 7 ] ], [ 3, [ 3, 5, 6, 11 ] ], 
##          [ -1, [ 3, 5, 6, 13 ] ], [ -6, [ 3, 5, 7, 8 ] ], [ 3, [ 3, 5, 7, 10 ] ], 
##          [ -6, [ 3, 5, 7, 11 ] ], [ 6, [ 3, 5, 7, 12 ] ], [ 1, [ 3, 5, 7, 13 ] ], 
##          [ 3, [ 3, 5, 8, 12 ] ], [ -1, [ 3, 5, 9, 13 ] ], [ 6, [ 3, 5, 10, 12 ] ], 
##          [ -2, [ 3, 5, 10, 13 ] ], [ 12, [ 3, 5, 11, 12 ] ], 
##          [ 7, [ 3, 5, 11, 13 ] ], [ -5, [ 3, 5, 12, 13 ] ], [ 1, [ 3, 6, 9, 13 ] ], 
##          [ 3, [ 3, 7, 10, 12 ] ], [ -9, [ 3, 7, 11, 12 ] ], [ 9, [ 3, 7, 11, 13 ] ],
##          [ 1, [ 3, 8, 9, 13 ] ], [ 12, [ 3, 8, 10, 12 ] ], [ -9, [ 3, 8, 10, 13 ] ],
##          [ -3, [ 3, 9, 10, 12 ] ], [ -1, [ 3, 9, 10, 13 ] ], 
##          [ -3, [ 3, 9, 11, 12 ] ], [ 8, [ 3, 9, 11, 13 ] ], 
##          [ -1, [ 3, 9, 12, 13 ] ], [ 6, [ 3, 10, 11, 12 ] ], 
##          [ 9, [ 3, 10, 11, 13 ] ], [ 3, [ 3, 10, 12, 13 ] ], [ 1, [ 4, 5, 6, 8 ] ], 
##          [ 3, [ 4, 5, 6, 11 ] ], [ -8, [ 4, 5, 6, 13 ] ], [ -9, [ 4, 5, 7, 8 ] ], 
##          [ -9, [ 4, 5, 7, 11 ] ], [ -18, [ 4, 6, 8, 9 ] ], [ 9, [ 4, 6, 9, 13 ] ], 
##          [ -9, [ 4, 8, 9, 10 ] ], [ -18, [ 4, 8, 9, 12 ] ], [ -9, [ 4, 8, 9, 13 ] ],
##          [ 9, [ 4, 8, 10, 12 ] ], [ -9, [ 4, 8, 10, 13 ] ], [ 3, [ 4, 9, 10, 12 ] ],
##          [ -3, [ 4, 9, 11, 12 ] ], [ -9, [ 4, 9, 12, 13 ] ], [ 10, [ 5, 6, 7, 8 ] ],
##          [ 12, [ 5, 6, 7, 11 ] ], [ 1, [ 5, 6, 7, 13 ] ], [ -19, [ 5, 6, 8, 9 ] ], 
##          [ 2, [ 5, 6, 8, 11 ] ], [ -1, [ 5, 6, 8, 12 ] ], [ -9, [ 5, 6, 8, 13 ] ], 
##          [ 3, [ 5, 6, 9, 11 ] ], [ 1, [ 5, 6, 9, 13 ] ], [ 1, [ 5, 6, 10, 13 ] ], 
##          [ -11, [ 5, 6, 11, 13 ] ], [ -9, [ 5, 7, 8, 9 ] ], [ 9, [ 5, 7, 8, 12 ] ], 
##          [ 9, [ 5, 7, 8, 13 ] ], [ -9, [ 5, 7, 11, 12 ] ], [ 9, [ 5, 7, 11, 13 ] ], 
##          [ -18, [ 5, 8, 9, 12 ] ], [ -9, [ 5, 8, 9, 13 ] ], [ 9, [ 5, 8, 10, 12 ] ],
##          [ -9, [ 5, 8, 11, 12 ] ], [ 9, [ 6, 7, 8, 13 ] ], [ 9, [ 6, 7, 11, 13 ] ], 
##          [ -9, [ 6, 8, 10, 13 ] ], [ -3, [ 6, 9, 11, 12 ] ], 
##          [ 9, [ 6, 9, 11, 13 ] ], [ 9, [ 7, 8, 9, 13 ] ], [ 9, [ 7, 8, 11, 12 ] ], 
##          [ 6, [ 7, 9, 11, 12 ] ], [ 18, [ 7, 11, 12, 13 ] ], 
##          [ -15, [ 8, 9, 10, 12 ] ], [ 9, [ 8, 9, 10, 13 ] ], 
##          [ -3, [ 8, 9, 11, 12 ] ], [ 18, [ 8, 10, 11, 12 ] ], 
##          [ -18, [ 8, 10, 12, 13 ] ], [ 6, [ 9, 10, 11, 12 ] ], 
##          [ 6, [ 9, 10, 12, 13 ] ], [ 12, [ 9, 11, 12, 13 ] ] ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCohomologyBasisAsSimplicesOp,
"for SCSimplicialComplex and Int",
[SCIsSimplicialComplex,IsInt],
function(complex,k)
	local cohomsimp,cohom,faces;

	if k < 0 then
		Info(InfoSimpcomp,1,"SCCohomologyBasisAsSimplices: second argument must be an integer >=0.");
		return fail;
	fi;

	cohomsimp:=[];
	cohom:=SCCohomologyBasis(complex,k);
	faces:=SCSkelEx(complex,k);
	if(cohom=fail or faces=fail) then
		return fail;
	fi;

	cohomsimp:=SCIntFunc.CoHomBasisToSimplexList(cohom,faces);

	return cohomsimp;
end);


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
InstallGlobalFunction(SCHomologyInternal,
function(complex)
	local d,hom;
	
	if(not SCIsSimplicialComplex(complex)) then
		Info(InfoSimpcomp,1,"SCHomologyInternal: argument must be a simplicial complex.");
		return fail;
	fi;
	
	d:=SCDim(complex);
	if(d=fail) then
		return fail;
	fi;
	
	if HasSCHomology(complex) then
		return SCHomology(complex);
	fi;

	hom:=SCIntFunc.HomCoHomology(complex,0);
	if(hom=fail) then
		return fail;
	fi;
	
	SetSCHomology(complex,hom);
	return hom;
end);


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
## gap> SCCohomology(c);
## [ [ 1, [  ] ], [ 0, [  ] ], [ 0, [ 2 ] ] ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCCohomology,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local cohom;


	cohom:=SCIntFunc.HomCoHomology(complex,1);
	if(cohom=fail) then
		return fail;
	fi;

	return cohom;
end);


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
InstallGlobalFunction(SCCupProduct,
	function(complex,cocycle1,cocycle2)

	local i, k, element, dim, cupProduct, product1, product2, 
		facets, facetsEx, frontface, backface, coeff, o;
	
	
	dim := SCDim(complex)/2;
	o := SCIsOrientable(complex);
	if o = fail then
		Info(InfoSimpcomp,1,"SCCupProduct: first argument must be an orientable simplicial complex.");
		return fail;
	fi;
	
		
	if(not IsInt(dim) or not SCIsSimplicialComplex(complex) or cocycle1 = [] or cocycle2 = [] or Size(cocycle1[1][2]) <> dim+1 or Size(cocycle2[1][2]) <> dim+1 or not o) then
		Info(InfoSimpcomp,1,"SCCupProduct: first argument must be an orientable 2k-dimensional simplicial complex, second and third argument must be non empty k-cochains.");
		return fail;
	fi;
	
	facets:=SCFacets(complex);
	facetsEx:=SCFacetsEx(complex);
	if facets = fail or facetsEx = fail then
		return fail;
	fi;
	
	if facets <> facetsEx or not IsSortedList(facets) or false in List(facets,x->IsSortedList(x)) then
		Info(InfoSimpcomp,1,"SCCupProduct: first argument must be a simplicial complex in standard labeling and with sorted facet list.");	
		return fail;
	fi;
	cupProduct:=[];	
	
	for k in [1..Size(facets)] do
		element:=ShallowCopy(facets[k]);
		frontface:=element{[1..dim+1]};
		backface:=element{[dim+1..2*dim+1]};
		product1:=[];
		for i in cocycle1 do
			if frontface = i[2] then
				product1:=i;
				break;
			fi;				
		od;
		product2:=[];
		for i in cocycle2 do
			if backface = i[2] then
				product2:=i;
				break;
			fi;				
		od;
		if product1 <> [] and product2 <> [] then
			coeff:=product1[1]*product2[1];
			Add(cupProduct,[coeff,element]);
		fi;
		
	od;
	
	return cupProduct;
	
end);

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
## [ [ 16, "CP^2 (VT)" ], [ 96, "CP^2#-CP^2" ], 
##   [ 97, "CP^2#CP^2" ], [ 185, "CP^2#(S^2xS^2)" ], 
##   [ 397, "Gaifullin CP^2" ], 
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
InstallMethod(SCIntersectionForm,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local i, j, idx1, idx2, idx, element, dim, cupProduct, product, 
		facets, frontface, backface, coeff, cocycles, orientation, sum, mat, labels,c;
	
		
	dim := SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if(dim mod 2 <> 0 or SCIsPseudoManifold(complex) <> true) then
		Info(InfoSimpcomp,1,"SCIntersectionForm: argument must be a orientable weak pseudomanifold of even dimension.");
		return fail;
	fi;
	
	facets:=SCIntFunc.DeepCopy(SCFacetsEx(complex));
	SCIntFunc.DeepSortList(facets);
	c:=SCFromFacets(facets);
	dim := dim/2;
	orientation:=SCOrientation(c);
	if orientation = fail then
		return fail;
	fi;
	if(SCIsOrientable(c) <> true) then
		Info(InfoSimpcomp,1,"SCIntersectionForm: argument must be orientable.");
		return fail;
	fi;
	
	cocycles:=SCCohomologyBasisAsSimplices(c,dim);
	if facets = fail or cocycles = fail then
		return fail;
	fi;
	
	if cocycles = [] then
			return [];
	fi;
	
	cupProduct:=[];	
	mat:=[];
	for idx1 in [1..Size(cocycles)] do
		mat[idx1]:=[];
		for idx2 in [1..Size(cocycles)] do
			product:=	SCCupProduct(c,cocycles[idx1][2],cocycles[idx2][2]);
			sum:=0;
			for j in [1..Size(product)] do
				idx:=Position(facets,product[j][2]);
				sum:=sum+orientation[idx]*product[j][1];
			od;
			mat[idx1][idx2]:=sum;
		od;
	od;
	
	return mat;
	
end);


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
InstallMethod(SCIntersectionFormParity,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local parity, i, matrix, dim;
	
	
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if(dim mod 2 <> 0 or SCIsPseudoManifold(complex) <> true) then
		Info(InfoSimpcomp,1,"SCIntersectionFormParity: argument must be a pseudomanifold of even dimension.");
		return fail;
	fi;

	matrix:=SCIntersectionForm(complex);
	if matrix = fail then
		return fail;
	fi;
	
	parity := 0;		
	for i in [1..Size(matrix)] do 
		if matrix[i][i] mod 2 <> 0 then 
			parity:=1; 
			break; 
		fi; 
	od;
	
	return parity;
end);


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
InstallMethod(SCIntersectionFormDimensionality,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local matrix, dim;

	
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if(dim mod 2 <> 0 or SCIsPseudoManifold(complex) <> true) then
		Info(InfoSimpcomp,1,"SCIntersectionFormDimensionality: argument must be a pseudomanifold of even dimension.");
		return fail;
	fi;

	matrix:=SCIntersectionForm(complex);
	if matrix = fail then
		return fail;
	fi;

	return Size(matrix);
end);


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
## gap> SCIntersectionFormSignature(d);
## [ 2, 1, 1 ]
## gap> d:=SCConnectedSumMinus(c,c);;
## gap> SCIntersectionFormSignature(d);
## [ 2, 0, 2 ]
## ]]></Example>
## </Description>
## </ManSection>
##<#/GAPDoc>
################################################################################
InstallMethod(SCIntersectionFormSignature,
"for SCSimplicialComplex",
[SCIsSimplicialComplex],
function(complex)
	local sign,matrix,charpol,coeff,dim,prod,old,idx;
	
	
	dim:=SCDim(complex);
	if dim = fail then
		return fail;
	fi;
	if(dim mod 2 <> 0 or SCIsPseudoManifold(complex) <> true) then
		Info(InfoSimpcomp,1,"SCIntersectionFormSignature: argument must be a pseudomanifold of even dimension.");
		return fail;
	fi;

	matrix:=SCIntersectionForm(complex);
	if matrix = fail then
		return fail;
	fi;
	
	dim:=Size(matrix);
	charpol:= Matrix_CharacteristicPolynomialSameField(Integers,matrix,1);
	coeff:=Reversed(CoefficientsOfLaurentPolynomial(charpol))[2];
	sign:=0;
	old:=0;
	
	for idx in [1..Size(coeff)] do 
		if coeff[idx] = 0 then continue; fi;
		
		if old = 0 then
			old := coeff[idx];
			continue;
		fi;
		
		prod:=old*coeff[idx];
		if prod = 0 then
			Info(InfoSimpcomp,1,"SCIntersectionFormSignature: Error, can not compute signature of intersection form.");
			return fail;
		fi;
		
		if not IsPosInt(Int(prod)) then
			sign := sign + 1;
		fi;
		
		old:=coeff[idx];
		
	od;

	return [dim,sign,dim-sign];
end);
