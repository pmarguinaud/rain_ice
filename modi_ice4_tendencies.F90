MODULE MODI_ICE4_TENDENCIES
INTERFACE
SUBROUTINE ICE4_TENDENCIES(KSIZE, KIB, KIE, KIT, KJB, KJE, KJT, KKB, KKE, KKT, KKL, &
                          &KRR, LDSOFT, PCOMPUTE, &
                          &OWARM, HSUBG_RC_RR_ACCR, HSUBG_RR_EVAP, HSUBG_AUCV_RC, HSUBG_PR_PDF, &
                          &PEXN, PRHODREF, PLVFACT, PLSFACT, LDMICRO, K1, K2, K3, &
                          &PPRES, PCF, PSIGMA_RC, &
                          &PCIT, &
                          &PT, PTHT, &
                          &PRVT, PRCT, PRRT, PRIT, PRST, PRGT, PRHT, PRRT3D, &
                          &PRVHENI_MR, PRRHONG_MR, PRIMLTC_MR, PRSRIMCG_MR, &
                          &PRCHONI, PRVDEPS, PRIAGGS, PRIAUTS, PRVDEPG, &
                          &PRCAUTR, PRCACCR, PRREVAV, &
                          &PRCRIMSS, PRCRIMSG, PRSRIMCG, PRRACCSS, PRRACCSG, PRSACCRG, PRSMLTG, PRCMLTSR, &
                          &PRICFRRG, PRRCFRIG, PRICFRR, PRCWETG, PRIWETG, PRRWETG, PRSWETG, &
                          &PRCDRYG, PRIDRYG, PRRDRYG, PRSDRYG, PRWETGH, PRWETGH_MR, PRGMLTR, &
                          &PRCWETH, PRIWETH, PRSWETH, PRGWETH, PRRWETH, &
                          &PRCDRYH, PRIDRYH, PRSDRYH, PRRDRYH, PRGDRYH, PRDRYHG, PRHMLTR, &
                          &PRCBERI, &
                          &PRS_TEND, PRG_TEND, PRH_TEND, PSSI, &
                          &PA_TH, PA_RV, PA_RC, PA_RR, PA_RI, PA_RS, PA_RG, PA_RH, &
                          &PB_TH, PB_RV, PB_RC, PB_RR, PB_RI, PB_RS, PB_RG, PB_RH, &
                          &PHLC_HCF, PHLC_LCF, PHLC_HRC, PHLC_LRC, PRAINFR)
IMPLICIT NONE
INTEGER,                      INTENT(IN)    :: KSIZE, KIB, KIE, KIT, KJB, KJE, KJT, KKB, KKE, KKT, KKL
INTEGER,                      INTENT(IN)    :: KRR
LOGICAL,                      INTENT(IN)    :: LDSOFT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PCOMPUTE
LOGICAL,                      INTENT(IN)    :: OWARM
CHARACTER*80,                 INTENT(IN)    :: HSUBG_RC_RR_ACCR
CHARACTER*80,                 INTENT(IN)    :: HSUBG_RR_EVAP
CHARACTER(len=4),             INTENT(IN)    :: HSUBG_AUCV_RC
CHARACTER*80,                 INTENT(IN)    :: HSUBG_PR_PDF ! pdf for subgrid precipitation
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PEXN
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRHODREF
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLVFACT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PLSFACT
LOGICAL, DIMENSION(KIT,KJT,KKT), INTENT(IN) :: LDMICRO
INTEGER, DIMENSION(KSIZE),    INTENT(IN)    :: K1
INTEGER, DIMENSION(KSIZE),    INTENT(IN)    :: K2
INTEGER, DIMENSION(KSIZE),    INTENT(IN)    :: K3
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PPRES
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PCF
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PSIGMA_RC
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PCIT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PTHT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRVT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRCT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRRT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRIT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRST
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRGT
REAL, DIMENSION(KSIZE),       INTENT(IN)    :: PRHT
REAL, DIMENSION(KIT,KJT,KKT), INTENT(IN)    :: PRRT3D
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRVHENI_MR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRHONG_MR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIMLTC_MR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSRIMCG_MR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCHONI
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRVDEPS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIAGGS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIAUTS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRVDEPG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCAUTR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCACCR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRREVAV
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCRIMSS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCRIMSG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSRIMCG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRACCSS
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRACCSG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSACCRG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSMLTG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCMLTSR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRICFRRG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRCFRIG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRICFRR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCWETG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIWETG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRWETG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSWETG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCDRYG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIDRYG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRDRYG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSDRYG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRWETGH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRWETGH_MR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRGMLTR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCWETH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIWETH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSWETH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRGWETH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRWETH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCDRYH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRIDRYH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRSDRYH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRRDRYH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRGDRYH
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRDRYHG
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRHMLTR
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PRCBERI
REAL, DIMENSION(KSIZE, 8),    INTENT(INOUT) :: PRS_TEND
REAL, DIMENSION(KSIZE, 8),    INTENT(INOUT) :: PRG_TEND
REAL, DIMENSION(KSIZE, 10),   INTENT(INOUT) :: PRH_TEND
REAL, DIMENSION(KSIZE),       INTENT(INOUT) :: PSSI
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_TH
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RV
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RC
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RR
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RI
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RS
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RG
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PA_RH
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_TH
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RV
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RC
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RR
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RI
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RS
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RG
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PB_RH
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PHLC_HCF
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PHLC_LCF
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PHLC_HRC
REAL, DIMENSION(KSIZE),       INTENT(OUT)   :: PHLC_LRC
REAL, DIMENSION(KIT,KJT,KKT), INTENT(OUT)   :: PRAINFR   ! Rain fraction
END SUBROUTINE ICE4_TENDENCIES
END INTERFACE
END MODULE MODI_ICE4_TENDENCIES
