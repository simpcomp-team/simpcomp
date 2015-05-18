# Abstract #

**simpcomp** is a **GAP** package for working with simplicial complexes. It allows the computation of many properties of simplicial complexes (such as the f-, g- and h-vectors, the face lattice, the automorphism group, (co-)homology with explicit basis computation, intersection form, etc.) and provides the user with functions to compute new complexes from old (simplex links and stars, connected sums, cartesian products, handle additions, bistellar flips, etc.). Furthermore, it comes with an extensive library of known triangulations of manifolds and provides the user with the possibility to create own complex libraries.

simpcomp caches computed properties of a simplicial complex, thus avoiding unnecessary computations, internally handles the vertex labeling of the complexes and insures the consistency of a simplicial complex throughout all operations.

simpcomp relies on the GAP package **homology** [[DHSW04](Bibliography.md)] for its homology computation, but also provides the user with an own (co-)homology algorithm in case the packacke homology is not available. For automorphism group computation the **GAP** package **GRAPE** [[Soi06](Bibliography.md)] is used, which in turn uses the program **nauty** by Brendan Mc Kay [[McK84](Bibliography.md)]. An internal automorphism group calculation algorithm in used as fallback if the **GRAPE** package is not available.

  * [Online documentation](http://simpcomp.googlecode.com/git/web/chap0.html)
  * [Manual](http://simpcomp.googlecode.com/git/web/manual.pdf) (PDF)
  * **simpcomp** - a GAP toolbox for simplicial complexes. _ACM Communications in Computer Algebra_, 44(4):186 - 189, 2010 [arXiv:1004.1367v2](http://arxiv.org/abs/1004.1367).
  * Simplicial blowups and discrete normal surfaces in the GAP package **simpcomp**. _ACM Communications in Computer Algebra_, 45(3):173 - 176, 2011 [arXiv:1105.5298v1](http://arxiv.org/abs/1105.5298).

# Download and Installation #

See [DownloadAndInstallation](DownloadAndInstallation.md)

# Current Version #
&lt;wiki:gadget url="http://simpcomp.googlecode.com/git/web/gccurversion.xml" border="0" width="100%" height="100"&gt;

See full [Changelog](Changelog.md)

# Awards #

**simpcomp** was awarded the "Best Software Presentation Award" by the [Fachgruppe Computeralgebra](http://www.fachgruppe-computeralgebra.de/) for a presentation given at [ISSAC 2010](http://www.issac-conference.org/2010/) in Munich, July 26, 2010.

See also [TalksAndConferences](TalksAndConferences.md).

# Contributors #

  * [Priv.-Doz. Dr. Frank H. Lutz](http://www.math.tu-berlin.de/~lutz/): GAP programs **BISTELLAR**, **BISTELLAR\_EQUIVALENT** and **MANIFOLD\_VT** used as basis for bistellar moves implementation and transitive complex enumeration.
  * Armin Weiß: simpcomp homology code.
  * Alexander Thumm: faster code for bistellar moves (coming up)

# Wiki pages #

  * [DownloadAndInstallation](DownloadAndInstallation.md)
  * [TalksAndConferences](TalksAndConferences.md)
  * [Roadmap](Roadmap.md)
  * [Changelog](Changelog.md)
  * [HowToCiteSimpcomp](HowToCiteSimpcomp.md)
  * [Bibliography](Bibliography.md)



