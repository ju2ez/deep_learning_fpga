FUNCTION a_fffifo( data[(lpm_width)-(1)..0],
				   wreq, rreq, clock, aclr, sclr,
				   threshlevel[CEIL(LOG2(LPM_NUMWORDS))-1..0]
				 )
    WITH( LPM_WIDTH, LPM_NUMWORDS, LPM_SHOWAHEAD, UNDERFLOW_CHECKING, OVERFLOW_CHECKING, ALLOW_RWCYCLE_WHEN_FULL)
    RETURNS	(	q[(lpm_width)-(1)..0], 
				threshold, empty, full, 
				usedw[CEIL(LOG2(LPM_NUMWORDS))-1..0]
			);

