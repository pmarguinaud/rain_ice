
#define ATTR_ARG

USE MODI_RAIN_ICE
USE XRD_GETOPTIONS
USE LOAD_MOD

IMPLICIT NONE

INTERFACE SETALL
  PROCEDURE SETALLI1
  PROCEDURE SETALLI2
  PROCEDURE SETALLX1
  PROCEDURE SETALLX2
  PROCEDURE SETALLX3
  PROCEDURE SETALLX4
  PROCEDURE SETALLL3
END INTERFACE

INTEGER                       :: KIT, KJT, KKT 
INTEGER                       :: KSIZE
INTEGER, POINTER              :: KSIZE_ALL (:)
LOGICAL                       :: OSEDIC 
LOGICAL                       :: OCND2  
CHARACTER(LEN=4)              :: HSEDIM 
CHARACTER(LEN=4)              :: HSUBG_AUCV_RC 
LOGICAL                       :: OWARM   
INTEGER                       :: KKA   
INTEGER                       :: KKU   
INTEGER                       :: KKL   
REAL                          :: PTSTEP  
INTEGER                       :: KRR     

LOGICAL, POINTER, DIMENSION(:, :, :, :)       :: LDMICRO_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PEXN_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PDZZ_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRHODJ_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRHODREF_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PEXNREF_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PPABST_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PCIT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PCLDFR_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PTHT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRVT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRCT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRRT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRIT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRST_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRGT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PSIGS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PTHS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRVS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRCS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRRS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRIS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRSS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRGS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PINPRC_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PINPRR_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PEVAP3D_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PINPRS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PINPRG_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PSEA_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PTOWN_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRHT_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :)       :: PRHS_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :)          :: PINPRH_ALL => NULL ()
REAL,    POINTER, DIMENSION(:, :, :, :, :)    :: PFPR_ALL => NULL ()

! ICE4_SEDIMENTATION_STAT
! ICE4_SEDIMENTATION_SPLIT
! ICE4_TENDENCIES      
!       ICE4_NUCLEATION
!       ICE4_RRHONG
!       ICE4_RIMLTC
!       ICE4_RSRIMCG_OLD
!       ICE4_COMPUTE_PDF
!       ICE4_RAINFR_VERT
!       ICE4_SLOW
!       ICE4_WARM
!       ICE4_FAST_RS
!       ICE4_FAST_RG
!       ICE4_FAST_RH
!       ICE4_FAST_RI
! ICE4_NUCLEATION_WRAPPER
!       ICE4_NUCLEATION

INTEGER :: IDUM, IBL
LOGICAL :: LLDIFF, LLPRINT
CHARACTER (LEN=32) :: CLCASE
INTEGER :: ICOUNT1, KLON1, ICOUNT, KLON, KFDIA
INTEGER, POINTER :: IDIFFBLOCK (:) => NULL ()
INTEGER, ALLOCATABLE :: IFDIA (:)

CALL INITOPTIONS ()
CALL GETOPTION ("--case", CLCASE, MND = .TRUE.)
CALL GETOPTION ("--diff", LLDIFF)
CALL GETOPTION ("--diff-block-list", IDIFFBLOCK)
ICOUNT1 = 0
CALL GETOPTION ("--count", ICOUNT1)
KLON1 = 0
CALL GETOPTION ("--nproma", KLON1)
CALL CHECKOPTIONS ()

