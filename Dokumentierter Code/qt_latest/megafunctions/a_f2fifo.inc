FUNCTION a_f2fifo(	data[lpm_width-1..0], 
					rreq, wreq, clock, aclr, sclr,
					threshlevel[ceil(log2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL, DEVICE_FAMILY, CARRY_CHAIN )
    RETURNS(	q[lpm_width-1..0], 
    			threshold, empty, full,
    			usedw[ceil(log2(LPM_NUMWORDS))-1..0], 
    			usedw_eq[lpm_numwords-1..0]
    	   );
