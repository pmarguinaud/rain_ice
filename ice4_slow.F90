SUBROUTINE ICE4_SLOW(KSIZE, LDSOFT, PCOMPUTE, PRHODREF, PT, &
                     &PSSI, PLVFACT, PLSFACT, &
                     &PRVT, PRCT, PRIT, PRST, PRGT, &
                     &PLBDAS, PLBDAG, &
                     &PAI, PCJ, &
                     &PRCHONI, PRVDEPS, PRIAGGS, PRIAUTS, PRVDEPG, &
                     &PA_TH, PA_RV, PA_RC, PA_RI, PA_RS, PA_RG)
!!
!!**  PURPOSE
!!    -------
!!      Computes the slow process
!!
!!    AUTHOR
!!    ------
!!      S. Riette from the splitting of rain_ice source code (nov. 2014)
!!
!!    MODIFICATIONS
!!    -------------
!!
!
!
!*      0. DECLARATIONS
!          ------------
!
USE MODD_CST
USE MODD_RAIN_ICE_PARAM
USE MODD_RAIN_ICE_DESCR
USE PARKIND1, ONLY : JPRB
!
IMPLICIT NONE
!
!*       0.1   Declarations of dummy arguments :
!
INTEGER,                      INTENT(IN)    :: KSIZE
LOGICAL,                      INTENT(IN)    :: LDSOFT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PCOMPUTE
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRHODREF ! Reference density
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PT       ! Temperature
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PSSI     ! Supersaturation over ice
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLVFACT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLSFACT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRVT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRCT     ! Cloud water m.r. at t
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRIT     ! Pristine ice m.r. at t
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRST     ! Snow/aggregate m.r. at t
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRGT     ! Graupel/hail m.r. at t
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLBDAS   ! Slope parameter of the aggregate distribution
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLBDAG   ! Slope parameter of the graupel   distribution
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PAI      ! Thermodynamical function
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PCJ      ! Function to compute the ventilation coefficient
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCHONI  ! Homogeneous nucleation
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRVDEPS  ! Deposition on r_s
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIAGGS  ! Aggregation on r_s
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIAUTS  ! Autoconversion of r_i for r_s production
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRVDEPG  ! Deposition on r_g
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_TH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_RV
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_RC
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_RI
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_RS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PA_RG
!
!*       0.2  declaration of local variables
!
REAL, DIMENSION(KSIZE) :: ZCRIAUTI
REAL            :: ZTIMAUTIC,ZRCHONI
REAL, DIMENSION(KSIZE) :: ZMASK
INTEGER :: JL
!-------------------------------------------------------------------------------
!
!
!-------------------------------------------------------------------------------
!
!
!*       3.2     compute the homogeneous nucleation source: RCHONI
!
DO JL=1, KSIZE
  ZMASK(JL)=MAX(0., -SIGN(1., PT(JL)-(XTT-35.0))) * & ! PT(:)<XTT-35.0
           &MAX(0., -SIGN(1., XRTMIN(2)-PRCT(JL))) * & ! PRCT(:)>XRTMIN(2)
           &PCOMPUTE(JL)
ENDDO
IF(LDSOFT) THEN
  DO JL=1, KSIZE
    PRCHONI(JL) = PRCHONI(JL) * ZMASK(JL)
  ENDDO
ELSE
  PRCHONI(:) = 0.
  WHERE(ZMASK(:)==1.)
    PRCHONI(:) = XHON*PRHODREF(:)*PRCT(:)       &
                                 *EXP( XALPHA3*(PT(:)-XTT)-XBETA3 )
  ENDWHERE
ENDIF
DO JL=1, KSIZE
  ZRCHONI=MIN(PRCHONI(JL),1000.)
  PA_RI(JL) = PA_RI(JL) + ZRCHONI
  PA_RC(JL) = PA_RC(JL) - ZRCHONI
  PA_TH(JL) = PA_TH(JL) + ZRCHONI*(PLSFACT(JL)-PLVFACT(JL))
ENDDO
!
!*       3.4    compute the deposition, aggregation and autoconversion sources
!
!
!*       3.4.2  compute the riming-conversion of r_c for r_i production: RCAUTI
!
!  ZZW(:) = 0.0
!  ZTIMAUTIC = SQRT( XTIMAUTI*XTIMAUTC )
!  WHERE ( (PRCT(:)>0.0) .AND. (PRIT(:)>0.0) .AND. (PRCS(:)>0.0) )
!    ZZW(:) = MIN( PRCS(:),ZTIMAUTIC * MAX( SQRT( PRIT(:)*PRCT(:) ),0.0 ) )
!    PRIS(:) = PRIS(:) + ZZW(:)
!    PRCS(:) = PRCS(:) - ZZW(:)
!    PTHS(:) = PTHS(:) + ZZW(:)*(PLSFACT(:)-PLVFACT(:)) ! f(L_f*(RCAUTI))
!  END WHERE
!
!*       3.4.3  compute the deposition on r_s: RVDEPS
!
DO JL=1, KSIZE
  ZMASK(JL)=MAX(0., -SIGN(1., XRTMIN(1)-PRVT(JL))) * & !PRVT(:)>XRTMIN(1)
           &MAX(0., -SIGN(1., XRTMIN(5)-PRST(JL))) * & !PRST(:)>XRTMIN(5)
           &PCOMPUTE(JL)
