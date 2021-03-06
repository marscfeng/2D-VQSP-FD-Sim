!=======================================================================

SUBROUTINE  INH_V_W_2ND(L, MXL, MXH, PL,                               &
                           MXT, MX1, PXH,                              &
                           MZL, MZH,  TPML,                            &
                           X_MIN, X_MAX,                               &
                           JMT, QZPT,                                  &
                           REL1_WT, REL2_WT, REL3_WT, REL3_QZT,        &
                           WT, QZT,                                    &
                           TZZT, TXZT, PREST,                          &
                                           RZXLT, RZXHT,               &
ODA_XL,  ODB_XL,  ODC_XL,  ODD_XL,  ODA_XH,  ODB_XH,  ODC_XH,  ODD_XH  &
                       )

  USE PRECISION   , ONLY:                                              &
                          PP, IK
  USE GRID_MEDIUM , ONLY:                                              &
                          JMNUM

!-----------------------------------------------------------------------

  IMPLICIT NONE

  INTEGER    ,                                        INTENT(IN)    :: &
                                             L, MXL, MXH, PL, MXT, PXH,&
                                                MZL, MZH,  TPML,       &
                                                MX1, X_MIN, X_MAX
  INTEGER(IK), DIMENSION (MXL:MXH,          MZL:MZH), INTENT(INOUT) :: &
                                                                    JMT
  REAL   (PP), DIMENSION (1:JMNUM                  ), INTENT(INOUT) :: &
                                    REL1_WT, REL2_WT, REL3_WT, REL3_QZT
  REAL   (PP), DIMENSION (MXL:MXH,          MZL:MZH), INTENT(INOUT) :: &
                                                      TXZT, TZZT, PREST
  REAL   (PP), DIMENSION (PL :2  ,          MZL:MZH), INTENT(INOUT) :: &
                                                                  RZXLT
  REAL   (PP), DIMENSION (MX1:PXH,          MZL:MZH), INTENT(INOUT) :: &
                                                                  RZXHT
  REAL   (PP), DIMENSION (MXL:MXH,          MZL:MZH), INTENT(INOUT) :: &
                                                            QZPT, WT,QZT
  REAL   (PP), DIMENSION ( 0:TPML,          MZL:MZH), INTENT(INOUT) :: &
  ODA_XL,  ODB_XL,  ODC_XL,  ODD_XL,  ODA_XH,  ODB_XH,  ODC_XH,  ODD_XH

  INTEGER   :: I, IN2, IN3, JM1, IO
  REAL (PP) :: DXZXA

!-----------------------------------------------------------------------

IN2  = L-1
IN3  = L

!_____________________________________________________________ LEFT ____
  DO  I = MAX(2 - TPML,X_MIN), MIN(2,X_MAX)

    JM1 = JMT (I  ,L   )

    DXZXA         = TXZT (I+1,    L    ) - TXZT (I  ,    L    )

    WT (I,  L ) = WT (I,  L )                                                                       &
                  + (REL2_WT(JM1)/REL3_QZT(JM1)) * (1._PP - EXP(- REL3_QZT(JM1))) * QZPT  (I,  L )  &
                              + REL1_WT(JM1) *                                                      &
                 (     TZZT (I  ,    IN3  ) - TZZT (I  ,    IN2  )                                  &
                 + ODA_XL (2-I  ,  L) * ( ODD_XL (2-I  ,  L)*DXZXA                                  &
                                        + RZXLT(I,  L)             ) )                              &
                              + REL3_WT(JM1) *                                                      &
                  (PREST (I  ,    IN3  ) - PREST (I  ,    IN2  ))
    
    RZXLT (I,  L )= ODB_XL (2-I,  L) * RZXLT(I,  L)                      &
                  + ODC_XL (2-I,  L) * DXZXA

  END DO

!____________________________________________________________ RIGHT ____
  DO  I = MAX(MX1,X_MIN) , MIN(MX1  + TPML,X_MAX)

    JM1 = JMT (I  ,    L   )

    DXZXA         = TXZT (I+1,    L    ) - TXZT (I  ,    L    )

    WT (I,  L ) = WT (I,  L )                                                                       &
                  + (REL2_WT(JM1)/REL3_QZT(JM1)) * (1._PP - EXP(- REL3_QZT(JM1))) * QZPT  (I,  L )  &
                              + REL1_WT(JM1) *                                                      &
                 (     TZZT (I  ,    IN3  ) - TZZT (I  ,    IN2  )                                  &
                 + ODA_XH (I-MX1,  L) * ( ODD_XH (I-MX1,  L)*DXZXA                                  &
                                        + RZXHT(I,  L)             ) )                              &
                              + REL3_WT(JM1) *                                                      &
                  (PREST (I  ,    IN3  ) - PREST (I  ,    IN2  ))

    RZXHT (I,  L )= ODB_XH (I-MX1,  L) * RZXHT(I,  L)                  &
                  + ODC_XH (I-MX1,  L) * DXZXA

  END DO


END SUBROUTINE  INH_V_W_2ND