OPEN (77, FORM='FORMATTED', FILE=TRIM (CLCASE)//'/RAIN_ICE.COUNT')
READ (77, *) ICOUNT
CLOSE (77)

ALLOCATE (IFDIA (ICOUNT))

CALL RAIN_ICE_LOAD_ALL (TRIM (CLCASE)//'/RAIN_ICE.CONST')

CALL OPEN_LOAD (TRIM (CLCASE)//"/RAIN_ICE")

IF (ICOUNT1 == 0) ICOUNT1 = ICOUNT

PRINT *, "-- READ"

ALLOCATE (KSIZE_ALL (ICOUNT))

DO IBL = 1, ICOUNT

  PRINT *, IBL

  CALL LOAD (ILUN_IN, KIT)
  CALL LOAD (ILUN_IN, KJT)
  CALL LOAD (ILUN_IN, KKT )

  IFDIA (IBL) = KIT
  KFDIA       = KIT
  KLON        = KIT

  IF (KLON1 == 0) KLON1 = KLON


  CALL LOAD (ILUN_IN, KSIZE)
  CALL LOAD (ILUN_IN, OSEDIC)
  CALL LOAD (ILUN_IN, OCND2)
  CALL LOAD (ILUN_IN, HSEDIM)
  CALL LOAD (ILUN_IN, HSUBG_AUCV_RC)
  CALL LOAD (ILUN_IN, OWARM)
  CALL LOAD (ILUN_IN, KKA)
  CALL LOAD (ILUN_IN, KKU)
  CALL LOAD (ILUN_IN, KKL)
  CALL LOAD (ILUN_IN, PTSTEP)
  CALL LOAD (ILUN_IN, KRR)

#define SET(x) CALL SETALL (x##_ALL)

  SET (LDMICRO)
  SET (PEXN)
  SET (PDZZ)
  SET (PRHODJ)
  SET (PRHODREF)
  SET (PEXNREF)
  SET (PPABST)
  SET (PCIT)
  SET (PCLDFR)
  SET (PTHT)
  SET (PRVT)
  SET (PRCT)
  SET (PRRT)
  SET (PRIT)
  SET (PRST)
  SET (PRGT)
  SET (PSIGS)
  SET (PTHS)
  SET (PRVS)
  SET (PRCS)
  SET (PRRS)
  SET (PRIS)
  SET (PRSS)
  SET (PRGS)
  SET (PINPRC)
  SET (PINPRR)
  SET (PEVAP3D)
  SET (PINPRS)
  SET (PINPRG)
  SET (PSEA )
  SET (PTOWN)
  SET (PRHT)
  SET (PRHS)
  SET (PINPRH)
  SET (PFPR)
#undef SET

  KSIZE_ALL (IBL) = COUNT (LDMICRO_ALL (:,:,:,IBL))

ENDDO


DO IBL = 1, ICOUNT

CALL RAIN_ICE ( KIT, KJT, KKT, KSIZE_ALL (IBL),                         &
                OSEDIC, OCND2, HSEDIM, HSUBG_AUCV_RC, OWARM,KKA,KKU,KKL,&
                PTSTEP, KRR, LDMICRO_ALL (:,:,:,IBL), PEXN_ALL (:,:,:,IBL),     &
                PDZZ_ALL (:,:,:,IBL), PRHODJ_ALL (:,:,:,IBL), PRHODREF_ALL (:,:,:,IBL), &
                PEXNREF_ALL (:,:,:,IBL), PPABST_ALL (:,:,:,IBL), PCIT_ALL (:,:,:,IBL), &
                PCLDFR_ALL (:,:,:,IBL), PTHT_ALL (:,:,:,IBL), PRVT_ALL (:,:,:,IBL), &
                PRCT_ALL (:,:,:,IBL), PRRT_ALL (:,:,:,IBL), PRIT_ALL (:,:,:,IBL), &
                PRST_ALL (:,:,:,IBL), PRGT_ALL (:,:,:,IBL), PTHS_ALL (:,:,:,IBL), &
                PRVS_ALL (:,:,:,IBL), PRCS_ALL (:,:,:,IBL), PRRS_ALL (:,:,:,IBL), &
                PRIS_ALL (:,:,:,IBL), PRSS_ALL (:,:,:,IBL), PRGS_ALL (:,:,:,IBL), &
                PINPRC_ALL (:,:,IBL), PINPRR_ALL (:,:,IBL), PEVAP3D_ALL (:,:,:,IBL), &
                PINPRS_ALL (:,:,IBL), PINPRG_ALL (:,:,IBL), PSIGS_ALL (:,:,:,IBL), &
                PSEA_ALL (:,:,IBL), PTOWN_ALL (:,:,IBL), PRHT_ALL (:,:,:,IBL), &
                PRHS_ALL (:,:,:,IBL), PINPRH_ALL (:,:,IBL), PFPR_ALL (:,:,:,:,IBL))

ENDDO

#ifdef UNDEF


#define SAVEA(x) CALL SAVE (ILUN_OUT, x, LBOUND (x), UBOUND (x)); IDUM 

SAVEA (PCIT) = 0
SAVEA (PTHS) = 0
SAVEA (PRVS) = 0
SAVEA (PRCS) = 0
SAVEA (PRRS) = 0
SAVEA (PRIS) = 0
SAVEA (PRSS) = 0
SAVEA (PRGS) = 0
SAVEA (PINPRC) = 0
SAVEA (PINPRR) = 0
SAVEA (PEVAP3D) = 0
SAVEA (PINPRS) = 0
SAVEA (PINPRG) = 0
SAVEA (PRHS) = 0
SAVEA (PINPRH) = 0
SAVEA (PFPR) = 0

CALL CLOSE_SAVE 

#endif

CONTAINS

#include "contains.h"

END PROGRAM