ENDDO
IF(LDSOFT) THEN
  DO JL=1, KSIZE
    PRVDEPS(JL)=PRVDEPS(JL)*ZMASK(JL)
  ENDDO
ELSE
  PRVDEPS(:) = 0.
  WHERE(ZMASK(:)==1.)
    PRVDEPS(:) = ( PSSI(:)/(PRHODREF(:)*PAI(:)) ) *                               &
                 ( X0DEPS*PLBDAS(:)**XEX0DEPS + X1DEPS*PCJ(:)*PLBDAS(:)**XEX1DEPS )
  END WHERE
ENDIF
DO JL=1, KSIZE
  PA_RS(JL) = PA_RS(JL) + PRVDEPS(JL)
  PA_RV(JL) = PA_RV(JL) - PRVDEPS(JL)
  PA_TH(JL) = PA_TH(JL) + PRVDEPS(JL)*PLSFACT(JL)
ENDDO
!
!*       3.4.4  compute the aggregation on r_s: RIAGGS
!
DO JL=1, KSIZE
  ZMASK(JL)=MAX(0., -SIGN(1., XRTMIN(4)-PRIT(JL))) * & ! PRIT(:)>XRTMIN(4)
           &MAX(0., -SIGN(1., XRTMIN(5)-PRST(JL))) * & ! PRST(:)>XRTMIN(5)
           &PCOMPUTE(JL)
ENDDO
IF(LDSOFT) THEN
  DO JL=1, KSIZE
    PRIAGGS(JL)=PRIAGGS(JL) * ZMASK(JL)
  ENDDO
ELSE
  PRIAGGS(:) = 0.
  WHERE(ZMASK(:)==1)
    PRIAGGS(:) = XFIAGGS * EXP( XCOLEXIS*(PT(:)-XTT) ) &
                         * PRIT(:)                      &
                         * PLBDAS(:)**XEXIAGGS          &
                         * PRHODREF(:)**(-XCEXVT)
  END WHERE
ENDIF
DO JL=1, KSIZE
  PA_RS(JL) = PA_RS(JL) + PRIAGGS(JL)
  PA_RI(JL) = PA_RI(JL) - PRIAGGS(JL)
ENDDO
!
!*       3.4.5  compute the autoconversion of r_i for r_s production: RIAUTS
!
DO JL=1, KSIZE
  ZMASK(JL)=MAX(0., -SIGN(1., XRTMIN(4)-PRIT(JL))) * & ! PRIT(:)>XRTMIN(4)
           &PCOMPUTE(JL)
ENDDO
IF(LDSOFT) THEN
  DO JL=1, KSIZE
    PRIAUTS(JL) = PRIAUTS(JL) * ZMASK(JL)
  ENDDO
ELSE
  PRIAUTS(:) = 0.
  !ZCRIAUTI(:)=MIN(XCRIAUTI,10**(0.06*(PT(:)-XTT)-3.5))
  ZCRIAUTI(:)=MIN(XCRIAUTI,10**(XACRIAUTI*(PT(:)-XTT)+XBCRIAUTI))
  WHERE(ZMASK(:)==1.)
    PRIAUTS(:) = XTIMAUTI * EXP( XTEXAUTI*(PT(:)-XTT) ) &
                          * MAX( PRIT(:)-ZCRIAUTI(:),0.0 )
  END WHERE
ENDIF
DO JL=1, KSIZE
  PA_RS(JL) = PA_RS(JL) + PRIAUTS(JL)
  PA_RI(JL) = PA_RI(JL) - PRIAUTS(JL)
ENDDO
!
!*       3.4.6  compute the deposition on r_g: RVDEPG
!
!
DO JL=1, KSIZE
  ZMASK(JL)=MAX(0., -SIGN(1., XRTMIN(1)-PRVT(JL))) * & ! PRVT(:)>XRTMIN(1)
           &MAX(0., -SIGN(1., XRTMIN(6)-PRGT(JL))) * & ! PRGT(:)>XRTMIN(6)
           &PCOMPUTE(JL)
ENDDO
IF(LDSOFT) THEN
  DO JL=1, KSIZE
    PRVDEPG(JL) = PRVDEPG(JL) * ZMASK(JL)
  ENDDO
ELSE
  PRVDEPG(:) = 0.
  WHERE(ZMASK(:)==1.)
    PRVDEPG(:) = ( PSSI(:)/(PRHODREF(:)*PAI(:)) ) *                               &
                 ( X0DEPG*PLBDAG(:)**XEX0DEPG + X1DEPG*PCJ(:)*PLBDAG(:)**XEX1DEPG )
  END WHERE
ENDIF
DO JL=1, KSIZE
  PA_RG(JL) = PA_RG(JL) + PRVDEPG(JL)
  PA_RV(JL) = PA_RV(JL) - PRVDEPG(JL)
  PA_TH(JL) = PA_TH(JL) + PRVDEPG(JL)*PLSFACT(JL)
ENDDO
!
!
END SUBROUTINE ICE4_SLOW
