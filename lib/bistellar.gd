################################################################################
##
##  simpcomp / bistellar.gd
##
##  Functions for bistellar moves  
##
##  $Id$
##
################################################################################

## <#GAPDoc Label="bistellar">
## <Section Label="sec:bftheory"> <Heading>Theory</Heading>
##
## Since two combinatorial manifolds are already considered distinct to each 
## other as soon as they are not combinatorially isomorphic, a topological 
## PL-manifold is represented by a whole class of combinatorial manifolds. 
## Thus, a frequent question when working with combinatorial manifolds is 
## whether two such objects are PL-homeomorphic or not. One possibility to 
## approach this problem, i. e. to find combinatorially distinct members of 
## the class of a PL-manifold, is a heuristic algorithm using the concept of 
## bistellar moves.<Br/><Br/>
## <B>Definition</B> (Bistellar moves 
## <Cite Key="Pachner87KonstrMethKombHomeo"/>)<Br/>
## Let <M>M</M> be a combinatorial <M>d</M>-manifold (<M>d</M>-pseudomanifold), 
## <M>\gamma = \langle v_0 , \ldots , v_{k} \rangle </M> a <M>k</M>-face and 
## <M>\delta = \langle w_0 , \ldots , w_{d-k} \rangle</M> a 
## <M>(d-k+1)</M>-tuple of vertices of <M>M</M> that does not span a 
## <M>(d-k)</M>-face in <M>M</M>, <M>0 \leq k \leq d</M>, such that 
## <M>\{ v_0 , \ldots, v_k \} \cap \{ w_0 , \ldots , w_{d-k} \} = \emptyset </M> 
## and <M>\{ v_0 , \ldots , v_k, w_0 , \ldots w_{k-d} \}</M> spans exactly 
## <M>d-k+1</M> facets. Then the operation<Br/><Br/>
## 
## <M>\kappa_{(\gamma,\delta)} ( M ) = M \setminus (\gamma \star \partial \delta) \cup (\partial \gamma \star \delta) </M><Br/><Br/>
## 
## is called a <Emph>bistellar <M>(d-k)</M>-move</Emph>.<Br/><Br/>
## 
## In other words: If there exists a bouquet <M>D \subset M</M> of <M>d-k+1</M> 
## facets on a subset of vertices <M>W \subset V</M> of order <M>d+2</M> with a 
## common <M>k</M>-face <M>\gamma</M> and the complement <M>\delta</M> of the 
## vertices of <M>\gamma</M> in <M>W</M> does not span a <M>(d-k)</M>-face in 
## <M>M</M> we can remove <M>D</M> and replace it by a bouquet of <M>k+1</M> 
## facets <M>E \subset M</M> with vertex set <M>W</M> with a common face 
## spanned by <M>\delta</M>. By construction <M>\partial D = \partial E</M> 
## and the altered complex is again a combinatorial <M>d</M>-manifold 
## (<M>d</M>-pseudomanifold). See Fig. 11 for a bistellar <M>1</M>-move of a 
## <M>2</M>-dimensional complex, see Fig. 12 for all bistellar moves in
##  dimension <M>3</M>.<P/>
##
## 	<Alt Only="LaTeX"><![CDATA[
## 	\medskip
## 	]]>
## 	</Alt>
## 			<P/>
## 	<Alt Only="LaTeX"><![CDATA[
## 	\begin{center}
## 	\includegraphics[width=0.8\textwidth]{figures/bistellar.pdf}\\\bigskip
## 	{\small Figure 11. Bistellar $1$-move in dimension $2$ with 
##  $W = \{ 1,2,3,4 \}$.}
## 	\end{center}
## 	]]>
## 	</Alt>
## <P/>
## 	<Alt Only="LaTeX"><![CDATA[
## 	\medskip
## 	]]>
## 	</Alt>
## 			<P/>
## 	<Alt Only="LaTeX"><![CDATA[
## 	\begin{center}
## 	\includegraphics[width=\textwidth]{figures/dreiFlips.pdf}\\\bigskip
## 	{\small Figure 12. Bistellar moves in dimension $d=3$ with 
##  $W = \{ 1,2,3,4,5 \} $. On the left side a bistellar $0$- and a bistellar 
##  $3$-move, on the right side a bistellar $1$- and a bistellar $2$-move.}
##  \end{center}
## 	]]>
## 	</Alt>
## <P/>
## 
## A bistellar <M>0</M>-move is a <Emph>stellar subdivision</Emph>, i. e. the 
## subdivision of a facet <M>\delta</M> into <M>d+1</M> new facets by 
## introducing a new vertex at the center of <M>\delta</M> (cf. Fig. 12 on 
## the left). In particular, the vertex set of a combinatorial manifold 
## (pseudomanifold) is not invariant under bistellar moves. For any bistellar 
## <M>(d-k)</M>-move <M>\kappa_{(\gamma,\delta)}</M> we have an inverse 
## bistellar <M>k</M>-move <M>\kappa^{-1}_{(\gamma,\delta)} = \kappa_{(\delta,\gamma)}</M> 
## such that <M>\kappa_{(\delta,\gamma)} ( \kappa_{(\gamma,\delta)} (M)) = M</M>.
## If for two combinatorial manifolds <M>M</M> and <M>N</M> there exist a 
## sequence of bistellar moves that transforms one into the other, <M>M</M> 
## and <M>N</M> are called <Emph>bistellarly equivalent</Emph>. So far 
## bistellar moves are local operations on combinatorial manifolds that change 
## its combinatorial type. However, the strength of the concept in 
## combinatorial topology is a consequence of the following<Br/><Br/>
## 
## <B>Theorem</B> (Bistellar moves 
## <Cite Key="Pachner87KonstrMethKombHomeo"/>)<Br/>
## Two combinatorial manifolds (pseudomanifolds) <M>M</M> and <M>N</M> are 
## PL homeomorphic if and only if they are bistellarly equivalent.<Br/><Br/>
## 
## Unfortunately Pachners theorem does not guarantee that the search for a 
## connecting sequence of bistellar moves between <M>M</M> and <M>N</M> 
## terminates. Hence, using bistellar moves, we can not prove that <M>M</M> 
## and <M>N</M> are not PL-homeomorphic. However, there is a very effective 
## simulated annealing approach that is able to give a positive answer in a 
## lot of cases. The heuristic was first implemented by Bjoerner and Lutz in 
## <Cite Key="Bjoerner00SimplMnfBistellarFlips"/>. The functions presented in 
## this chapter are based on this code which can be used for several tasks:
## 
## <Alt Only="LaTeX"><![CDATA[
## \begin{itemize}
## 	\item Decide, whether two combinatorial manifolds are PL-homeomorphic,
## 	\item for a given triangulation of a PL-manifold, try to find a smaller 
## one with less vertices,
## 	\item check, if an abstract simplicial complex is a combinatorial manifold 
## by reducing all vertex links to the boundary of the $d$-simplex (this can 
## also be done using discrete Morse theory, see Chapter 
## <Ref Chap="chap:DMT" />, <Ref Meth="SCBistellarIsManifold" />).
## \end{itemize}
## 	]]>
## 	</Alt><P/>
## 	
## In many cases the heuristic reduces a given triangulation but does not 
## reach a minimal triangulation after a reasonable amount of flips. Thus, we 
## usually can not expect the algorithm to terminate. However, in some cases 
## the program normally stops after a small number of flips: 
## 
## <Alt Only="LaTeX"><![CDATA[
## \begin{itemize}
## 	\item Whenever $d=1$ (in this case the approach is deterministic),
## 	\item whenever a complex is PL-homeomorphic to the boundary of the 
##  $d$-simplex,
## 	\item in the case of some $3$-manifolds, namely $S^2 \dtimes S^1$, 
##  $S^2 \times S^1$ or $\mathbb{RP}^3$.
## \end{itemize}
## 	]]>
## 	</Alt><P/>
## Technical note: Since bistellar flips do not respect the combinatorial 
## properties of a complex, no attention to the original vertex labels is 
## payed, i. e. the flipped complex will be relabeled whenever its vertex 
## labels become different from the standard labeling (for example after every 
## reverse 0-move).<P/>
## </Section>
##
## <Section>
## <Heading>Functions for bistellar flips</Heading>
##		
##
## <#Include Label="SCBistellarOptions"/>
##
## <#Include Label="SCEquivalent"/>
## <#Include Label="SCExamineComplexBistellar"/>
## <#Include Label="SCIntFunc.SCChooseMove"/>
## <#Include Label="SCIsKStackedSphere"/>
## <#Include Label="SCBistellarIsManifold"/>
## <#Include Label="SCIsMovableComplex"/>
## <#Include Label="SCMove"/>
## <#Include Label="SCMoves"/>
## <#Include Label="SCRMoves"/>
## <#Include Label="SCRandomize"/>
## <#Include Label="SCReduceAsSubcomplex"/>
## <#Include Label="SCReduceComplex"/>
## <#Include Label="SCReduceComplexEx"/>
## <#Include Label="SCReduceComplexFast"/>
##
## </Section>
##<#/GAPDoc>

DeclareGlobalVariable("SCBistellarOptions");

DeclareGlobalFunction("SCBistellarIsManifold");

KeyDependentOperation("SCIsKStackedSphere",SCIsSimplicialComplex,IsPosInt,ReturnTrue);

DeclareOperation("SCEquivalent",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCExamineComplexBistellar",[SCIsSimplicialComplex]);
DeclareOperation("SCIsMovableComplex",[SCIsSimplicialComplex]);
DeclareOperation("SCMove",[SCIsSimplicialComplex,IsList]);
DeclareOperation("SCMoves",[SCIsSimplicialComplex]);
DeclareOperation("SCRMoves",[SCIsSimplicialComplex,IsInt]);
DeclareOperation("SCReduceAsSubcomplex",[SCIsSimplicialComplex,SCIsSimplicialComplex]);
DeclareOperation("SCReduceComplex",[SCIsSimplicialComplex]);

DeclareGlobalFunction("SCRandomize");
DeclareGlobalFunction("SCReduceComplexEx");

DeclareGlobalFunction("SCReduceComplexFast");
################################################################################
