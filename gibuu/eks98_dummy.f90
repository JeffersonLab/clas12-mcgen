!*********************************************************************

!...Dummy routine, to be removed when PDFLIB is to be linked.

      subroutine eks98(x,q,a,ruv,rdv,ru,rd,rs,rc,rb,rt,rg)

!...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)

!...Commonblocks.

      COMMON/PYDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      integer MSTU,MSTJ
      double precision PARU,PARJ
      SAVE /PYDAT1/

      WRITE(MSTU(11),5000)
      IF(PYR(0).LT.10D0) STOP

!...Format for error printout.
5000 FORMAT(1X,'Error: you did not link PDFLIB correctly.',1X,'Dummy routine EKS98 in PYTHIA file called instead.',1X,'Execution stopped!')
 
      RETURN
      END

