FUNCTION a_i2fifo( data[LPM_WIDTH-1..0], wreq, rreq, aclr, sclr, clock )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL )
    RETURNS( q[LPM_WIDTH-1..0], empty, full, usedw[((lpm_numwords>2) ? ceil(log2(lpm_numwords)) : 2) - 1..0] );

